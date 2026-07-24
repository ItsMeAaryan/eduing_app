import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/molecules/squircle_card.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../../../shared/components/atoms/app_button.dart';
import '../providers/interview_provider.dart';
import '../models/interview_model.dart';

class InterviewDashboardScreen extends ConsumerWidget {
  const InterviewDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(interviewNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  children: [
                    _buildHeroCard(context, isDark),
                    _buildSessionHistory(context, sessions, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Row(
        children: [
          AppIconButton(
            icon: Iconsax.arrow_left_2,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: AppSpacing.p16),
          Expanded(
            child: Text(
              'Interview Coach',
              style: AppTypography.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppIconButton(
            icon: Iconsax.setting_2,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p24, vertical: AppSpacing.p8),
      padding: const EdgeInsets.all(AppSpacing.p32),
      decoration: BoxDecoration(
        color: const Color(
            0xFF1E1E1E), // Explicit dark mode for the hero to simulate camera/audio feel
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 15)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.p24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.p24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: const Icon(Iconsax.camera, color: Colors.white, size: 48)
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 2.seconds),
            ),
          ),
          const SizedBox(height: AppSpacing.p32),
          Text('AI Video & Audio Practice',
              style: AppTypography.titleLarge.copyWith(color: Colors.white)),
          const SizedBox(height: AppSpacing.p12),
          Text(
            'Practice admission and visa questions in a simulated video call environment. Get instant AI grading on clarity, structure, and delivery.',
            style: AppTypography.bodyMedium
                .copyWith(color: Colors.white70, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.p32),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Start Mock Interview',
              icon: Iconsax.microphone_2,
              onPressed: () => context.push('/interview/mock'),
            ),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.05);
  }

  Widget _buildSessionHistory(
      BuildContext context, List<InterviewSession> sessions, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.p24, AppSpacing.p24, AppSpacing.p24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Sessions', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p16),
          if (sessions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.p32),
                child: Text('No sessions recorded yet.',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textSecondary)),
              ),
            )
          else
            ...sessions.map(
              (sess) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.p12),
                child: SquircleCard(
                  onTap: () => context.push('/interview/report', extra: sess),
                  padding: const EdgeInsets.all(AppSpacing.p16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('${sess.score}',
                              style: AppTypography.titleMedium
                                  .copyWith(color: AppColors.primary)),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.p16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sess.questionTitle,
                                style: AppTypography.labelLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: AppSpacing.p4),
                            Text('Practiced on ${sess.date}',
                                style: AppTypography.caption
                                    .copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Iconsax.arrow_right_3,
                          color: AppColors.textSecondary, size: 20),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }
}
