import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../universities/widgets/filter_chip.dart';
import '../providers/scholarships_provider.dart';
import '../models/scholarship_model.dart';

class ScholarshipsHubScreen extends ConsumerStatefulWidget {
  const ScholarshipsHubScreen({super.key});

  @override
  ConsumerState<ScholarshipsHubScreen> createState() => _ScholarshipsHubScreenState();
}

class _ScholarshipsHubScreenState extends ConsumerState<ScholarshipsHubScreen> {
  final List<String> _filters = ['All', 'Full Tuition', 'Partial', 'STEM', 'Merit-Based'];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(scholarshipsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Scholarship Hub', style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.heart, color: AppColors.primary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Iconsax.copy, color: AppColors.textPrimary),
            onPressed: () => context.push('/scholarships/compare'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsHeader(data),
            _buildSearchBar(),
            _buildFilters(),
            _buildFundingAdvisor(data.fundingRecommendations),
            _buildScholarshipsList(data.scholarships),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader(ScholarshipDashboardData data) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
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
              const Icon(Iconsax.wallet_money, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text('Estimated Funding', style: AppTypography.title.copyWith(color: Colors.white)),
            ],
          ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 2.seconds),
          const SizedBox(height: 8),
          Text(data.estimatedFunding, style: AppTypography.headline.copyWith(fontSize: 36, color: Colors.white)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('${data.savedCount}', 'Saved'),
              _buildStatItem('${data.appliedCount}', 'Applied'),
              _buildStatItem('${data.upcomingDeadlines}', 'Deadlines'),
              _buildStatItem('${data.totalAvailable}', 'Matches'),
            ],
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTypography.title.copyWith(color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.caption.copyWith(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.search_normal, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search scholarships...',
                style: AppTypography.body.copyWith(color: AppColors.textSecondary, fontSize: 14),
              ),
            ),
            const Icon(Iconsax.filter, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            final filter = _filters[index];
            return AppFilterChip(
              label: filter,
              isSelected: _selectedFilter == filter,
              onTap: () => setState(() => _selectedFilter = filter),
            );
          },
        ),
      ),
    ).animate().fade(delay: 200.ms).slideX();
  }

  Widget _buildFundingAdvisor(List<AIFundingRecommendation> recommendations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('AI Funding Advisor', style: AppTypography.title),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final rec = recommendations[index];
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: Text(rec.type, style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 10)),
                          ),
                          Text(rec.estimatedSavings, style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(rec.scholarshipName, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Expanded(child: Text(rec.reasoning, style: AppTypography.caption.copyWith(color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildScholarshipsList(List<Scholarship> scholarships) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Available Opportunities', style: AppTypography.title),
          const SizedBox(height: 16),
          ...scholarships.map((s) => _buildScholarshipCard(s)),
        ],
      ),
    ).animate().fade(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildScholarshipCard(Scholarship s) {
    return GestureDetector(
      onTap: () => context.push('/scholarship/${s.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Iconsax.bank, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(s.organization, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(s.isSaved ? Iconsax.heart5 : Iconsax.heart, color: s.isSaved ? AppColors.error : AppColors.textSecondary),
                  onPressed: () {
                    ref.read(scholarshipsProvider.notifier).toggleSaveStatus(s.id);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(s.fundingAmount, style: AppTypography.label.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI Match', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text('${s.aiMatchScore}%', style: AppTypography.label.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Deadline', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(s.deadline, style: AppTypography.label),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
