import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/neo_design_system.dart';

class PlannerTask {
  final String id;
  final String title;
  final String tag;
  final String date;
  final Color color;
  final bool done;

  const PlannerTask({
    required this.id,
    required this.title,
    required this.tag,
    required this.date,
    required this.color,
    required this.done,
  });

  PlannerTask copyWith({bool? done}) {
    return PlannerTask(
      id: id,
      title: title,
      tag: tag,
      date: date,
      color: color,
      done: done ?? this.done,
    );
  }
}

class PlannerState {
  final String view; // 'timeline' or 'calendar'
  final List<PlannerTask> tasks;

  const PlannerState({
    this.view = 'timeline',
    this.tasks = const [],
  });

  PlannerState copyWith({String? view, List<PlannerTask>? tasks}) {
    return PlannerState(
      view: view ?? this.view,
      tasks: tasks ?? this.tasks,
    );
  }
}

class PlannerNotifier extends Notifier<PlannerState> {
  @override
  PlannerState build() {
    return const PlannerState(
      tasks: [
        PlannerTask(id: '1', title: 'Upload Passport', tag: 'REQUIRED', date: 'Tomorrow', color: NeoColors.red, done: false),
        PlannerTask(id: '2', title: 'Finish BITS SOP', tag: 'HIGH', date: 'Jul 24', color: Color(0xFFFF6B35), done: false),
        PlannerTask(id: '3', title: 'Mock Interview Practice', tag: 'MEDIUM', date: 'Jul 24', color: NeoColors.blue, done: false),
        PlannerTask(id: '4', title: 'Stanford App Deadline', tag: 'DEADLINE', date: 'Jul 27', color: NeoColors.purple, done: true),
        PlannerTask(id: '5', title: 'STEM Grant Deadline', tag: 'DEADLINE', date: 'Jul 29', color: Color(0xFFFF3B7A), done: false),
        PlannerTask(id: '6', title: 'IIT Bombay Application', tag: 'IN PROGRESS', date: 'Aug 15', color: NeoColors.green, done: false),
      ],
    );
  }

  void setView(String view) {
    state = state.copyWith(view: view);
  }

  void toggleTask(String id) {
    state = state.copyWith(
      tasks: state.tasks.map((t) => t.id == id ? t.copyWith(done: !t.done) : t).toList(),
    );
  }
}

final plannerProvider = NotifierProvider<PlannerNotifier, PlannerState>(() {
  return PlannerNotifier();
});
