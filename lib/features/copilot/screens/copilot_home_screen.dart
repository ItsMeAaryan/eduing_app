import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/molecules/squircle_card.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../../../shared/components/atoms/app_button.dart';
import '../providers/copilot_provider.dart';

class CopilotHomeScreen extends ConsumerWidget {
  const CopilotHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(copilotProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Gradient Element
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.aiGradient,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: const SizedBox(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, isDark),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHero(context, data, isDark),
                        _buildQuickActions(context, isDark),
                        _buildInsightsTile(context, data, isDark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Action Bar
          Positioned(
            bottom: AppSpacing.p24,
            left: AppSpacing.p24,
            right: AppSpacing.p24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.p8),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.darkSurface : Colors.white)
                        .withOpacity(0.8),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color:
                            (isDark ? AppColors.darkBorder : AppColors.border)
                                .withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10)),
                    ],
                  ),
                  child: AppButton(
                    text: 'Ask Strategist',
                    icon: Iconsax.magic_star,
                    onPressed: () => context.push('/copilot/chat'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Strategist', style: AppTypography.display),
              const SizedBox(height: AppSpacing.p4),
              Text('Your AI Admission Expert',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
          AppIconButton(
            icon: Iconsax.messages_2,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () => context.push('/copilot/chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, data, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p24, vertical: AppSpacing.p16),
      padding: const EdgeInsets.all(AppSpacing.p24),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 15)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.radar, color: Colors.white, size: 28),
              const SizedBox(width: AppSpacing.p12),
              Text('Overall Readiness',
                  style:
                      AppTypography.titleLarge.copyWith(color: Colors.white)),
              const Spacer(),
              Text('${data.overallReadiness}%',
                  style: AppTypography.display
                      .copyWith(color: Colors.white, fontSize: 32)),
            ],
          ),
          const SizedBox(height: AppSpacing.p24),
          Text(
            'Your intelligent study abroad assistant is ready to help draft SOPs, evaluate resumes, and prepare for interviews.',
            style: AppTypography.bodyMedium
                .copyWith(color: Colors.white.withOpacity(0.9), height: 1.5),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p24, vertical: AppSpacing.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Features', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p16),
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
              const SizedBox(width: AppSpacing.p12),
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
          const SizedBox(height: AppSpacing.p12),
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
              const SizedBox(width: AppSpacing.p12),
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: 'Vault Analysis',
                  icon: Iconsax.folder,
                  color: Colors.teal,
                  onTap: () => context.push('/documents'),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SquircleCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.p12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppSpacing.p16),
          Text(title,
              style: AppTypography.labelLarge
                  .copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInsightsTile(BuildContext context, data, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p24, vertical: AppSpacing.p16),
      child: SquircleCard(
        padding: const EdgeInsets.all(AppSpacing.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Iconsax.flash, color: Colors.amber),
                const SizedBox(width: AppSpacing.p12),
                Text('Personalized Insights', style: AppTypography.titleLarge),
              ],
            ),
            const SizedBox(height: AppSpacing.p20),
            ...data.recentInsights.map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.p12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.p12),
                    Expanded(
                        child: Text(insight,
                            style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary, height: 1.5))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }
}
