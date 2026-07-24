import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/molecules/squircle_card.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../models/interview_model.dart';

class InterviewReportScreen extends StatelessWidget {
  final InterviewSession? session;

  const InterviewReportScreen({super.key, this.session});

  @override
  Widget build(BuildContext context) {
    final report = session?.report ?? const AIInterviewReport();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.p24, 0, AppSpacing.p24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverallScore(report, isDark),
                    _buildMetrics(context, report, isDark),
                    if (session?.userTranscript != null &&
                        session!.userTranscript.isNotEmpty)
                      _buildTranscriptTile(
                          context, session!.userTranscript, isDark),
                    _buildRecommendations(report, isDark),
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
              'Performance Report',
              style: AppTypography.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallScore(AIInterviewReport report, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppSpacing.p8, bottom: AppSpacing.p32),
      padding: const EdgeInsets.all(AppSpacing.p32),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 15)),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Iconsax.magic_star, color: Colors.white, size: 48)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(duration: 2.seconds),
            const SizedBox(height: AppSpacing.p16),
            Text('${report.overallScore}%',
                style: AppTypography.display
                    .copyWith(color: Colors.white, fontSize: 64)),
            Text('Overall Interview Score',
                style:
                    AppTypography.titleMedium.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    ).animate().fade().scale();
  }

  Widget _buildMetrics(
      BuildContext context, AIInterviewReport report, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Key Performance Indicators', style: AppTypography.titleLarge),
        const SizedBox(height: AppSpacing.p16),
        SquircleCard(
          padding: const EdgeInsets.all(AppSpacing.p24),
          child: Column(
            children: [
              _buildScoreRow('Confidence', report.confidence, isDark),
              _buildScoreRow('Communication', report.communication, isDark),
              _buildScoreRow(
                  'Technical Depth', report.technicalKnowledge, isDark),
              _buildScoreRow('Clarity', report.clarity, isDark, isLast: true),
            ],
          ),
        ),
      ],
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildScoreRow(String label, int score, bool isDark,
      {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.p16),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: AppTypography.labelLarge.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary))),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.p12, vertical: AppSpacing.p4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('$score%',
                style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptTile(
      BuildContext context, String transcript, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.p32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recorded Transcript', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p16),
          SquircleCard(
            padding: const EdgeInsets.all(AppSpacing.p24),
            child: Text(transcript,
                style: AppTypography.bodyMedium.copyWith(
                    height: 1.6,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary)),
          ),
        ],
      ),
    ).animate().fade(delay: 150.ms).slideY(begin: 0.1);
  }

  Widget _buildRecommendations(AIInterviewReport report, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.p32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Recommendations', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p16),
          ...report.recommendations.map(
            (rec) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.p16),
              child: SquircleCard(
                padding: const EdgeInsets.all(AppSpacing.p20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.p8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Iconsax.flash,
                          size: 20, color: Colors.amber),
                    ),
                    const SizedBox(width: AppSpacing.p16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rec.text,
                              style: AppTypography.bodyMedium
                                  .copyWith(height: 1.5)),
                          const SizedBox(height: AppSpacing.p8),
                          Text(
                              'Impact: ${rec.estimatedImpact} • Priority: ${rec.priority}',
                              style: AppTypography.caption
                                  .copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }
}
