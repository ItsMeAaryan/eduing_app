import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../shared/models/university_model.dart';
import '../providers/universities_provider.dart';
import '../../applications/providers/applications_provider.dart';
import 'package:go_router/go_router.dart';

class CompareUniversitiesScreen extends ConsumerWidget {
  final List<String> universityIds;

  const CompareUniversitiesScreen({super.key, required this.universityIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUniversities = ref.watch(universitiesProvider);
    final universitiesToCompare = allUniversities.where((u) => universityIds.contains(u.id)).toList();
    
    // Fallback if empty
    final displayUniversities = universitiesToCompare.isEmpty ? allUniversities.take(2).toList() : universitiesToCompare;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text('Compare Universities', style: AppTypography.title.copyWith(fontSize: 16)),
            Text('AI-powered side-by-side comparison', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.document_download, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Iconsax.share, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCounterHeader(displayUniversities.length),
                _buildUniversitiesHeader(displayUniversities),
                _buildAIWinnerCard(displayUniversities),
                _buildComparisonTable(displayUniversities),
                _buildCharts(displayUniversities),
                _buildAIAnalysisCards(),
              ],
            ),
          ),
          _buildBottomActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildCounterHeader(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Comparing', style: AppTypography.title),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '$count / 4 Selected',
              style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ).animate().fade().slideX();
  }

  Widget _buildUniversitiesHeader(List<University> universities) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: universities.map((u) => _buildUniversityColumnHeader(u)).toList(),
      ),
    ).animate().fade(delay: 100.ms).slideX();
  }

  Widget _buildUniversityColumnHeader(University university) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  university.imageUrl,
                  height: 100,
                  width: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 100, width: 160, color: Colors.grey.shade300),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Iconsax.close_circle, size: 16, color: AppColors.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(university.logoUrl),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(university.name, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(university.location, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10), maxLines: 1),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('AI Match ${university.aiMatch}%', style: AppTypography.caption.copyWith(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildAIWinnerCard(List<University> universities) {
    if (universities.isEmpty) return const SizedBox.shrink();
    final winner = universities.reduce((a, b) => a.aiMatch > b.aiMatch ? a : b);

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
              const Icon(Iconsax.magic_star, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text('AI Winner', style: AppTypography.title.copyWith(color: Colors.white)),
            ],
          ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 2.seconds),
          const SizedBox(height: 16),
          Text(
            'Based on your academic profile, ${winner.name} provides the highest placement ROI and admission probability.',
            style: AppTypography.body.copyWith(color: Colors.white, height: 1.5),
          ),
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildComparisonTable(List<University> universities) {
    if (universities.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Comparison', style: AppTypography.title),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildTableRow('NIRF Ranking', universities.map((u) => u.nirfRanking).toList()),
                _buildTableRow('AI Match', universities.map((u) => '${u.aiMatch}%').toList()),
                _buildTableRow('Fees', universities.map((u) => u.fees).toList()),
                _buildTableRow('Placement %', universities.map((u) => '${u.placementScore.toInt()}%').toList()),
                _buildTableRow('ROI Score', universities.map((u) => '${u.roiScore.toInt()}/100').toList()),
                _buildTableRow('Accreditation', universities.map((u) => u.accreditation).toList()),
                _buildTableRow('Type', universities.map((u) => u.type).toList(), isLast: true),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildTableRow(String title, List<String> values, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(title, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ),
          ...values.map((value) => Expanded(
                flex: 2,
                child: Text(value, style: AppTypography.label, textAlign: TextAlign.center),
              )),
        ],
      ),
    );
  }

  Widget _buildCharts(List<University> universities) {
    if (universities.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Metrics', style: AppTypography.title),
          const SizedBox(height: 16),
          Container(
            height: 250,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: const FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: universities.asMap().entries.map((entry) {
                  final index = entry.key;
                  final uni = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: uni.placementScore,
                        color: AppColors.primary,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      BarChartRodData(
                        toY: uni.researchScore,
                        color: AppColors.secondary,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChartLegend(AppColors.primary, 'Placements'),
              const SizedBox(width: 24),
              _buildChartLegend(AppColors.secondary, 'Research'),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildChartLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 8),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  Widget _buildAIAnalysisCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Analysis', style: AppTypography.title),
          const SizedBox(height: 16),
          _buildExpandableCard('Career ROI', 'BITS Pilani leads in ROI due to strong industry ties, but VIT offers aggressive startup support.'),
          _buildExpandableCard('Placement Prediction', 'IIT Bombay has the highest predicted placement for your preferred major.'),
        ],
      ),
    ).animate().fade(delay: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildExpandableCard(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(title, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, WidgetRef ref) {
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
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Save', style: AppTypography.button.copyWith(color: AppColors.textPrimary)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    for (var id in universityIds) {
                      ref.read(applicationsProvider.notifier).addMockApplication(id);
                    }
                    context.go('/applications');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Apply to Selected', style: AppTypography.button.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
