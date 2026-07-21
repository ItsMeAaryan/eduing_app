import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/scholarships_provider.dart';
import '../models/scholarship_model.dart';

class ScholarshipDetailsScreen extends ConsumerWidget {
  final String scholarshipId;

  const ScholarshipDetailsScreen({super.key, required this.scholarshipId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(scholarshipsProvider);
    final scholarship = data.scholarships.firstWhere((s) => s.id == scholarshipId, orElse: () => data.scholarships.first);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, scholarship),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildQuickInfo(scholarship),
                    const SizedBox(height: 32),
                    _buildAIAnalysis(scholarship.eligibilityAnalysis),
                    const SizedBox(height: 32),
                    _buildSection('About', scholarship.description),
                    const SizedBox(height: 24),
                    _buildListSection('Benefits', scholarship.benefits, Iconsax.star),
                    const SizedBox(height: 24),
                    _buildListSection('Covered Expenses', scholarship.coveredExpenses, Iconsax.wallet_money),
                    const SizedBox(height: 32),
                    _buildChecklist(scholarship.requiredDocuments),
                  ]),
                ),
              ),
            ],
          ),
          _buildApplyButton(context),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Scholarship scholarship) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left_2, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppColors.primary),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(8)),
                    child: Text('${scholarship.aiMatchScore}% AI Match', style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(scholarship.name, style: AppTypography.headline.copyWith(color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(scholarship.organization, style: AppTypography.title.copyWith(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfo(Scholarship scholarship) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoItem(Iconsax.wallet_money, 'Amount', scholarship.fundingAmount),
        _buildInfoItem(Iconsax.global, 'Country', scholarship.country),
        _buildInfoItem(Iconsax.calendar, 'Deadline', scholarship.deadline),
      ],
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(value, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildAIAnalysis(AIEligibilityAnalysis analysis) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Text('AI Eligibility Analysis', style: AppTypography.title),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularScore('Eligibility', analysis.eligibilityPercentage, AppColors.success),
              _buildCircularScore('Probability', analysis.successProbability, AppColors.warning),
              _buildCircularScore('Funding', analysis.fundingScore, AppColors.primary),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Text('Strengths', style: AppTypography.label.copyWith(color: AppColors.success)),
          const SizedBox(height: 8),
          ...analysis.strengths.map((s) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [const Icon(Iconsax.tick_circle, size: 16, color: AppColors.success), const SizedBox(width: 8), Text(s, style: AppTypography.caption)]))),
          const SizedBox(height: 16),
          Text('Required Improvements', style: AppTypography.label.copyWith(color: AppColors.error)),
          const SizedBox(height: 8),
          ...analysis.requiredImprovements.map((s) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [const Icon(Iconsax.info_circle, size: 16, color: AppColors.error), const SizedBox(width: 8), Expanded(child: Text(s, style: AppTypography.caption))]))),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildCircularScore(String label, int value, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(value: value / 100.0, backgroundColor: Colors.grey.shade200, color: color, strokeWidth: 6),
              Center(child: Text('$value%', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.title),
        const SizedBox(height: 12),
        Text(content, style: AppTypography.body.copyWith(height: 1.5)),
      ],
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildListSection(String title, List<String> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.title),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item, style: AppTypography.body)),
                ],
              ),
            )),
      ],
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildChecklist(List<String> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Application Checklist', style: AppTypography.title),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: documents.map((doc) => ListTile(
                  leading: const Icon(Iconsax.document, color: AppColors.primary),
                  title: Text(doc, style: AppTypography.label),
                  trailing: const Icon(Iconsax.arrow_right_3, size: 16, color: AppColors.textSecondary),
                )).toList(),
          ),
        ),
      ],
    ).animate().fade(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildApplyButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -10))],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Start Application', style: AppTypography.button.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
