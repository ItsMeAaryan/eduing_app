import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../models/interview_model.dart';

class InterviewReportScreen extends StatelessWidget {
  final InterviewSession? session;

  const InterviewReportScreen({super.key, this.session});

  @override
  Widget build(BuildContext context) {
    final report = session?.report ?? const AIInterviewReport();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Performance Report'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreHeader(report),
            _buildMetrics(context, report),
            if (session?.userTranscript != null && session!.userTranscript.isNotEmpty)
              _buildTranscriptTile(context, session!.userTranscript),
            _buildRecommendations(report),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreHeader(AIInterviewReport report) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Text('${report.overallScore}', style: AppTypography.headline.copyWith(fontSize: 56, color: Colors.white)),
            Text('Overall Practice Score', style: AppTypography.title.copyWith(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    ).animate().fade().scale();
  }

  Widget _buildMetrics(BuildContext context, AIInterviewReport report) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Key Performance Indicators', style: AppTypography.subheading),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                _buildRow('Confidence', report.confidence),
                _buildRow('Communication', report.communication),
                _buildRow('Technical Depth', report.technicalKnowledge),
                _buildRow('Clarity', report.clarity),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, int score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.label)),
          Text('$score%', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildTranscriptTile(BuildContext context, String transcript) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recorded Transcript', style: AppTypography.subheading),
          const SizedBox(height: 8),
          Text(transcript, style: AppTypography.body),
        ],
      ),
    );
  }

  Widget _buildRecommendations(AIInterviewReport report) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Recommendations', style: AppTypography.subheading),
          const SizedBox(height: 12),
          ...report.recommendations.map(
            (rec) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 14,
                  child: Icon(Iconsax.flash, size: 14, color: Colors.white),
                ),
                title: Text(rec.text, style: AppTypography.body),
                subtitle: Text('Impact: ${rec.estimatedImpact} • Priority: ${rec.priority}', style: AppTypography.caption),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
