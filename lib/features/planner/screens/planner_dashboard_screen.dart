import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/planner_provider.dart';
import '../models/planner_model.dart';

class PlannerDashboardScreen extends ConsumerStatefulWidget {
  const PlannerDashboardScreen({super.key});

  @override
  ConsumerState<PlannerDashboardScreen> createState() => _PlannerDashboardScreenState();
}

class _PlannerDashboardScreenState extends ConsumerState<PlannerDashboardScreen> {
  int _selectedTabIndex = 0; // 0 for Timeline, 1 for Calendar View

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(plannerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Student Planner', style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.search_normal, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Iconsax.add, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(data)),
          SliverToBoxAdapter(child: _buildAIRecommendations(data.aiRecommendations)),
          SliverToBoxAdapter(child: _buildTabs()),
          if (_selectedTabIndex == 0) SliverToBoxAdapter(child: _buildTimeline(data)),
          if (_selectedTabIndex == 1) SliverToBoxAdapter(child: _buildCalendarView(data)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)), // padding for bottom nav
        ],
      ),
    );
  }

  Widget _buildHeader(PlannerDashboardData data) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(data.pendingTasks.toString(), 'Pending', AppColors.warning),
              _buildStatItem(data.completedTasks.toString(), 'Completed', AppColors.success),
              _buildStatItem(data.upcomingDeadlines.length.toString(), 'Deadlines', AppColors.error),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('AI Priority Score: ', style: AppTypography.label),
              Text('${data.aiPriorityScore}/100', style: AppTypography.label.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: AppTypography.headline.copyWith(color: color, fontSize: 24)),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildAIRecommendations(List<AIPlannerRecommendation> recommendations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Icon(Iconsax.magic_star, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('Smart Recommendations', style: AppTypography.title),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.aiGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                          child: Text(rec.priority, style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        Text(rec.estimatedEffort, style: AppTypography.caption.copyWith(color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(child: Text(rec.suggestion, style: AppTypography.label.copyWith(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 2)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildTabItem(0, 'Timeline'),
            _buildTabItem(1, 'Calendar'),
          ],
        ),
      ),
    ).animate().fade(delay: 200.ms);
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
          ),
          child: Center(
            child: Text(title, style: AppTypography.label.copyWith(color: isSelected ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(PlannerDashboardData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Agenda', style: AppTypography.title),
          const SizedBox(height: 16),
          if (data.todayAgenda.isEmpty)
            Text('No events today.', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ...data.todayAgenda.map((e) => _buildEventCard(e)),
          const SizedBox(height: 24),
          Text('Upcoming Deadlines', style: AppTypography.title),
          const SizedBox(height: 16),
          ...data.upcomingDeadlines.map((e) => _buildEventCard(e)),
        ],
      ),
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildCalendarView(PlannerDashboardData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Iconsax.arrow_left_2, size: 20),
                    Text(DateFormat('MMMM yyyy').format(DateTime.now()), style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
                    const Icon(Iconsax.arrow_right_3, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                // Mock calendar grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 31,
                  itemBuilder: (context, index) {
                    final isToday = index + 1 == DateTime.now().day;
                    final hasEvent = data.allEvents.any((e) => e.date.day == index + 1);
                    return Container(
                      decoration: BoxDecoration(
                        color: isToday ? AppColors.primary : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${index + 1}',
                              style: AppTypography.caption.copyWith(color: isToday ? Colors.white : AppColors.textPrimary, fontWeight: isToday ? FontWeight.bold : FontWeight.normal),
                            ),
                            if (hasEvent && !isToday)
                              Container(margin: const EdgeInsets.only(top: 2), width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('All Events', style: AppTypography.title),
          const SizedBox(height: 16),
          ...data.allEvents.map((e) => _buildEventCard(e)),
        ],
      ),
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildEventCard(PlannerEvent event) {
    Color getEventColor() {
      switch (event.type) {
        case EventType.application: return AppColors.primary;
        case EventType.interview: return AppColors.secondary;
        case EventType.scholarship: return AppColors.success;
        case EventType.resume: return AppColors.warning;
        case EventType.sop: return Colors.purple;
        case EventType.document: return Colors.orange;
        default: return AppColors.textSecondary;
      }
    }

    return GestureDetector(
      onTap: () => ref.read(plannerProvider.notifier).toggleTaskCompletion(event.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: event.isCompleted ? Colors.grey.shade200 : getEventColor().withOpacity(0.3)),
          boxShadow: event.isCompleted ? [] : [BoxShadow(color: getEventColor().withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: event.isCompleted ? AppColors.success : Colors.transparent,
                border: Border.all(color: event.isCompleted ? AppColors.success : Colors.grey.shade400),
              ),
              child: event.isCompleted ? const Icon(Iconsax.tick_circle, color: Colors.white, size: 16) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppTypography.label.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: event.isCompleted ? TextDecoration.lineThrough : null,
                      color: event.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(event.description, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(DateFormat('MMM d').format(event.date), style: AppTypography.label.copyWith(color: getEventColor(), fontWeight: FontWeight.bold)),
                if (event.type == EventType.application || event.type == EventType.scholarship)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                    child: Text('Deadline', style: AppTypography.caption.copyWith(color: AppColors.error, fontSize: 10)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
