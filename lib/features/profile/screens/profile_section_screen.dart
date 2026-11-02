// Editable profile sections. Fields are saved to users/{uid} under the same
// flat keys the website's profile page uses, so a student can fill their
// profile on either and universities see the same data.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../providers/profile_provider.dart';
import '../../applications/data/admission_service.dart' show shareDetailsWithActiveApplications;

enum _Kind { text, phone, number, date, choice }

class _F {
  final String key;
  final String label;
  final String hint;
  final _Kind kind;
  final List<String> options;
  /// Older places the same value may live (onboarding wrote nested maps).
  final List<String> legacy;
  const _F(this.key, this.label, {this.hint = '', this.kind = _Kind.text, this.options = const [], this.legacy = const []});
}

const _boards = ['CBSE', 'ICSE / ISC', 'State Board', 'NIOS', 'IB', 'Other'];
const _states = [
  'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Delhi', 'Goa', 'Gujarat', 'Haryana',
  'Himachal Pradesh', 'Jammu & Kashmir', 'Jharkhand', 'Karnataka', 'Kerala', 'Ladakh', 'Madhya Pradesh', 'Maharashtra',
  'Manipur', 'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Puducherry', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu',
  'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal', 'Andaman & Nicobar', 'Chandigarh',
  'Dadra & Nagar Haveli and Daman & Diu', 'Lakshadweep',
];

class ProfileSection {
  final String title;
  final String intro;
  final List<_F> fields;
  const ProfileSection(this.title, this.intro, this.fields);
}

const profileSections = <String, ProfileSection>{
  'personal': ProfileSection('Personal information', 'As it appears on your Class 10 certificate.', [
    _F('fullName', 'Full name', hint: 'e.g. Aarav Sharma', legacy: ['personal.fullName', 'displayName']),
    _F('phone', 'Mobile number', hint: '10-digit number', kind: _Kind.phone, legacy: ['personal.phone']),
    _F('dob', 'Date of birth', kind: _Kind.date, legacy: ['personal.dob']),
    _F('gender', 'Gender', kind: _Kind.choice, options: ['Female', 'Male', 'Other', 'Prefer not to say'], legacy: ['personal.gender']),
    _F('nationality', 'Nationality', hint: 'Indian'),
  ]),
  'academic': ProfileSection('Academic details', 'Universities check these against your marksheets.', [
    _F('tenthBoard', 'Class 10 board', kind: _Kind.choice, options: _boards, legacy: ['academic.board10']),
    _F('tenthYear', 'Class 10 passing year', hint: 'e.g. 2022', kind: _Kind.number, legacy: ['academic.year10']),
    _F('tenthScore', 'Class 10 percentage', hint: 'e.g. 91.4', kind: _Kind.number, legacy: ['academic.marks10', 'tenthPercentage']),
    _F('school', 'Class 12 school', hint: 'School name', legacy: ['academic.school12']),
    _F('twelfthBoard', 'Class 12 board', kind: _Kind.choice, options: _boards, legacy: ['academic.board12']),
    _F('stream', 'Class 12 stream', kind: _Kind.choice, options: ['PCM', 'PCB', 'PCMB', 'Commerce', 'Humanities', 'Other'], legacy: ['academic.stream']),
    _F('twelfthYear', 'Class 12 passing year', hint: 'e.g. 2024', kind: _Kind.number, legacy: ['academic.year12']),
    _F('twelfthScore', 'Class 12 percentage', hint: 'Leave empty if results are awaited', kind: _Kind.number, legacy: ['academic.marks12', 'twelfthPercentage']),
  ]),
  'guardian': ProfileSection('Parent / guardian', 'Universities contact them for fee and hostel matters.', [
    _F('guardianName', 'Name', hint: 'Parent or guardian name'),
    _F('guardianRelation', 'Relationship', kind: _Kind.choice, options: ['Father', 'Mother', 'Guardian']),
    _F('guardianPhone', 'Mobile number', kind: _Kind.phone),
    _F('guardianOccupation', 'Occupation', hint: 'e.g. Teacher'),
    _F('annualIncome', 'Annual family income', kind: _Kind.choice,
        options: ['Below ₹2.5 lakh', '₹2.5–5 lakh', '₹5–8 lakh', '₹8–12 lakh', 'Above ₹12 lakh']),
  ]),
  'address': ProfileSection('Address', 'Your permanent address, used for domicile and correspondence.', [
    _F('address', 'House, street, area', legacy: ['personal.address']),
    _F('city', 'City / town', legacy: ['personal.city']),
    _F('state', 'State', kind: _Kind.choice, options: _states, legacy: ['personal.state']),
    _F('pincode', 'PIN code', kind: _Kind.number, hint: '6 digits'),
  ]),
  'exams': ProfileSection('Entrance exams', 'Fill only the exams you took — rank, percentile or score as on your scorecard.', [
    _F('jeeScore', 'JEE Main percentile', kind: _Kind.number, legacy: ['exams.jeeMain']),
    _F('neetScore', 'NEET score', kind: _Kind.number, legacy: ['exams.neet']),
    _F('cuetScore', 'CUET score', kind: _Kind.number, legacy: ['exams.cuet']),
    _F('bitsatScore', 'BITSAT score', kind: _Kind.number, legacy: ['exams.bitSat']),
    _F('nataScore', 'NATA score', kind: _Kind.number),
    _F('clatScore', 'CLAT score', kind: _Kind.number),
    _F('catPercentile', 'CAT percentile', kind: _Kind.number),
    _F('gateScore', 'GATE score', kind: _Kind.number),
  ]),
  'category': ProfileSection('Category & quota', 'Used for reserved seats. Keep the certificate ready — universities verify it.', [
    _F('category', 'Category', kind: _Kind.choice, options: ['General', 'EWS', 'OBC-NCL', 'SC', 'ST']),
    _F('pwd', 'Person with disability (PwD)', kind: _Kind.choice, options: ['No', 'Yes']),
    _F('domicileState', 'Domicile state', kind: _Kind.choice, options: _states, legacy: ['state']),
  ]),
};

