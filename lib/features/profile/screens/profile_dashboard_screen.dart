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
import '../../../shared/components/atoms/app_avatar.dart';
import '../providers/profile_provider.dart';
import '../models/profile_model.dart';

class ProfileDashboardScreen extends ConsumerStatefulWidget {
  const ProfileDashboardScreen({super.key});

  @override
  ConsumerState<ProfileDashboardScreen> createState() =>
      _ProfileDashboardScreenState();
}

class _ProfileDashboardScreenState
    extends ConsumerState<ProfileDashboardScreen> {
  int _selectedTabIndex =
      0; // 0 for Academic, 1 for Preferences, 2 for Achievements

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(profileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHero(data, isDark),
                    _buildApplicationSummary(data, isDark),
                    _buildAIInsights(data, isDark),
                    _buildTabs(isDark),
                    if (_selectedTabIndex == 0)
                      _buildAcademicPortfolio(data, isDark),
                    if (_selectedTabIndex == 1) _buildPreferences(data, isDark),
                    if (_selectedTabIndex == 2)
                      _buildAchievements(data, isDark),
                    const SizedBox(height: 120),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text('Student Profile', style: AppTypography.titleLarge),
          ),
          AppIconButton(
            icon: Iconsax.setting_2,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(ProfileData data, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p24, vertical: AppSpacing.p8),
      padding: const EdgeInsets.all(AppSpacing.p32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10)),
        ],
        border: Border.all(
            color: (isDark ? AppColors.darkBorder : AppColors.border)
                .withOpacity(0.5)),
      ),
      child: Column(
        children: [
          AppAvatar(imageUrl: data.photoUrl, size: 100)
              .animate()
              .scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: AppSpacing.p24),
          Text(data.name, style: AppTypography.display.copyWith(fontSize: 28)),
          const SizedBox(height: AppSpacing.p8),
          Text('${data.educationLevel} • ${data.targetDegree}',
              style: AppTypography.labelLarge
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.p32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeroStat(
                  'Completion',
                  '${data.profileCompletionPercentage}%',
                  Iconsax.profile_circle,
                  AppColors.primary),
              Container(
                  width: 1,
                  height: 40,
                  color: (isDark ? AppColors.darkBorder : AppColors.border)),
              _buildHeroStat('Readiness', '${data.aiReadinessScore}%',
                  Iconsax.magic_star, Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStat(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: AppSpacing.p8),
            Text(value, style: AppTypography.titleLarge.copyWith(color: color)),
          ],
        ),
        const SizedBox(height: AppSpacing.p4),
        Text(label,
            style: AppTypography.labelMedium
                .copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildApplicationSummary(ProfileData data, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Application Summary', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p16),
          Row(
            children: [
              _buildSummaryCard(
                  'Apps Submitted',
                  data.applicationsSubmitted.toString(),
                  Iconsax.document_upload,
                  AppColors.primary),
              const SizedBox(width: AppSpacing.p12),
              _buildSummaryCard('Saved Aid', data.scholarshipsSaved.toString(),
                  Iconsax.wallet_money, AppColors.success),
            ],
          ),
          const SizedBox(height: AppSpacing.p12),
          Row(
            children: [
              _buildSummaryCard('Resume Score', '${data.resumeScore}%',
                  Iconsax.document_text, Colors.indigo),
              const SizedBox(width: AppSpacing.p12),
              _buildSummaryCard('Interview Score', '${data.interviewScore}%',
                  Iconsax.video, Colors.purple),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: SquircleCard(
        padding: const EdgeInsets.all(AppSpacing.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.p8),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: AppSpacing.p16),
            Text(value, style: AppTypography.display.copyWith(fontSize: 28)),
            const SizedBox(height: AppSpacing.p4),
            Text(title,
                style: AppTypography.caption
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsights(ProfileData data, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
      padding: const EdgeInsets.all(AppSpacing.p32),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 24,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: Colors.white, size: 28)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .shimmer(),
              const SizedBox(width: AppSpacing.p12),
              Text('AI Profile Insights',
                  style:
                      AppTypography.titleLarge.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: AppSpacing.p24),
          ...data.aiInsights.map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.p16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: CircleAvatar(
                          radius: 4, backgroundColor: Colors.white54),
                    ),
                    const SizedBox(width: AppSpacing.p16),
                    Expanded(
                        child: Text(insight,
                            style: AppTypography.bodyMedium
                                .copyWith(color: Colors.white, height: 1.5))),
                  ],
                ),
              )),
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildTabs(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.p8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: (isDark ? AppColors.darkBorder : AppColors.border)
                  .withOpacity(0.5)),
        ),
        child: Row(
          children: [
            _buildTabItem(0, 'Academic', isDark),
            _buildTabItem(1, 'Preferences', isDark),
            _buildTabItem(2, 'Achievements', isDark),
          ],
        ),
      ),
    ).animate().fade(delay: 300.ms);
  }

  Widget _buildTabItem(int index, String title, bool isDark) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.p12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF333333) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 4)
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary)
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcademicPortfolio(ProfileData data, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
      child: Column(
        children: [
          _buildInfoRow(
              'Current GPA', data.currentGpa, Iconsax.chart_2, isDark),
          _buildInfoRow(
              'Test Scores', data.standardizedTests, Iconsax.award, isDark),
          _buildInfoRow(
              'Research', data.researchExperience, Iconsax.microscope, isDark),
          _buildInfoRow('Projects', data.projects, Iconsax.cpu, isDark),
          _buildInfoRow('Skills', data.skills, Iconsax.code, isDark),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildPreferences(ProfileData data, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
      child: Column(
        children: [
          _buildInfoRow('Target Countries', data.targetCountries.join(', '),
              Iconsax.global, isDark),
          _buildInfoRow('Budget', data.budget, Iconsax.wallet, isDark),
          _buildInfoRow('Aid Preference', data.scholarshipPreference,
              Iconsax.money_tick, isDark),
          _buildInfoRow('Study Mode', data.studyMode, Iconsax.book, isDark),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildAchievements(ProfileData data, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
      child: SquircleCard(
        padding: const EdgeInsets.all(AppSpacing.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.achievements
              .map((ach) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.p16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.success,
                          radius: 12,
                          child: Icon(Iconsax.verify,
                              color: Colors.white, size: 12),
                        ),
                        const SizedBox(width: AppSpacing.p16),
                        Expanded(
                            child: Text(ach, style: AppTypography.labelLarge)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildInfoRow(String label, String value, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.p12),
      child: SquircleCard(
        padding: const EdgeInsets.all(AppSpacing.p20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.p12),
              decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: AppSpacing.p16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.p4),
                  Text(value, style: AppTypography.titleMedium),
                ],
              ),
            ),
            const Icon(Iconsax.edit_2,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
