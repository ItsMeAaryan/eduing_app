import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/molecules/squircle_card.dart';

import '../../../shared/components/atoms/app_icon_button.dart';
import '../providers/planner_provider.dart';
import '../models/planner_model.dart';

class PlannerDashboardScreen extends ConsumerStatefulWidget {
  const PlannerDashboardScreen({super.key});

  @override
  ConsumerState<PlannerDashboardScreen> createState() =>
      _PlannerDashboardScreenState();
}

class _PlannerDashboardScreenState
    extends ConsumerState<PlannerDashboardScreen> {
  final List<String> _milestones = [
    'Research',
    'Shortlist',
    'Applications',
    'Documents',
    'Interviews',
    'Offers',
    'Visa',
    'Departure',
  ];

  // Mock current milestone index for UI purposes
  final int _currentMilestoneIndex = 2; // Applications

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(plannerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(isDark)),
            SliverToBoxAdapter(child: _buildMilestoneRoadmap(isDark)),
            SliverToBoxAdapter(
                child: _buildAIRecommendations(data.aiRecommendations, isDark)),
            SliverToBoxAdapter(child: _buildAgenda(data, isDark)),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Journey', style: AppTypography.display),
              const SizedBox(height: AppSpacing.p4),
              Text('Your admission roadmap.',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
          AppIconButton(
            icon: Iconsax.calendar_1,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneRoadmap(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
          child: Text('Current Milestone', style: AppTypography.titleLarge),
        ),
        const SizedBox(height: AppSpacing.p16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
            itemCount: _milestones.length,
            itemBuilder: (context, index) {
              final isCompleted = index < _currentMilestoneIndex;
              final isActive = index == _currentMilestoneIndex;
              final milestone = _milestones[index];

              return Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: isActive ? 56 : 48,
                        height: isActive ? 56 : 48,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.success
                              : isActive
                                  ? AppColors.primary
                                  : (isDark
                                      ? AppColors.darkSurface
                                      : AppColors.surface),
                          shape: BoxShape.circle,
                          border: isActive
                              ? Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                  width: 4)
                              : null,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8))
                                ]
                              : null,
                        ),
                        child: Icon(
                          isCompleted
                              ? Iconsax.tick_circle
                              : (isActive
                                  ? Iconsax.routing_2
                                  : Iconsax.location_add),
                          color: isCompleted || isActive
                              ? Colors.white
                              : AppColors.textSecondary,
                          size: isActive ? 24 : 20,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.p12),
                      Text(
                        milestone,
                        style: AppTypography.labelMedium.copyWith(
                          color: isActive
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary),
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  if (index < _milestones.length - 1)
                    Container(
                      width: 40,
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 28),
                      color: isCompleted
                          ? AppColors.success
                          : (isDark ? AppColors.darkBorder : AppColors.border),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildAIRecommendations(
      List<AIPlannerRecommendation> recommendations, bool isDark) {
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.p32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
            child: Row(
              children: [
                const Icon(Iconsax.magic_star,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.p8),
                Text('Copilot Suggestions', style: AppTypography.titleLarge),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.p16),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final rec = recommendations[index];
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: AppSpacing.p16),
                  padding: const EdgeInsets.all(AppSpacing.p20),
                  decoration: BoxDecoration(
                    gradient: AppColors.aiGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.p12,
                                vertical: AppSpacing.p4),
                            decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(rec.priority,
                                style: AppTypography.caption.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Text(rec.estimatedEffort,
                              style: AppTypography.caption
                                  .copyWith(color: Colors.white70)),
                        ],
                      ),
                      const Spacer(),
                      Text(rec.suggestion,
                          style: AppTypography.titleMedium.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildAgenda(PlannerDashboardData data, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.p24, AppSpacing.p40, AppSpacing.p24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Action Items', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p16),
          if (data.todayAgenda.isEmpty && data.upcomingDeadlines.isEmpty)
            _buildEmptyState(isDark)
          else ...[
            ...data.todayAgenda.map((e) => _buildEventCard(e, isDark)),
            ...data.upcomingDeadlines.map((e) => _buildEventCard(e, isDark)),
          ]
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildEventCard(PlannerEvent event, bool isDark) {
    Color getEventColor() {
      switch (event.type) {
        case EventType.application:
          return AppColors.primary;
        case EventType.interview:
          return AppColors.secondary;
        case EventType.scholarship:
          return AppColors.success;
        case EventType.resume:
          return AppColors.warning;
        case EventType.sop:
          return Colors.purple;
        case EventType.document:
          return Colors.orange;
        default:
          return AppColors.textSecondary;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.p16),
      child: SquircleCard(
        padding: const EdgeInsets.all(AppSpacing.p20),
        onTap: () =>
            ref.read(plannerProvider.notifier).toggleTaskCompletion(event.id),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    event.isCompleted ? AppColors.success : Colors.transparent,
                border: Border.all(
                    color: event.isCompleted
                        ? AppColors.success
                        : (isDark ? AppColors.darkBorder : AppColors.border),
                    width: 2),
              ),
              child: event.isCompleted
                  ? const Icon(Iconsax.tick_circle,
                      color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: AppSpacing.p16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppTypography.titleMedium.copyWith(
                      decoration:
                          event.isCompleted ? TextDecoration.lineThrough : null,
                      color: event.isCompleted
                          ? AppColors.textSecondary
                          : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.p4),
                  Text(event.description,
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(DateFormat('MMM d').format(event.date),
                    style: AppTypography.labelMedium.copyWith(
                        color: getEventColor(), fontWeight: FontWeight.bold)),
                if (event.type == EventType.application ||
                    event.type == EventType.scholarship)
                  Container(
                    margin: const EdgeInsets.only(top: AppSpacing.p8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.p8, vertical: AppSpacing.p4),
                    decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text('Deadline',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.error)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.p32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  shape: BoxShape.circle),
              child: const Icon(Iconsax.calendar_tick,
                  size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.p24),
            Text('You\'re All Caught Up', style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.p8),
            Text(
              'No pending tasks for this milestone. Check your AI recommendations for next steps.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
