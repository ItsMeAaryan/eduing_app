import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/interview_provider.dart';
import '../models/interview_model.dart';

class InterviewReportScreen extends ConsumerWidget {
  const InterviewReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.read(interviewProvider.notifier).getLatestReport();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Interview Report', style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallScore(report),
            _buildDetailedScores(report),
            _buildRecommendations(report),
            _buildStrengths(report),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallScore(AIInterviewReport report) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Iconsax.magic_star, color: Colors.white, size: 48)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(duration: 2.seconds),
            const SizedBox(height: 16),
            Text('${report.overallScore}', style: AppTypography.headline.copyWith(fontSize: 64, color: Colors.white)),
            Text('Overall Performance', style: AppTypography.title.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    ).animate().fade().scale();
  }

  Widget _buildDetailedScores(AIInterviewReport report) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analytics Breakdown', style: AppTypography.title),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildScoreRow('Confidence', report.confidence),
                _buildScoreRow('Communication', report.communication),
                _buildScoreRow('Technical', report.technicalKnowledge),
                _buildScoreRow('Problem Solving', report.problemSolving),
                _buildScoreRow('Clarity', report.clarity),
                _buildScoreRow('Pacing', report.speakingPace),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildScoreRow(String label, int score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: AppTypography.label)),
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: score / 100.0,
                backgroundColor: Colors.grey.shade200,
                color: _getScoreColor(score),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text('$score', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, color: _getScoreColor(score))),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return AppColors.success;
    if (score >= 70) return AppColors.primary;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildRecommendations(AIInterviewReport report) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Areas for Improvement', style: AppTypography.title),
          const SizedBox(height: 16),
          ...report.recommendations.map((rec) => _buildRecommendationCard(rec)),
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildRecommendationCard(AIInterviewRecommendation rec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            rec.isCompleted ? Iconsax.tick_circle : Iconsax.info_circle,
            color: rec.isCompleted ? AppColors.success : _getPriorityColor(rec.priority),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rec.text, style: AppTypography.body.copyWith(decoration: rec.isCompleted ? TextDecoration.lineThrough : null)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: _getPriorityColor(rec.priority).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('${rec.priority} Priority', style: AppTypography.caption.copyWith(color: _getPriorityColor(rec.priority), fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(rec.estimatedImpact, style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High': return AppColors.error;
      case 'Medium': return AppColors.warning;
      case 'Low': return AppColors.success;
      default: return AppColors.textSecondary;
    }
  }

  Widget _buildStrengths(AIInterviewReport report) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Key Strengths', style: AppTypography.title),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.success.withOpacity(0.2)),
            ),
            child: Column(
              children: report.strengths.map((strength) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Iconsax.star1, color: AppColors.success, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(strength, style: AppTypography.body)),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }
}
