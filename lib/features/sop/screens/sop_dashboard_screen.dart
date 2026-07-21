import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/sop_provider.dart';
import '../models/sop_model.dart';

class SopDashboardScreen extends ConsumerStatefulWidget {
  const SopDashboardScreen({super.key});

  @override
  ConsumerState<SopDashboardScreen> createState() => _SopDashboardScreenState();
}

class _SopDashboardScreenState extends ConsumerState<SopDashboardScreen> {
  final Map<String, bool> _expandedSections = {};

  @override
  Widget build(BuildContext context) {
    final sop = ref.watch(sopProvider);

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
            Text('SOP Workspace', style: AppTypography.title.copyWith(fontSize: 16)),
            Text(sop.universityName, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.eye, color: AppColors.primary),
            onPressed: () => context.push('/sop/preview'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            _buildStatsHeader(sop),
            _buildMetricsBar(sop),
            _buildEditorSections(sop),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader(UserSop sop) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircularScore('Completion', sop.completionPercentage, color: AppColors.success),
              _buildCircularScore('AI Score', sop.aiSopScore / 100.0, color: AppColors.primary),
              _buildCircularScore('Grammar', sop.review.grammar / 100.0, color: AppColors.secondary),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/sop/review'),
              icon: const Icon(Iconsax.magic_star, color: Colors.white, size: 20),
              label: const Text('Improve with AI Coach'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildCircularScore(String label, double value, {Color color = AppColors.success}) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                backgroundColor: Colors.grey.shade200,
                color: color,
                strokeWidth: 6,
              ),
              Center(
                child: Text(
                  '${(value * 100).toInt()}%',
                  style: AppTypography.label.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildMetricsBar(UserSop sop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetricItem('${sop.wordCount}', 'Words'),
            _buildMetricItem('${sop.paragraphCount}', 'Paragraphs'),
            _buildMetricItem('${sop.estimatedReadingTimeMinutes}m', 'Reading Time'),
          ],
        ),
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildMetricItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
      ],
    );
  }

  Widget _buildEditorSections(UserSop sop) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Editor Workspace', style: AppTypography.title),
              Text('Drafting ${sop.universityName}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          ...sop.sections.map((section) => _buildSectionEditor(section)),
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildSectionEditor(SopSection section) {
    final isExpanded = _expandedSections[section.title] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              section.isCompleted ? Iconsax.tick_circle : Iconsax.edit_2,
              color: section.isCompleted ? AppColors.success : AppColors.textSecondary,
            ),
            title: Text(section.title, style: AppTypography.label.copyWith(fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal)),
            trailing: Icon(isExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1, size: 16, color: AppColors.textSecondary),
            onTap: () {
              setState(() {
                _expandedSections[section.title] = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextFormField(
                initialValue: section.content,
                maxLines: null,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: 'Start writing your ${section.title.toLowerCase()}...',
                  hintStyle: AppTypography.body.copyWith(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                style: AppTypography.body,
              ),
            ),
        ],
      ),
    );
  }
}
