import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ── Raw university stream from Firestore ───────────────────────────────────

final allUniversitiesProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('universities')
      .where('approvalStatus', isEqualTo: 'approved')
      .snapshots()
      .map((s) =>
          s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
});

// ── Search & filter state (Riverpod 3.x uses Notifier) ───────────────────

class _StringNotifier extends Notifier<String> {
  final String _initial;
  _StringNotifier(this._initial);
  @override
  String build() => _initial;
  void set(String v) => state = v;
}

class _ListNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];
  void toggle(String id) {
    if (state.contains(id)) {
      state = state.where((i) => i != id).toList();
    } else {
      state = [...state, id];
    }
  }
}

final searchQueryProvider =
    NotifierProvider<_StringNotifier, String>(() => _StringNotifier(''));

final filterCategoryProvider =
    NotifierProvider<_StringNotifier, String>(() => _StringNotifier('All'));

final savedUniversityIdsProvider =
    NotifierProvider<_ListNotifier, List<String>>(() => _ListNotifier());

// ── Filtered + sorted list ────────────────────────────────────────────────

final filteredUniversitiesProvider =
    Provider<List<Map<String, dynamic>>>((ref) {
  final all = ref.watch(allUniversitiesProvider).value ?? [];
  final q = ref.watch(searchQueryProvider).toLowerCase();
  final f = ref.watch(filterCategoryProvider);

  return all.where((u) {
    final name = (u['name'] ?? '').toString().toLowerCase();
    final type = (u['type'] ?? '').toString();
    final matchesSearch = q.isEmpty || name.contains(q);
    final matchesFilter = f == 'All' || type == f;
    return matchesSearch && matchesFilter;
  }).toList()
    ..sort((a, b) =>
        ((a['rankings']?['nirfOverall'] as num?) ?? 999)
            .compareTo((b['rankings']?['nirfOverall'] as num?) ?? 999));
});
