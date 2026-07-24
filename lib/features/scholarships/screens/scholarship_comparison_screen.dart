import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/scholarships_provider.dart';
import '../models/scholarship_model.dart';

class ScholarshipComparisonScreen extends ConsumerWidget {
  const ScholarshipComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(scholarshipsProvider);
    final savedScholarships =
        data.scholarships.where((s) => s.isSaved).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Compare Scholarships',
            style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
      ),
      body: savedScholarships.length < 2
          ? Center(
              child: Text('Save at least 2 scholarships to compare.',
                  style: AppTypography.body))
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: savedScholarships
                      .map((s) => _buildComparisonCard(s))
                      .toList(),
                ),
              ),
            ),
    );
  }

  Widget _buildComparisonCard(Scholarship s) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(s),
          _buildMetricRow('AI Match', '${s.aiMatchScore}%', AppColors.success),
          _buildMetricRow('Amount', s.fundingAmount, AppColors.primary),
          _buildMetricRow('Coverage', s.coverage, AppColors.textPrimary),
          _buildMetricRow('Deadline', s.deadline, AppColors.warning),
          _buildMetricRow('Difficulty', s.difficulty, AppColors.error),
          _buildMetricRow(
              'Probability',
              '${s.eligibilityAnalysis.successProbability}%',
              AppColors.secondary),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Covered Expenses',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          ...s.coveredExpenses.map((e) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Iconsax.tick_circle,
                        color: AppColors.success, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e, style: AppTypography.caption)),
                  ],
                ),
              )),
          const SizedBox(height: 24),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildHeader(Scholarship s) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Iconsax.bank, color: AppColors.primary)),
          const SizedBox(height: 12),
          Text(s.name,
              style: AppTypography.label.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(s.organization,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary)),
          Text(value,
              style: AppTypography.label
                  .copyWith(color: valueColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
