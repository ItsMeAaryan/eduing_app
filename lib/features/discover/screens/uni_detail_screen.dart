// University detail — loaded from universities/{id} and its programs.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../widgets/apply_program_sheet.dart';
import '../../applications/data/admission_service.dart' show toDate;
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;

final _universityProvider = StreamProvider.family<Map<String, dynamic>?, String>((ref, id) =>
    FirebaseFirestore.instance.collection('universities').doc(id).snapshots().map((s) => s.exists ? {'id': s.id, ...s.data()!} : null));

final _programsProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, id) => FirebaseFirestore.instance
    .collection('programs')
    .where('universityId', isEqualTo: id)
    .snapshots()
    .map((s) => s.docs
        .map((d) => {'id': d.id, ...d.data()})
        .where((p) => p['isActive'] != false && p['status'] != 'inactive')
        .toList()
      ..sort((a, b) => (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString()))));

String _inr(dynamic v) {
  final n = v is num ? v : num.tryParse('$v');
  if (n == null) return '$v';
  if (n >= 100000) return '₹${(n / 100000).toStringAsFixed(n % 100000 == 0 ? 0 : 1)} lakh';
  return NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(n);
}

class UniDetailScreen extends ConsumerStatefulWidget {
  final String universityId;
  const UniDetailScreen({super.key, required this.universityId});

  @override
  ConsumerState<UniDetailScreen> createState() => _UniDetailScreenState();
}

class _UniDetailScreenState extends ConsumerState<UniDetailScreen> {
  String tab = 'overview';

