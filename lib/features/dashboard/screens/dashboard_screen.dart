import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../shared/models/dashboard_data.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(user),
              const SizedBox(height: 24),
              _buildHeroAICard(),
              const SizedBox(height: 32),
              _buildQuickActions(),
              const SizedBox(height: 32),
              _buildStatistics(ref),
              const SizedBox(height: 32),
              _buildAdmissionProgress(),
              const SizedBox(height: 32),
              _buildDeadlines(ref),
              const SizedBox(height: 32),
              _buildRecentApplications(ref),
              const SizedBox(height: 32),
              _buildAIInsights(),
              const SizedBox(height: 100), // padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Evening,',
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            ),
            Row(
              children: [
                Text(
                  user.name,
                  style: AppTypography.title.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('👋', style: TextStyle(fontSize: 24)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Let's make your dream university a reality!",
              style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(Iconsax.notification, size: 24),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1.seconds),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroAICard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'EDUIng AI',
                style: AppTypography.label.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Your admission\nprobability is',
            style: AppTypography.title.copyWith(color: Colors.white, height: 1.2),
          ),
          const SizedBox(height: 12),
          Text(
            '91%',
            style: AppTypography.display.copyWith(color: Colors.white),
          ).animate().shimmer(duration: 2.seconds, delay: 1.seconds, color: Colors.white54),
        ],
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 2.seconds);
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionCard('Applications', '18 Active', Iconsax.document),
        _buildActionCard('Universities', '24 Shortlisted', Iconsax.building),
        _buildActionCard('Documents', '10 Uploaded', Iconsax.folder),
        _buildActionCard('Planner', '5 Tasks', Iconsax.calendar),
      ],
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Icon(icon, color: AppColors.primary),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics(WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard('Applications', stats.applications.toString(), '+10.2%'),
          _buildStatCard('Offers Received', stats.offersReceived.toString(), '+2 New'),
          _buildStatCard('Profile Strength', '${stats.profileStrength}%', '+8.55%'),
          _buildStatCard('Scholarships', stats.scholarships.toString(), '+1 New'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String trend) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.title.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 8),
          Text(
            trend,
            style: AppTypography.caption.copyWith(color: AppColors.success),
          ),
        ],
      ),
    );
  }

  Widget _buildAdmissionProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Admission Progress', style: AppTypography.title.copyWith(fontSize: 20)),
        const SizedBox(height: 16),
        Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 300,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const titles = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                      if (value.toInt() >= 0 && value.toInt() < titles.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(titles[value.toInt()], style: AppTypography.caption),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 150, color: AppColors.primary, width: 20, borderRadius: BorderRadius.circular(4))]),
                BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 120, color: AppColors.primary, width: 20, borderRadius: BorderRadius.circular(4))]),
                BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 200, color: AppColors.primary, width: 20, borderRadius: BorderRadius.circular(4))]),
                BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 180, color: AppColors.primary, width: 20, borderRadius: BorderRadius.circular(4))]),
                BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 250, color: AppColors.primaryDark, width: 20, borderRadius: BorderRadius.circular(4))]),
                BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 140, color: AppColors.primary, width: 20, borderRadius: BorderRadius.circular(4))]),
              ],
            ),
          ),
        ),
      ],
    ).animate().fade(duration: 500.ms).slideY(begin: 0.1, curve: Curves.easeOutQuad);
  }

  Widget _buildDeadlines(WidgetRef ref) {
    final deadlines = ref.watch(upcomingDeadlinesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Upcoming Deadlines', style: AppTypography.title.copyWith(fontSize: 20)),
            Text('View all', style: AppTypography.button.copyWith(color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            children: deadlines.map((d) => _buildDeadlineItem(d)).toList(),
          ),
        ),
      ],
    ).animate().fade(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildDeadlineItem(Deadline deadline) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deadline.date, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                Text(deadline.task, style: AppTypography.label),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(deadline.priority, style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentApplications(WidgetRef ref) {
    final applications = ref.watch(recentApplicationsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Applications', style: AppTypography.title.copyWith(fontSize: 20)),
            Text('View all', style: AppTypography.button.copyWith(color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 16),
        ...applications.map((app) => _buildApplicationCard(app)),
      ],
    ).animate().fade(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildApplicationCard(ApplicationStatus app) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(app.logoUrl), radius: 24, backgroundColor: Colors.transparent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.university, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
                Text(app.campus, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${app.aiMatch}%', style: AppTypography.title.copyWith(color: AppColors.primary, fontSize: 16)),
              Text(app.status, style: AppTypography.caption.copyWith(color: AppColors.success)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsights() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(gradient: AppColors.aiGradient, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Iconsax.magic_star, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('AI Insight', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text('Beta', style: AppTypography.caption.copyWith(color: AppColors.primary, fontSize: 10)),
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true)).fade(begin: 0.5, end: 1.0, duration: 1.seconds),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Improve your SOP to increase your admission probability by 6%', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 500.ms, delay: 300.ms).slideY(begin: 0.1);
  }
}
