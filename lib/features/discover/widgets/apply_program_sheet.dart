import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../applications/providers/applications_provider.dart';

/// Opens the program picker for [universityId] and submits a real
/// application to the shared `applications` collection (the same one the
/// university portal reviews).
Future<void> showApplyProgramSheet(BuildContext context, String universityId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ApplyProgramSheet(universityId: universityId),
  );
}

class ApplyProgramSheet extends StatefulWidget {
  final String universityId;
  const ApplyProgramSheet({super.key, required this.universityId});

  @override
  State<ApplyProgramSheet> createState() => _ApplyProgramSheetState();
}

class _ApplyProgramSheetState extends State<ApplyProgramSheet> {
  late final Future<_ApplyData> _data = _load();
  String? _selectedProgramId;
  bool _submitting = false;
  String? _error;

  Future<_ApplyData> _load() async {
    final db = FirebaseFirestore.instance;
    final uniSnap =
        await db.collection('universities').doc(widget.universityId).get();
    final programsSnap = await db
        .collection('programs')
        .where('universityId', isEqualTo: widget.universityId)
        .get();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    Map<String, dynamic> student = {};
    Set<String> appliedProgramIds = {};
    if (uid != null) {
      student = (await db.collection('users').doc(uid).get()).data() ?? {};
      student['email'] ??= FirebaseAuth.instance.currentUser?.email;
      final existing = await db
          .collection('applications')
          .where('studentId', isEqualTo: uid)
          .where('universityId', isEqualTo: widget.universityId)
          .get();
      appliedProgramIds = existing.docs
          .map((d) => (d.data()['programId'] ?? '') as String)
          .toSet();
    }
    return _ApplyData(
      university: {'id': uniSnap.id, ...?uniSnap.data()},
      programs: programsSnap.docs
          .map((d) => {'id': d.id, ...d.data()})
          .where((p) => (p['status'] ?? 'active') == 'active')
          .toList(),
      student: student,
      appliedProgramIds: appliedProgramIds,
    );
  }

  Future<void> _submit(_ApplyData data) async {
    final program =
        data.programs.firstWhere((p) => p['id'] == _selectedProgramId);
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        throw Exception('Please log in to apply.');
      }
      await createApplicationInFirestore(
        studentData: data.student,
        university: data.university,
        program: program,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Applied to ${program['name']} at ${data.university['name']}')),
      );
      context.go('/applications');
    } catch (e) {
      setState(() {
        _submitting = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scroll) => Container(
        decoration: const BoxDecoration(
          color: NeoColors.surfDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: FutureBuilder<_ApplyData>(
          future: _data,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(
                child: Text('Could not load programs.\n${snap.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70)),
              );
            }
            final data = snap.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Apply to ${data.university['name'] ?? 'this university'}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                const Text('Choose the program you want to apply for.',
                    style: TextStyle(color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 16),
                Expanded(
                  child: data.programs.isEmpty
                      ? const Center(
                          child: Text(
                              'This university has not opened any programs yet.',
                              style: TextStyle(color: Colors.white60)),
                        )
                      : ListView.separated(
                          controller: scroll,
                          itemCount: data.programs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final p = data.programs[i];
                            final id = p['id'] as String;
                            final applied = data.appliedProgramIds.contains(id);
                            final selected = id == _selectedProgramId;
                            final meta = [
                              p['degree'],
                              p['level'],
                              p['duration'],
                              p['mode']
                            ]
                                .where((v) => v != null && '$v'.isNotEmpty)
                                .join(' · ');
                            return GestureDetector(
                              onTap: applied
                                  ? null
                                  : () =>
                                      setState(() => _selectedProgramId = id),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? NeoColors.purple.withValues(alpha: 0.18)
                                      : Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                      color: selected
                                          ? NeoColors.purple
                                          : Colors.white12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('${p['name'] ?? 'Program'}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15)),
                                          if (meta.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(meta,
                                                style: const TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 12)),
                                          ],
                                        ],
                                      ),
                                    ),
                                    if (applied)
                                      const Text('Applied',
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontWeight: FontWeight.w700))
                                    else
                                      Icon(
                                          selected
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off,
                                          color: selected
                                              ? NeoColors.purple
                                              : Colors.white38),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!,
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 13)),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _selectedProgramId == null || _submitting
                        ? null
                        : () => _submit(data),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NeoColors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26)),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: Colors.white))
                        : const Text('Submit application',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ApplyData {
  final Map<String, dynamic> university;
  final List<Map<String, dynamic>> programs;
  final Map<String, dynamic> student;
  final Set<String> appliedProgramIds;
  _ApplyData(
      {required this.university,
      required this.programs,
      required this.student,
      required this.appliedProgramIds});
}
