import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/neo_design_system.dart';
import '../data/admission_service.dart';
import 'applications_provider.dart';

/// One row on the Applications screen, built from a real `applications/{id}` doc.
class ApplicationModel {
  final String id;
  final String name;
  final String course;
  final int progress;
  final String deadline; // short status line shown under the progress bar
  final Color color;
  final String status; // badge text
  final String type; // 'active', 'offers', 'withdrawn' (past)
  final bool needsAction;

  const ApplicationModel({
    required this.id,
    required this.name,
    required this.course,
    required this.progress,
    required this.deadline,
    required this.color,
    required this.status,
    required this.type,
    this.needsAction = false,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> m) {
    final s = normalizeStatus(m['status'] as String?);
    final closed = closedStatuses.contains(s);
    final offerish = ['selected', 'allotted', 'seat_accepted', 'fee_paid', 'payment_verified', 'enrolled'].contains(s);
    final type = closed ? 'withdrawn' : (offerish ? 'offers' : 'active');
    final color = closed
        ? NeoColors.subDark
        : s == 'enrolled'
            ? NeoColors.green
            : offerish
                ? NeoColors.yellow
                : s == 'under_review' || s == 'docs_verified'
                    ? NeoColors.blue
                    : NeoColors.purpleSoft;
    final needsAction = offerStatuses.contains(s) || s == 'seat_accepted';
    final updated = toDate(m['updatedAt'] ?? m['createdAt']);
    String line;
    if (offerStatuses.contains(s)) {
      line = 'Respond to the offer';
    } else if (s == 'seat_accepted') {
      line = 'Pay the admission fee';
    } else if (updated != null) {
      final d = DateTime.now().difference(updated);
      line = 'Updated ${d.inDays > 0 ? '${d.inDays}d' : d.inHours > 0 ? '${d.inHours}h' : '${d.inMinutes.clamp(1, 59)}m'} ago';
    } else {
      line = 'Submitted';
    }
    return ApplicationModel(
      id: m['id'] as String,
      name: (m['universityName'] as String?)?.isNotEmpty == true ? m['universityName'] : 'University',
      course: (m['programName'] ?? m['program'] ?? m['courseName'] ?? 'Program').toString(),
      progress: closed ? 100 : ((stageOf(s) / 7) * 100).round(),
      deadline: line,
      color: color,
      status: statusLabel(s).toUpperCase(),
      type: type,
      needsAction: needsAction,
    );
  }
}

class ApplicationsState {
  final String currentTab; // 'active', 'offers', 'withdrawn'
  final List<ApplicationModel> apps;
  final bool loading;

  const ApplicationsState({this.currentTab = 'active', this.apps = const [], this.loading = false});
}

class _TabNotifier extends Notifier<String> {
  @override
  String build() => 'active';
  void set(String tab) => state = tab;
}

final _applicationsTabProvider = NotifierProvider<_TabNotifier, String>(_TabNotifier.new);

class ApplicationsNotifier extends Notifier<ApplicationsState> {
  @override
  ApplicationsState build() {
    final tab = ref.watch(_applicationsTabProvider);
    final async = ref.watch(myApplicationsProvider);
    final apps = (async.value ?? const <Map<String, dynamic>>[]).map(ApplicationModel.fromMap).toList();
    return ApplicationsState(currentTab: tab, apps: apps, loading: async.isLoading && !async.hasValue);
  }

  void setTab(String tab) => ref.read(_applicationsTabProvider.notifier).set(tab);
}

final applicationsListProvider = NotifierProvider<ApplicationsNotifier, ApplicationsState>(ApplicationsNotifier.new);

final currentAppsProvider = Provider<List<ApplicationModel>>((ref) {
  final state = ref.watch(applicationsListProvider);
  return state.apps.where((a) => a.type == state.currentTab).toList();
});