dynamic _read(Map<String, dynamic> m, String path) {
  dynamic cur = m;
  for (final p in path.split('.')) {
    if (cur is Map && cur.containsKey(p)) {
      cur = cur[p];
    } else {
      return null;
    }
  }
  return cur;
}

class ProfileSectionScreen extends ConsumerStatefulWidget {
  final String sectionId;
  const ProfileSectionScreen({super.key, required this.sectionId});
  @override
  ConsumerState<ProfileSectionScreen> createState() => _ProfileSectionScreenState();
}

class _ProfileSectionScreenState extends ConsumerState<ProfileSectionScreen> {
  final _values = <String, String>{};
  final _controllers = <String, TextEditingController>{};
  bool _loaded = false;
  bool _saving = false;
  String? _error;

  ProfileSection get _section => profileSections[widget.sectionId]!;

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _prefill(Map<String, dynamic> profile) {
    if (_loaded) return;
    for (final f in _section.fields) {
      dynamic v = profile[f.key];
      for (final l in f.legacy) {
        if (v != null && v.toString().isNotEmpty) break;
        v = _read(profile, l);
      }
      final s = v == null ? '' : (v is Timestamp ? v.toDate().toIso8601String().substring(0, 10) : v.toString());
      _values[f.key] = s;
      if (f.kind != _Kind.choice && f.kind != _Kind.date) _controllers[f.key] = TextEditingController(text: s);
    }
    _loaded = true;
  }

  String? _validate() {
    for (final f in _section.fields) {
      final v = (_controllers[f.key]?.text ?? _values[f.key] ?? '').trim();
      if (v.isEmpty) continue;
      if (f.kind == _Kind.phone && !RegExp(r'^(\+91)?[6-9]\d{9}$').hasMatch(v.replaceAll(' ', ''))) {
        return '${f.label}: enter a 10-digit Indian mobile number.';
      }
      if (f.key == 'pincode' && !RegExp(r'^\d{6}$').hasMatch(v)) return 'PIN code must be 6 digits.';
      if (f.key.endsWith('Score') || f.key.endsWith('Percentile')) {
        final n = num.tryParse(v);
        if (n == null || n < 0) return '${f.label}: enter a number.';
        if ((f.key == 'tenthScore' || f.key == 'twelfthScore' || f.key == 'jeeScore' || f.key == 'catPercentile') && n > 100) {
          return '${f.label} can’t be more than 100.';
        }
      }
    }
    return null;
  }

