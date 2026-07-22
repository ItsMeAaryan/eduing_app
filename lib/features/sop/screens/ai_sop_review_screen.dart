import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/sop_provider.dart';
import '../models/sop_model.dart';

class AISopReviewScreen extends ConsumerWidget {
  const AISopReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sop = ref.watch(sopProvider);
    final review = sop.review;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI SOP Audit'),
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
            _buildOverallScore(review),
            _buildDetailedScores(context, review),
            _buildRecommendations(review),
            _buildStrengths(review),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallScore(AISopReview review) {
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
            const Icon(Iconsax.magic_star, color: Colors.white, size: 44)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(duration: 2.seconds),
            const SizedBox(height: 12),
            Text('${review.overallScore}', style: AppTypography.headline.copyWith(fontSize: 56, color: Colors.white)),
            Text('Overall SOP Quality Score', style: AppTypography.title.copyWith(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    ).animate().fade().scale();
  }

  Widget _buildDetailedScores(BuildContext context, AISopReview review) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detailed Analysis', style: AppTypography.subheading),
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
                _buildScoreRow('Grammar & Tone', review.grammar),
                _buildScoreRow('Clarity & Conciseness', review.clarity),
                _buildScoreRow('Structure & Flow', review.structure),
                _buildScoreRow('Storytelling & Hook', review.storytelling),
                _buildScoreRow('Research & Alignment', review.researchDepth),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.05);
  }

  Widget _buildScoreRow(String label, int score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.label)),
          Text('$score%', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildRecommendations(AISopReview review) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Recommendations', style: AppTypography.subheading),
          const SizedBox(height: 12),
          ...review.recommendations.map(
            (rec) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 14,
                  child: Icon(Iconsax.flash, size: 14, color: Colors.white),
                ),
                title: Text(rec.text, style: AppTypography.body),
                subtitle: Text('Impact: ${rec.estimatedImprovement} • Priority: ${rec.priority}', style: AppTypography.caption),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengths(AISopReview review) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Key Strengths', style: AppTypography.subheading),
          const SizedBox(height: 12),
          ...review.strengths.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Iconsax.tick_circle, color: AppColors.success, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(s, style: AppTypography.body)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
