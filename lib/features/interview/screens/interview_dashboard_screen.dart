import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/interview_provider.dart';

class InterviewDashboardScreen extends ConsumerWidget {
  const InterviewDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(interviewNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Coach'),
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
            _buildHeroCard(context),
            _buildSessionHistory(context, sessions),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Admission & Visa Practice', style: AppTypography.headline.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            'Practice questions via speech or text input. Get instant AI score, clarity analysis, and improvement tips.',
            style: AppTypography.body.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.push('/interview/mock'),
            icon: const Icon(Iconsax.video_play, color: AppColors.primary),
            label: const Text('Start Mock Interview Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.05);
  }

  Widget _buildSessionHistory(BuildContext context, List sessions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Interview Sessions', style: AppTypography.subheading),
          const SizedBox(height: 12),
          if (sessions.isEmpty)
            Text('No sessions recorded yet.', style: AppTypography.caption)
          else
            ...sessions.map(
              (sess) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  onTap: () => context.push('/interview/report', extra: sess),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.12),
                    child: Text('${sess.score}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                  title: Text(sess.questionTitle, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('Practiced on ${sess.date}', style: AppTypography.caption),
                  trailing: const Icon(Iconsax.arrow_right_3, size: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
