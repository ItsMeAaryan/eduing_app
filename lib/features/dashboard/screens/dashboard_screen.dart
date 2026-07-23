import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/models/dashboard_data.dart';
import '../providers/dashboard_provider.dart';

// Reusable Components
import '../../../shared/components/atoms/app_avatar.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../../../shared/components/atoms/status_pill.dart';
import '../../../shared/components/molecules/quick_action_tile.dart';
import '../../../shared/components/molecules/metric_item.dart';
import '../../../shared/components/molecules/squircle_card.dart';
import '../../../shared/components/organisms/admission_progress_card.dart';
import '../../../shared/components/organisms/premium_application_card.dart';
import '../../../shared/components/organisms/planner_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24, vertical: AppSpacing.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DashboardGreeting(user: user),
              const SizedBox(height: AppSpacing.p24),
              const _HeroAiCard(),
              const SizedBox(height: AppSpacing.p32),
              const _QuickActionsGrid(),
              const SizedBox(height: AppSpacing.p32),
              const _AdmissionProgressSection(),
              const SizedBox(height: AppSpacing.p32),
              const _StatisticsOverview(),
              const SizedBox(height: AppSpacing.p32),
              const _RecentApplicationsList(),
              const SizedBox(height: AppSpacing.p32),
              const _UpcomingDeadlinesList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardGreeting extends StatelessWidget {
  final UserProfile user;

  const _DashboardGreeting({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Evening,',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.p4),
            Row(
              children: [
                Text(
                  user.name,
                  style: AppTypography.headline.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.p8),
                const Text('👋', style: TextStyle(fontSize: 24)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            AppIconButton(
              icon: Iconsax.notification,
              isFilled: true,
              onPressed: () {},
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.05, 1.05),
              duration: 1.seconds,
            ),
            const SizedBox(width: AppSpacing.p12),
            AppAvatar(
              imageUrl: user.avatarUrl,
              size: 44,
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroAiCard extends StatelessWidget {
  const _HeroAiCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SquircleCard(
        color: Colors.transparent,
        padding: const EdgeInsets.all(AppSpacing.p24),
        hasShadow: true,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.magic_star, color: Colors.white, size: 20),
                    const SizedBox(width: AppSpacing.p8),
                    Text(
                      'EDUIng AI Insight',
                      style: AppTypography.labelMedium.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.p16),
                Text(
                  'Improve your SOP to increase admission probability by 6%',
                  style: AppTypography.titleMedium.copyWith(color: Colors.white, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.p16),
          Container(
            padding: const EdgeInsets.all(AppSpacing.p16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              '91%',
              style: AppTypography.headline.copyWith(color: Colors.white),
            ),
          ).animate().shimmer(duration: 2.seconds, delay: 1.seconds, color: Colors.white54),
        ],
      ),
    )).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
      begin: const Offset(1, 1),
      end: const Offset(1.02, 1.02),
      duration: 2.seconds,
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: QuickActionTile(
            label: 'Applications',
            icon: Iconsax.document,
            onTap: () => context.push('/applications'),
          ),
        ),
        const SizedBox(width: AppSpacing.p12),
        Expanded(
          child: QuickActionTile(
            label: 'Universities',
            icon: Iconsax.building,
            onTap: () => context.push('/universities'),
          ),
        ),
        const SizedBox(width: AppSpacing.p12),
        Expanded(
          child: QuickActionTile(
            label: 'Documents',
            icon: Iconsax.folder,
            onTap: () => context.push('/documents'),
          ),
        ),
        const SizedBox(width: AppSpacing.p12),
        Expanded(
          child: QuickActionTile(
            label: 'Planner',
            icon: Iconsax.calendar,
            onTap: () => context.push('/planner'),
          ),
        ),
      ],
    );
  }
}

class _AdmissionProgressSection extends ConsumerWidget {
  const _AdmissionProgressSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Admission Journey', style: AppTypography.titleLarge),
        const SizedBox(height: AppSpacing.p16),
        AdmissionProgressCard(
          readinessPercentage: stats.profileStrength.toInt(),
          applicationsCount: stats.applications,
          documentsCount: 10, // hardcoded for demo
          onImproveWithAI: () {},
        ),
      ],
    ).animate().fade(duration: 500.ms).slideY(begin: 0.1, curve: Curves.easeOutQuad);
  }
}

class _StatisticsOverview extends ConsumerWidget {
  const _StatisticsOverview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overview', style: AppTypography.titleLarge),
        const SizedBox(height: AppSpacing.p16),
        Row(
          children: [
            Expanded(
              child: SquircleCard(
                padding: const EdgeInsets.all(AppSpacing.p16),
                child: MetricItem(
                  label: 'Offers',
                  value: stats.offersReceived.toString(),
                  icon: Iconsax.award,
                  trend: '+2',
                  isPositiveTrend: true,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.p16),
            Expanded(
              child: SquircleCard(
                padding: const EdgeInsets.all(AppSpacing.p16),
                child: MetricItem(
                  label: 'Scholarships',
                  value: stats.scholarships.toString(),
                  icon: Iconsax.coin,
                  trend: '+1',
                  isPositiveTrend: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UpcomingDeadlinesList extends ConsumerWidget {
  const _UpcomingDeadlinesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deadlines = ref.watch(upcomingDeadlinesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Upcoming Deadlines', style: AppTypography.titleLarge),
            Text('View all', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: AppSpacing.p16),
        ...deadlines.map((d) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.p12),
          child: PlannerCard(
            title: d.task,
            date: d.date,
            type: d.priority,
          ),
        )),
      ],
    ).animate().fade(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1);
  }
}

class _RecentApplicationsList extends ConsumerWidget {
  const _RecentApplicationsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(recentApplicationsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Applications', style: AppTypography.titleLarge),
            Text('View all', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: AppSpacing.p16),
        ...applications.map((app) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.p16),
          child: PremiumApplicationCard(
            logoUrl: app.logoUrl,
            universityName: app.university,
            course: app.campus, // Using campus as course for demo since model doesn't have course
            status: _mapStatus(app.status),
            deadline: 'TBD',
            progress: app.aiMatch / 100.0,
            onTap: () {},
            onMenuTap: () {},
          ),
        )),
      ],
    ).animate().fade(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1);
  }

  StatusType _mapStatus(String statusText) {
    switch(statusText.toLowerCase()) {
      case 'submitted': return StatusType.submitted;
      case 'under review': return StatusType.underReview;
      case 'accepted': return StatusType.accepted;
      case 'rejected': return StatusType.rejected;
      case 'not started': return StatusType.notStarted;
      default: return StatusType.inProgress;
    }
  }
}
