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
      appBar: AppBar(
        title: const Text('EDUIng AI Copilot'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.messages_2, color: AppColors.primary),
            onPressed: () => context.push('/copilot/chat'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(context, data),
            _buildQuickActions(context),
            _buildInsightsTile(context, data),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/copilot/chat'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.message, color: Colors.white),
        label: const Text('Chat with Copilot'),
      ),
    );
  }

  Widget _buildHero(BuildContext context, data) {
    return Container(
      width: double.infinity,
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
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: Colors.white, size: 28),
              const SizedBox(width: 10),
              Text('Overall Readiness: ${data.overallReadiness}%', style: AppTypography.headline.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your intelligent study abroad assistant is ready to help draft SOPs, evaluate resumes, and prepare for interviews.',
            style: AppTypography.body.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.push('/copilot/chat'),
            icon: const Icon(Iconsax.message, color: AppColors.primary),
            label: const Text('Ask AI Copilot Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.05);
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Feature Shortcuts', style: AppTypography.subheading),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: 'SOP Builder',
                  icon: Iconsax.document_text,
                  color: AppColors.primary,
                  onTap: () => context.push('/sop'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: 'Resume Builder',
                  icon: Iconsax.user_edit,
                  color: AppColors.secondary,
                  onTap: () => context.push('/resume'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: 'Interview Coach',
                  icon: Iconsax.video_play,
                  color: Colors.orange,
                  onTap: () => context.push('/interview'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: 'Document Vault',
                  icon: Iconsax.folder,
                  color: Colors.teal,
                  onTap: () => context.push('/documents'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsTile(BuildContext context, data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personalized AI Insights', style: AppTypography.subheading),
          const SizedBox(height: 12),
          ...data.recentInsights.map(
            (insight) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Iconsax.flash, color: Colors.amber, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(insight, style: AppTypography.body)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
