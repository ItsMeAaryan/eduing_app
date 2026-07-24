import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/models/university_model.dart';
import '../../../shared/components/molecules/squircle_card.dart';
import '../../../shared/components/atoms/app_button.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../providers/universities_provider.dart';
import '../../applications/providers/applications_provider.dart';

class UniversityDetailsScreen extends ConsumerWidget {
  final String universityId;

  const UniversityDetailsScreen({super.key, required this.universityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final universities = ref.watch(universitiesProvider);
    final university = universities.firstWhere(
      (u) => u.id == universityId,
      orElse: () => universities.first,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, university, ref, isDark),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.p24, AppSpacing.p24, AppSpacing.p24, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderInfo(university, isDark),
                      const SizedBox(height: AppSpacing.p32),
                      _buildBentoGrid(university, isDark),
                      const SizedBox(height: AppSpacing.p32),
                      _buildPrograms(university, isDark),
                      const SizedBox(height: AppSpacing.p32),
                      _buildFacilities(university, isDark),
                      const SizedBox(height: AppSpacing.p32),
                      _buildAIInsights(university, isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildFloatingActionBar(context, university, ref, isDark),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, University university, WidgetRef ref, bool isDark) {
    final notifier = ref.read(universitiesProvider.notifier);
    return SliverAppBar(
      expandedHeight: 360,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: AppIconButton(
          icon: Iconsax.arrow_left_2,
          isFilled: true,
          backgroundColor: isDark ? AppColors.darkSurface.withOpacity(0.8) : Colors.white.withOpacity(0.8),
          onPressed: () => context.pop(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: AppIconButton(
            icon: university.isFavorite ? Iconsax.heart5 : Iconsax.heart,
            color: university.isFavorite ? AppColors.error : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface.withOpacity(0.8) : Colors.white.withOpacity(0.8),
            onPressed: () => notifier.toggleFavorite(university.id),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'hero_${university.id}',
              child: Image.network(
                university.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                  stops: const [0.4, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(University university, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border, width: 2),
                image: DecorationImage(
                  image: NetworkImage(university.logoUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.p20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    university.name,
                    style: AppTypography.display.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1),
                  ),
                  const SizedBox(height: AppSpacing.p8),
                  Text(
                    university.location,
                    style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.p24),
        Text(
          university.description,
          style: AppTypography.bodyLarge.copyWith(height: 1.6, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
        ),
      ],
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildBentoGrid(University university, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('At a Glance', style: AppTypography.titleLarge),
        const SizedBox(height: AppSpacing.p16),
        Row(
          children: [
            Expanded(
              child: _buildBentoBox(
                isDark,
                icon: Iconsax.global,
                title: 'Global Rank',
                value: '#${university.nirfRanking}',
                valueColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.p16),
            Expanded(
              child: _buildBentoBox(
                isDark,
                icon: Iconsax.percentage_circle,
                title: 'Acceptance',
                value: '${university.admissionProbability}%',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.p16),
        Row(
          children: [
            Expanded(
              child: _buildBentoBox(
                isDark,
                icon: Iconsax.wallet_money,
                title: 'Avg. Tuition',
                value: university.fees,
              ),
            ),
            const SizedBox(width: AppSpacing.p16),
            Expanded(
              child: _buildBentoBox(
                isDark,
                icon: Iconsax.profile_2user,
                title: 'Students',
                value: university.studentCount,
              ),
            ),
          ],
        ),
      ],
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildBentoBox(bool isDark, {required IconData icon, required String title, required String value, Color? valueColor}) {
    return SquircleCard(
      padding: const EdgeInsets.all(AppSpacing.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 24),
          const SizedBox(height: AppSpacing.p16),
          Text(title, style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.p4),
          Text(value, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildPrograms(University university, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Programs Offered', style: AppTypography.titleLarge),
        const SizedBox(height: AppSpacing.p16),
        Wrap(
          spacing: AppSpacing.p12,
          runSpacing: AppSpacing.p12,
          children: university.coursesList.map((course) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p16, vertical: AppSpacing.p12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: (isDark ? AppColors.darkBorder : AppColors.border).withOpacity(0.5)),
              ),
              child: Text(course, style: AppTypography.labelMedium),
            );
          }).toList(),
        ),
      ],
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildFacilities(University university, bool isDark) {
    return SquircleCard(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Campus Facilities', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p20),
          ...university.facilities.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.p12),
            child: Row(
              children: [
                const Icon(Iconsax.verify, color: AppColors.success, size: 20),
                const SizedBox(width: AppSpacing.p12),
                Text(f, style: AppTypography.bodyMedium),
              ],
            ),
          )),
        ],
      ),
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildAIInsights(University university, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.p24),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: Colors.white, size: 24),
              const SizedBox(width: AppSpacing.p12),
              Text('AI Analysis', style: AppTypography.titleLarge.copyWith(color: Colors.white)),
              const Spacer(),
              Text('${university.aiMatch}% Match', style: AppTypography.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppSpacing.p24),
          Text(
            'Based on your profile, this university is a strong match. Your academics align with their acceptance criteria, and their programs match your career goals.',
            style: AppTypography.bodyMedium.copyWith(color: Colors.white.withOpacity(0.9), height: 1.5),
          ),
        ],
      ),
    ).animate().fade(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildFloatingActionBar(BuildContext context, University university, WidgetRef ref, bool isDark) {
    return Positioned(
      bottom: AppSpacing.p24,
      left: AppSpacing.p24,
      right: AppSpacing.p24,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.p16),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkSurface : AppColors.surface).withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: (isDark ? AppColors.darkBorder : AppColors.border).withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                AppIconButton(
                  icon: Iconsax.arrange_square,
                  isFilled: true,
                  backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
                  onPressed: () => context.push('/compare', extra: [university.id, university.id == '1' ? '2' : '1']),
                ),
                const SizedBox(width: AppSpacing.p16),
                Expanded(
                  child: AppButton(
                    text: 'Start Application',
                    icon: Iconsax.document_text,
                    onPressed: () {
                      ref.read(applicationsNotifierProvider.notifier).createApplication(
                        universityName: university.name,
                        course: university.course,
                        deadline: '01 Dec 2025',
                      );
                      context.go('/applications');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
