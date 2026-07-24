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
import '../../../shared/components/atoms/app_button.dart';
import '../../../shared/components/atoms/status_pill.dart';
import '../../../shared/components/molecules/quick_action_tile.dart';
import '../../../shared/components/molecules/metric_item.dart';
import '../../../shared/components/molecules/squircle_card.dart';
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
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.p24, vertical: AppSpacing.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DashboardGreeting(user: user),
              const SizedBox(height: AppSpacing.p32),
              const _HeroCommandCenter(),
              const SizedBox(height: AppSpacing.p32),
              const _QuickActionsGrid(),
              const SizedBox(height: AppSpacing.p40),
              const _StatisticsOverview(),
              const SizedBox(height: AppSpacing.p40),
              const _RecentApplicationsList(),
              const SizedBox(height: AppSpacing.p40),
              const _TimelineDeadlinesList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardGreeting extends ConsumerWidget {
  final UserProfile user;

  const _DashboardGreeting({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final readiness = stats.profileStrength.toInt();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Good Evening,',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: AppSpacing.p4),
                  Text(user.name,
                      style: AppTypography.titleMedium
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: AppSpacing.p8),
              Text(
                "You're $readiness% ready for Fall 2027 admissions.",
                style: AppTypography.headline.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.p16),
        Row(
          children: [
            AppIconButton(
              icon: Iconsax.notification,
              isFilled: true,
              onPressed: () => context.push('/notifications'),
            ),
            const SizedBox(width: AppSpacing.p12),
            AppAvatar(
              imageUrl: user.avatarUrl,
              size: 40,
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroCommandCenter extends ConsumerWidget {
  const _HeroCommandCenter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final readiness = stats.profileStrength.toInt();

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: SquircleCard(
        color: Colors.transparent,
        padding: const EdgeInsets.all(AppSpacing.p24),
        hasShadow: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admission Readiness',
                      style: AppTypography.labelMedium
                          .copyWith(color: Colors.white.withValues(alpha: 0.8)),
                    ),
                    const SizedBox(height: AppSpacing.p4),
                    Text(
                      '$readiness%',
                      style:
                          AppTypography.display.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.p12, vertical: AppSpacing.p8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.magic_star,
                          color: Colors.white, size: 16),
                      const SizedBox(width: AppSpacing.p8),
                      Text(
                        '4 Tasks Left',
                        style: AppTypography.labelMedium
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.p24),
            Container(
              padding: const EdgeInsets.all(AppSpacing.p16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next Priority',
                          style: AppTypography.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.7)),
                        ),
                        const SizedBox(height: AppSpacing.p4),
                        Text(
                          'Upload IELTS Score',
                          style: AppTypography.titleMedium
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    text: 'Resolve',
                    variant: AppButtonVariant.secondary,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
          begin: const Offset(1, 1),
          end: const Offset(1.01, 1.01),
          duration: 3.seconds,
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
            label: 'Documents',
            subtitle: '2 Pending',
            icon: Iconsax.document,
            onTap: () => context.push('/documents'),
          ),
        ),
        const SizedBox(width: AppSpacing.p8),
        Expanded(
          child: QuickActionTile(
            label: 'Universities',
            subtitle: '18 Saved',
            icon: Iconsax.building,
            onTap: () => context.push('/universities'),
          ),
        ),
        const SizedBox(width: AppSpacing.p8),
        Expanded(
          child: QuickActionTile(
            label: 'Applications',
            subtitle: '5 Active',
            icon: Iconsax.send_2,
            onTap: () => context.push('/applications'),
          ),
        ),
        const SizedBox(width: AppSpacing.p8),
        Expanded(
          child: QuickActionTile(
            label: 'Copilot',
            subtitle: 'Session',
            icon: Iconsax.magic_star,
            onTap: () => context.push('/planner'),
          ),
        ),
      ],
    );
  }
}

class _StatisticsOverview extends ConsumerWidget {
  const _StatisticsOverview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    return Row(
      children: [
        Expanded(
          child: SquircleCard(
            padding: const EdgeInsets.all(AppSpacing.p20),
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
            padding: const EdgeInsets.all(AppSpacing.p20),
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
    );
  }
}

class _TimelineDeadlinesList extends ConsumerWidget {
  const _TimelineDeadlinesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deadlines = ref.watch(upcomingDeadlinesProvider);

    // Grouping logic (simplified for UI demonstration)
    final today = deadlines.take(1).toList();
    final thisWeek = deadlines.skip(1).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Timeline', style: AppTypography.titleLarge),
            Text('View all',
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: AppSpacing.p24),
        if (today.isNotEmpty) ...[
          const _TimelineHeader('Today'),
          const SizedBox(height: AppSpacing.p12),
          ...today.map((d) => _TimelineItem(deadline: d)),
          const SizedBox(height: AppSpacing.p24),
        ],
        if (thisWeek.isNotEmpty) ...[
          const _TimelineHeader('This Week'),
          const SizedBox(height: AppSpacing.p12),
          ...thisWeek.map((d) => _TimelineItem(deadline: d)),
        ],
      ],
    ).animate().fade(duration: 500.ms).slideY(begin: 0.1);
  }
}

class _TimelineHeader extends StatelessWidget {
  final String title;
  const _TimelineHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: title == 'Today' ? AppColors.error : AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.p12),
        Text(title,
            style: AppTypography.labelLarge
                .copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Deadline deadline;
  const _TimelineItem({required this.deadline});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: AppSpacing.p12),
      child: PlannerCard(
        title: deadline.task,
        date: deadline.date,
        type: deadline.priority,
      ),
    );
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
            Text('Active Applications', style: AppTypography.titleLarge),
            Text('View all',
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: AppSpacing.p24),
        ...applications.map((app) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.p20),
              child: PremiumApplicationCard(
                logoUrl: app.logoUrl,
                universityName: app.university,
                course: app.campus,
                status: _mapStatus(app.status),
                deadline: 'Aug 30',
                progress: app.aiMatch / 100.0,
                onTap: () {},
                onMenuTap: () {},
              ),
            )),
      ],
    ).animate().fade(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1);
  }

  StatusType _mapStatus(String statusText) {
    switch (statusText.toLowerCase()) {
      case 'submitted':
        return StatusType.submitted;
      case 'under review':
        return StatusType.underReview;
      case 'accepted':
        return StatusType.accepted;
      case 'rejected':
        return StatusType.rejected;
      case 'not started':
        return StatusType.notStarted;
      default:
        return StatusType.inProgress;
    }
  }
}
