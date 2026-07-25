import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/neo_design_system.dart';

class ApplicationModel {
  final String id;
  final String name;
  final String course;
  final int progress;
  final String deadline;
  final Color color;
  final String status;
  final String type; // 'active', 'offers', 'withdrawn'

  const ApplicationModel({
    required this.id,
    required this.name,
    required this.course,
    required this.progress,
    required this.deadline,
    required this.color,
    required this.status,
    required this.type,
  });
}

class ApplicationsState {
  final String currentTab; // 'active', 'offers', 'withdrawn'
  final List<ApplicationModel> apps;

  const ApplicationsState({
    this.currentTab = 'active',
    this.apps = const [],
  });

  ApplicationsState copyWith({
    String? currentTab,
    List<ApplicationModel>? apps,
  }) {
    return ApplicationsState(
      currentTab: currentTab ?? this.currentTab,
      apps: apps ?? this.apps,
    );
  }
}

class ApplicationsNotifier extends StateNotifier<ApplicationsState> {
  ApplicationsNotifier()
      : super(const ApplicationsState(
          apps: [
            ApplicationModel(id: '1', name: 'BITS Pilani', course: 'B.Tech CSE', progress: 91, deadline: 'Aug 30', color: NeoColors.green, status: 'IN PROGRESS', type: 'active'),
            ApplicationModel(id: '2', name: 'IIT Bombay', course: 'B.Tech EE', progress: 67, deadline: 'Sep 15', color: NeoColors.blue, status: 'IN PROGRESS', type: 'active'),
            ApplicationModel(id: '3', name: 'Delhi University', course: 'B.Sc Honours', progress: 45, deadline: 'Oct 1', color: NeoColors.purple, status: 'DRAFT', type: 'active'),
            ApplicationModel(id: '4', name: 'VIT Vellore', course: 'B.Tech CSE', progress: 100, deadline: 'Accept by Aug 10', color: NeoColors.yellow, status: 'OFFER', type: 'offers'),
            ApplicationModel(id: '5', name: 'Manipal Uni', course: 'B.Tech IT', progress: 100, deadline: 'Accept by Aug 20', color: Color(0xFFFF3B7A), status: 'OFFER', type: 'offers'),
            ApplicationModel(id: '6', name: 'Amity University', course: 'BCA', progress: 100, deadline: 'Withdrawn Jul 1', color: NeoColors.subDark, status: 'WITHDRAWN', type: 'withdrawn'),
          ],
        ));

  void setTab(String tab) => state = state.copyWith(currentTab: tab);
}

final applicationsListProvider = StateNotifierProvider<ApplicationsNotifier, ApplicationsState>((ref) {
  return ApplicationsNotifier();
});

final currentAppsProvider = Provider<List<ApplicationModel>>((ref) {
  final state = ref.watch(applicationsListProvider);
  return state.apps.where((a) => a.type == state.currentTab).toList();
});