  Future<void> _save() async {
    final err = _validate();
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final data = <String, dynamic>{};
    for (final f in _section.fields) {
      data[f.key] = (_controllers[f.key]?.text ?? _values[f.key] ?? '').trim();
    }
    // keep the app's older fields in step so every screen shows the same name/phone
    if (data.containsKey('fullName')) {
      data['displayName'] = data['fullName'];
      data['personal.fullName'] = data['fullName'];
    }
    if (data.containsKey('phone')) data['personal.phone'] = data['phone'];
    data['updatedAt'] = FieldValue.serverTimestamp();
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update(data);
      // keep in-progress applications showing the latest details to universities
      shareDetailsWithActiveApplications();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_section.title} saved.')));
      context.canPop() ? context.pop() : context.go('/profile');
    } catch (_) {
      if (mounted) setState(() => _error = 'Couldn’t save. Check your connection and try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: NeoColors.bgDark,
      appBar: AppBar(
        backgroundColor: NeoColors.bgDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(_section.title, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator(color: NeoColors.green)),
        error: (_, __) => const Center(child: Text('Couldn’t load your profile.', style: TextStyle(color: Colors.white70))),
        data: (p) {
          _prefill(p);
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
            children: [
              Text(_section.intro, style: const TextStyle(color: NeoColors.subDark, fontSize: 13)),
              const SizedBox(height: 18),
              for (final f in _section.fields) Padding(padding: const EdgeInsets.only(bottom: 14), child: _fieldFor(f)),
              if (_error != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(_error!, style: const TextStyle(color: Color(0xFFFF8A8D)))),
              GreenBtn(label: _saving ? 'Saving…' : 'Save', disabled: _saving, onClick: _save),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _dec(_F f) => InputDecoration(
        labelText: f.label,
        hintText: f.hint.isEmpty ? null : f.hint,
        labelStyle: const TextStyle(color: NeoColors.subDark),
        hintStyle: const TextStyle(color: NeoColors.mutedDark),
        filled: true,
        fillColor: NeoColors.surfDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: NeoColors.borderDark)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: NeoColors.borderDark)),
      );

  Widget _fieldFor(_F f) {
    switch (f.kind) {
      case _Kind.choice:
        final current = _values[f.key];
        return DropdownButtonFormField<String>(
          initialValue: f.options.contains(current) ? current : null,
          items: [for (final o in f.options) DropdownMenuItem(value: o, child: Text(o))],
          onChanged: (v) => setState(() => _values[f.key] = v ?? ''),
          dropdownColor: NeoColors.surfDark,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: _dec(f),
        );
      case _Kind.date:
        final v = _values[f.key] ?? '';
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            final init = DateTime.tryParse(v) ?? DateTime(DateTime.now().year - 17);
            final d = await showDatePicker(context: context, initialDate: init, firstDate: DateTime(1980), lastDate: DateTime.now());
            if (d != null) setState(() => _values[f.key] = d.toIso8601String().substring(0, 10));
          },
          child: InputDecorator(
            decoration: _dec(f),
            child: Text(v.isEmpty ? 'Select date' : v, style: TextStyle(color: v.isEmpty ? NeoColors.mutedDark : Colors.white, fontSize: 15)),
          ),
        );
      default:
        return TextField(
          controller: _controllers[f.key],
          keyboardType: f.kind == _Kind.phone
              ? TextInputType.phone
              : f.kind == _Kind.number
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
          inputFormatters: f.kind == _Kind.number ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))] : null,
          textCapitalization: f.kind == _Kind.text ? TextCapitalization.words : TextCapitalization.none,
          style: const TextStyle(color: Colors.white),
          decoration: _dec(f),
        );
    }
  }
}