  @override
  Widget build(BuildContext context) {
    final uniAsync = ref.watch(_universityProvider(widget.universityId));
    final programs = ref.watch(_programsProvider(widget.universityId)).value ?? const [];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: uniAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: NeoColors.green)),
          error: (_, __) => _message('Couldn’t load this university. Check your connection.'),
          data: (u) => u == null ? _message('This university isn’t on EDUING any more.') : _content(u, programs),
        ),
      ),
    );
  }

  Widget _message(String text) => Column(children: [
        _header(''),
        Expanded(child: Center(child: Padding(padding: const EdgeInsets.all(32), child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70))))),
      ]);

  Widget _header(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(children: [
          Semantics(
            button: true,
            label: 'Back',
            child: GestureDetector(
              onTap: () => context.canPop() ? context.pop() : context.go('/discover'),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white)),
          ),
        ]),
      );

  Widget _content(Map<String, dynamic> u, List<Map<String, dynamic>> programs) {
    final name = (u['name'] ?? 'University').toString();
    final place = [u['city'], u['state']].where((e) => e != null && '$e'.isNotEmpty).join(', ');
    final placement = (u['placementData'] as Map?) ?? const {};
    final tabs = ['overview', 'programs', if (placement.values.any((v) => v != null && '$v'.isNotEmpty && v is! List || (v is List && v.isNotEmpty))) 'placements'];
    if (!tabs.contains(tab)) tab = 'overview';

    return Column(children: [
      _header(u['shortName']?.toString() ?? name),
      Expanded(
        child: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: double.infinity,
                height: 132,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF4B2FC9), Color(0xFF161326)]),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: (u['logoUrl'] ?? u['logo']) != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network((u['logoUrl'] ?? u['logo']).toString(), height: 72, width: 72, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Text('🏛', style: TextStyle(fontSize: 56))),
                      )
                    : const Text('🏛', style: TextStyle(fontSize: 56)),
              ),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5, height: 1.1)),
              if (place.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('📍 $place', style: const TextStyle(fontSize: 13, color: NeoColors.subDark)),
              ],
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                if (u['type'] != null) neo.Badge(label: '${u['type']}'.toUpperCase(), color: NeoColors.purpleSoft),
                if (u['accreditation'] != null && '${u['accreditation']}'.isNotEmpty) neo.Badge(label: '${u['accreditation']}'.toUpperCase(), color: NeoColors.green),
                if (u['rating'] != null) neo.Badge(label: '★ ${u['rating']}', color: NeoColors.yellow),
                if (u['isVerified'] == true) const neo.Badge(label: 'VERIFIED', color: NeoColors.blue),
              ]),
              const SizedBox(height: 16),
              GreenBtn(
                label: programs.isEmpty ? 'No programs open right now' : 'Apply now',
                disabled: programs.isEmpty,
                onClick: () => showApplyProgramSheet(context, widget.universityId),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(children: [
              for (final t in tabs)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => tab = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: tab == t ? Colors.white : NeoColors.surfDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: tab == t ? Colors.white : NeoColors.borderDark),
                      ),
                      child: Text(t == 'programs' ? 'Programs (${programs.length})' : '${t[0].toUpperCase()}${t.substring(1)}',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: tab == t ? Colors.black : Colors.white70)),
                    ),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: tab == 'programs' ? _programsTab(programs) : tab == 'placements' ? _placementsTab(placement) : _overviewTab(u),
          ),
        ]),
      ),
    ]);
  }

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: NeoColors.surfDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: NeoColors.borderDark)),
        child: child,
      );

  Widget _fact(String label, String value) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: NeoColors.surfDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: NeoColors.borderDark)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 11, color: NeoColors.subDark, fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w800)),
        ]),
      );

  Widget _overviewTab(Map<String, dynamic> u) {
    final facts = <List<String>>[
      if (u['established'] != null) ['Established', '${u['established']}'],
      if (u['totalStudents'] != null && u['totalStudents'] != 0) ['Students', NumberFormat.decimalPattern('en_IN').format(u['totalStudents'])],
      if (u['campusSize'] != null && '${u['campusSize']}'.isNotEmpty) ['Campus', '${u['campusSize']}'],
      if (u['alumniCount'] != null && u['alumniCount'] != 0) ['Alumni', NumberFormat.compact(locale: 'en_IN').format(u['alumniCount'])],
    ];
    final facilities = (u['facilities'] as List?)?.map((e) => '$e').where((e) => e.isNotEmpty).toList() ?? const [];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if ((u['description'] ?? '').toString().isNotEmpty)
        _card(child: Text(u['description'].toString(), style: const TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.5))),
      if (facts.isNotEmpty)
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.4,
          children: [for (final f in facts) _fact(f[0], f[1])],
        ),
      if (facilities.isNotEmpty) ...[
        const SizedBox(height: 14),
        const Text('Facilities', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final f in facilities)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: NeoColors.surfDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: NeoColors.borderDark)),
              child: Text(f, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
            ),
        ]),
      ],
      if ((u['website'] ?? '').toString().isNotEmpty) ...[
        const SizedBox(height: 14),
        Text('Website: ${u['website']}', style: const TextStyle(color: NeoColors.subDark, fontSize: 12.5)),
      ],
    ]);
  }

  Widget _programsTab(List<Map<String, dynamic>> programs) {
    if (programs.isEmpty) {
      return _card(child: const Text('This university hasn’t opened admissions on EDUING yet.', style: TextStyle(color: Colors.white70)));
    }
    final now = DateTime.now();
    return Column(children: [
      for (final p in programs)
        Builder(builder: (context) {
          final deadline = toDate(p['applicationDeadline']);
          final closed = deadline != null && deadline.isBefore(now);
          final seats = p['availableSeats'] ?? p['totalSeats'];
          return _card(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Text('${p['name'] ?? 'Program'}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15))),
                if (p['level'] != null) neo.Badge(label: '${p['level']}'.toUpperCase(), color: NeoColors.purpleSoft),
              ]),
              const SizedBox(height: 8),
              Wrap(spacing: 14, runSpacing: 6, children: [
                if (p['duration'] != null) _meta('⏱', '${p['duration']}'),
                if (p['annualFee'] != null) _meta('💰', '${_inr(p['annualFee'])} / year'),
                if (seats != null) _meta('🎟', '$seats seats'),
                if (p['entranceExam'] != null && '${p['entranceExam']}'.isNotEmpty) _meta('📝', '${p['entranceExam']}'),
                if (deadline != null) _meta('📅', closed ? 'Closed ${DateFormat('d MMM').format(deadline)}' : 'Apply by ${DateFormat('d MMM yyyy').format(deadline)}'),
              ]),
              if ((p['eligibility'] ?? '').toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Eligibility: ${p['eligibility']}', style: const TextStyle(color: NeoColors.subDark, fontSize: 12.5)),
              ],
            ]),
          );
        }),
      GreenBtn(label: 'Apply to a program', onClick: () => showApplyProgramSheet(context, widget.universityId)),
    ]);
  }

  Widget _meta(String icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
      ]);

  Widget _placementsTab(Map placement) {
    final recruiters = (placement['topRecruiters'] as List?)?.map((e) => '$e').where((e) => e.isNotEmpty).toList() ?? const [];
    final facts = <List<String>>[
      if ('${placement['placementRate'] ?? ''}'.isNotEmpty) ['Placement rate', '${placement['placementRate']}'.contains('%') ? '${placement['placementRate']}' : '${placement['placementRate']}%'],
      if ('${placement['averageSalary'] ?? placement['averagePackage'] ?? ''}'.isNotEmpty) ['Average package', '${placement['averageSalary'] ?? placement['averagePackage']}'],
      if ('${placement['highestSalary'] ?? placement['highestPackage'] ?? ''}'.isNotEmpty) ['Highest package', '${placement['highestSalary'] ?? placement['highestPackage']}'],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text('As reported by the university.', style: TextStyle(color: NeoColors.subDark, fontSize: 12.5)),
      const SizedBox(height: 10),
      for (final f in facts) Padding(padding: const EdgeInsets.only(bottom: 10), child: _fact(f[0], f[1])),
      if (recruiters.isNotEmpty) ...[
        const SizedBox(height: 4),
        const Text('Top recruiters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final r in recruiters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: NeoColors.surfDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: NeoColors.borderDark)),
              child: Text(r, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
            ),
        ]),
      ],
    ]);
  }
}
