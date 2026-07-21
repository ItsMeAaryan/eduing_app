import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/profile_provider.dart';
import '../models/profile_model.dart';

class ProfileDashboardScreen extends ConsumerStatefulWidget {
  const ProfileDashboardScreen({super.key});

  @override
  ConsumerState<ProfileDashboardScreen> createState() => _ProfileDashboardScreenState();
}

class _ProfileDashboardScreenState extends ConsumerState<ProfileDashboardScreen> {
  int _selectedTabIndex = 0; // 0 for Academic, 1 for Preferences, 2 for Achievements

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text('Student Profile', style: AppTypography.title.copyWith(color: Colors.white, fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Iconsax.setting_2, color: Colors.white),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHero(data)),
          SliverToBoxAdapter(child: _buildApplicationSummary(data)),
          SliverToBoxAdapter(child: _buildAIInsights(data)),
          SliverToBoxAdapter(child: _buildTabs()),
          if (_selectedTabIndex == 0) SliverToBoxAdapter(child: _buildAcademicPortfolio(data)),
          if (_selectedTabIndex == 1) SliverToBoxAdapter(child: _buildPreferences(data)),
          if (_selectedTabIndex == 2) SliverToBoxAdapter(child: _buildAchievements(data)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom nav padding
        ],
      ),
    );
  }

  Widget _buildHero(ProfileData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32, top: 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 46,
              backgroundImage: NetworkImage(data.photoUrl),
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Text(data.name, style: AppTypography.headline.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text('${data.educationLevel} • ${data.targetDegree}', style: AppTypography.body.copyWith(color: Colors.white70)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeroStat('Completion', '${data.profileCompletionPercentage}%', Iconsax.profile_circle),
              Container(width: 1, height: 40, color: Colors.white24),
              _buildHeroStat('Readiness', '${data.aiReadinessScore}%', Iconsax.magic_star),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(value, style: AppTypography.title.copyWith(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.caption.copyWith(color: Colors.white70)),
      ],
    );
  }

  Widget _buildApplicationSummary(ProfileData data) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Application Summary', style: AppTypography.title),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryCard('Apps Submitted', data.applicationsSubmitted.toString(), Iconsax.document_upload, AppColors.primary),
              const SizedBox(width: 12),
              _buildSummaryCard('Saved Aid', data.scholarshipsSaved.toString(), Iconsax.wallet_money, AppColors.success),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSummaryCard('Resume Score', '${data.resumeScore}%', Iconsax.document_text, AppColors.secondary),
              const SizedBox(width: 12),
              _buildSummaryCard('Interview Score', '${data.interviewScore}%', Iconsax.video, AppColors.warning),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 12),
            Text(value, style: AppTypography.headline.copyWith(fontSize: 20)),
            const SizedBox(height: 4),
            Text(title, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsights(ProfileData data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: Colors.white, size: 24).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(),
              const SizedBox(width: 12),
              Text('AI Profile Insights', style: AppTypography.title.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          ...data.aiInsights.map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: CircleAvatar(radius: 4, backgroundColor: Colors.white54),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(insight, style: AppTypography.body.copyWith(color: Colors.white))),
              ],
            ),
          )),
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
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
            _buildTabItem(0, 'Academic'),
            _buildTabItem(1, 'Preferences'),
            _buildTabItem(2, 'Achievements'),
          ],
        ),
      ),
    ).animate().fade(delay: 300.ms);
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
            child: Text(
              title, 
              style: AppTypography.label.copyWith(
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcademicPortfolio(ProfileData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildInfoRow('Current GPA', data.currentGpa, Iconsax.chart_2),
          _buildInfoRow('Test Scores', data.standardizedTests, Iconsax.award),
          _buildInfoRow('Research', data.researchExperience, Iconsax.microscope),
          _buildInfoRow('Projects', data.projects, Iconsax.cpu),
          _buildInfoRow('Skills', data.skills, Iconsax.code),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildPreferences(ProfileData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildInfoRow('Target Countries', data.targetCountries.join(', '), Iconsax.global),
          _buildInfoRow('Budget', data.budget, Iconsax.wallet),
          _buildInfoRow('Aid Preference', data.scholarshipPreference, Iconsax.money_tick),
          _buildInfoRow('Study Mode', data.studyMode, Iconsax.book),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildAchievements(ProfileData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...data.achievements.map((ach) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.success,
                  radius: 16,
                  child: Icon(Iconsax.verify, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(ach, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold))),
              ],
            ),
          )),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(value, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Icon(Iconsax.edit_2, color: AppColors.textSecondary, size: 16),
        ],
      ),
    );
  }
}
