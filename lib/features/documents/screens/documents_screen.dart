// Documents — EDUING doesn't store document files. Students enter their marks
// and details in the profile (shared with every application); documents will
// be verified through DigiLocker. Same content as the website's Documents page.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../profile/providers/profile_provider.dart';

class _Item {
  final String name;
  final String why;
  final bool inDigiLocker;
  final String? field; // profile detail that covers it today
  final String? route;
  final bool Function(Map<String, dynamic>)? ready;
  const _Item(this.name, this.why, {this.inDigiLocker = false, this.field, this.route, this.ready});
}

bool _has(Map<String, dynamic> p, String k) => (p[k] ?? '').toString().trim().isNotEmpty;
dynamic _nested(Map<String, dynamic> p, String a, String b) => (p[a] is Map) ? (p[a] as Map)[b] : null;

final _items = <_Item>[
  _Item('Class 10 marksheet', 'Date of birth and Class 10 marks', inDigiLocker: true, field: '10th percentage', route: '/profile/academic',
      ready: (p) => _has(p, 'tenthScore') || _nested(p, 'academic', 'marks10') != null),
  _Item('Class 12 marksheet', 'Eligibility for UG programs', inDigiLocker: true, field: '12th percentage', route: '/profile/academic',
      ready: (p) => _has(p, 'twelfthScore') || _nested(p, 'academic', 'marks12') != null),
  _Item('Entrance exam scorecard', 'JEE, NEET, CUET, NATA, CLAT … as the program needs', field: 'exam scores', route: '/profile/exams',
      ready: (p) => ['jeeScore', 'neetScore', 'cuetScore', 'bitsatScore', 'nataScore', 'clatScore', 'catPercentile', 'gateScore'].any((k) => _has(p, k))),
  _Item('Category certificate', 'Only for EWS / OBC-NCL / SC / ST / PwD seats', inDigiLocker: true, field: 'category', route: '/profile/category',
      ready: (p) => _has(p, 'category')),
  _Item('Domicile certificate', 'Only for state-quota seats', inDigiLocker: true, field: 'domicile state', route: '/profile/category',
      ready: (p) => _has(p, 'domicileState')),
  const _Item('Aadhaar', 'Identity check at admission', inDigiLocker: true),
  const _Item('Passport-size photographs', 'Carry 4–6 recent copies to the campus'),
];

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(profileProvider).value ?? const <String, dynamic>{};
    final details = _items.where((i) => i.ready != null).toList();
    final done = details.where((i) => i.ready!(p)).length;

    return Scaffold(
      backgroundColor: NeoColors.bgDark,
      appBar: AppBar(
        backgroundColor: NeoColors.bgDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Documents', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 32), children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFF3A2A8F), Color(0xFF161326)]),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFFF5B829), borderRadius: BorderRadius.circular(14)),
              child: const Text('Coming soon', style: TextStyle(color: Color(0xFF161326), fontWeight: FontWeight.w900, fontSize: 11.5)),
            ),
            const SizedBox(height: 12),
            const Text('Verify your documents with DigiLocker',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.15, letterSpacing: -0.4)),
            const SizedBox(height: 8),
            Text(
              'You won’t need to scan or upload anything. Connect DigiLocker once, and your marksheets, Aadhaar and certificates come straight from the board or government — already verified for every university you apply to.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, height: 1.45),
            ),
            const SizedBox(height: 6),
            Text('Until then, enter your marks in your profile. Universities see them on your application.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
            const SizedBox(height: 14),
            PillBtn(label: 'Fill in my details', bg: Colors.white, color: const Color(0xFF161326), onClick: () => context.push('/profile/academic')),
          ]),
        ),
        const SizedBox(height: 18),
        Row(children: [
          const Expanded(child: Text('What universities see now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900))),
          Text('$done of ${details.length} filled', style: const TextStyle(color: NeoColors.green, fontSize: 12.5, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 10),
        for (final i in details)
          _Row(
            title: i.field![0].toUpperCase() + i.field!.substring(1),
            sub: i.ready!(p) ? 'Added' : 'Not added yet',
            ok: i.ready!(p),
            onTap: () => context.push(i.route!),
          ),
        const SizedBox(height: 18),
        const Text('Keep these ready for admission day', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        const Text('Universities check originals when you report to the campus.', style: TextStyle(color: NeoColors.subDark, fontSize: 12.5)),
        const SizedBox(height: 10),
        for (final i in _items)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: NeoColors.surfDark, borderRadius: BorderRadius.circular(18), border: Border.all(color: NeoColors.borderDark)),
            child: Row(children: [
              const Icon(Icons.verified_user_outlined, color: Colors.white54, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(i.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.5)),
                  Text(i.why, style: const TextStyle(color: NeoColors.subDark, fontSize: 12)),
                ]),
              ),
              if (i.inDigiLocker)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF745CF5))),
                  child: const Text('In DigiLocker', style: TextStyle(color: Color(0xFFB2A2FF), fontSize: 10.5, fontWeight: FontWeight.w700)),
                ),
            ]),
          ),
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  final String title;
  final String sub;
  final bool ok;
  final VoidCallback onTap;
  const _Row({required this.title, required this.sub, required this.ok, required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: NeoColors.surfDark, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Icon(ok ? Icons.check_circle_rounded : Icons.radio_button_unchecked, color: ok ? NeoColors.green : Colors.white38, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  Text(sub, style: const TextStyle(color: NeoColors.subDark, fontSize: 12)),
                ]),
              ),
              if (!ok) const Text('Add', style: TextStyle(color: Color(0xFFB2A2FF), fontWeight: FontWeight.w800)),
            ]),
          ),
        ),
      );
}
