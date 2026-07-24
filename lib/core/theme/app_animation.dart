import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'app_duration.dart';

class AppAnimation {
  static Curve standard = Curves.easeInOutCubicEmphasized;
  static Curve enter = Curves.easeOutCubic;
  static Curve exit = Curves.easeInCubic;

  static List<Effect> fadeAndSlideIn = [
    FadeEffect(duration: AppDuration.normal, curve: enter),
    SlideEffect(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
        duration: AppDuration.normal,
        curve: enter),
  ];

  static List<Effect> scaleIn = [
    FadeEffect(duration: AppDuration.normal, curve: enter),
    ScaleEffect(
        begin: const Offset(0.95, 0.95),
        end: const Offset(1, 1),
        duration: AppDuration.normal,
        curve: enter),
  ];
}
