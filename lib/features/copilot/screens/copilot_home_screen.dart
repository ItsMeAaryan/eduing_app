import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/copilot_provider.dart';

class CopilotHomeScreen extends ConsumerWidget {
  const CopilotHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(copilotProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.setting_2, color: AppColors.textPrimary),
          onPressed: () => context.push('/ai/settings'),
        ),
        title: Text('EDUIng Copilot', style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.messages_2, color: AppColors.primary),
            onPressed: () => context.push('/ai/chat'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(context, data),
            _buildQuickActions(context, ref),
            _buildSuggestedPrompts(context, ref),
            _buildDashboard(data),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/ai/chat'),
        backgroundColor: AppColors.primary,
        child: const Icon(Iconsax.message, color: Colors.white),
      ).animate().scale(delay: 500.ms),
    );
  }

  Widget _buildHero(BuildContext context, data) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Iconsax.magic_star, color: Colors.white, size: 32).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 2.seconds),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(16)),
                child: Text('Readiness: ${data.overallReadiness}%', style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Hello Prince,', style: AppTypography.headline.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text('Your Stanford application is looking strong. Should we review your SOP today?', style: AppTypography.body.copyWith(color: Colors.white70)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/ai/chat'),
            icon: const Icon(Iconsax.message, color: AppColors.primary),
            label: const Text('Start Chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    ).animate().fade().scale();
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: AppTypography.title),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildActionCard(context, ref, 'Review SOP', Iconsax.document_text),
              const SizedBox(width: 12),
              _buildActionCard(context, ref, 'Find Scholarships', Iconsax.wallet_money),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionCard(context, ref, 'Interview Prep', Iconsax.video),
              const SizedBox(width: 12),
              _buildActionCard(context, ref, 'Summarize Status', Iconsax.chart),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildActionCard(BuildContext context, WidgetRef ref, String title, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(copilotProvider.notifier).sendMessage('I want to $title');
          context.push('/ai/chat');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: AppTypography.label, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedPrompts(BuildContext context, WidgetRef ref) {
    final prompts = [
      'Compare my resume with my scholarship eligibility.',
      'What documents are missing for MIT?',
      'Generate an interview question for Leadership.',
      'Summarize my application progress.',
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Suggested Prompts', style: AppTypography.title),
          const SizedBox(height: 16),
          ...prompts.map((prompt) => GestureDetector(
            onTap: () {
              ref.read(copilotProvider.notifier).sendMessage(prompt);
              context.push('/ai/chat');
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.message_text, color: AppColors.primary, size: 16),
                  const SizedBox(width: 12),
                  Expanded(child: Text(prompt, style: AppTypography.caption)),
                ],
              ),
            ),
          )),
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildDashboard(data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Intelligence', style: AppTypography.title),
          const SizedBox(height: 16),
          _buildInsightSection('Recent Insights', data.recentInsights, Iconsax.lamp_on, AppColors.warning),
          const SizedBox(height: 16),
          _buildInsightSection('Priority Tasks', data.priorityTasks, Iconsax.task_square, AppColors.error),
          const SizedBox(height: 16),
          _buildInsightSection('Upcoming Deadlines', data.upcomingDeadlines, Iconsax.clock, AppColors.primary),
        ],
      ),
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildInsightSection(String title, List<String> items, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 12),
              Text(title, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: CircleAvatar(radius: 3, backgroundColor: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(item, style: AppTypography.caption)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
