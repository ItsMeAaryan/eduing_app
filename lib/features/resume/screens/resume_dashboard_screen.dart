import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/resume_provider.dart';
import '../models/resume_model.dart';

class ResumeDashboardScreen extends ConsumerWidget {
  const ResumeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(resumeProvider);

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
            Text('Resume Builder', style: AppTypography.title.copyWith(fontSize: 16)),
            Text('Last updated ${resume.lastUpdated}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.eye, color: AppColors.primary),
            onPressed: () => context.push('/resume/preview'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            _buildScoreCard(resume),
            _buildEditorSections(resume),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(UserResume resume) {
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
              _buildCircularScore('Completion', resume.completionPercentage),
              _buildCircularScore('ATS Score', resume.atsReadiness / 100.0),
              _buildCircularScore('AI Score', resume.aiResumeScore / 100.0, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Iconsax.magic_star, color: Colors.white, size: 20),
              label: const Text('Improve with AI'),
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

  Widget _buildEditorSections(UserResume resume) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sections', style: AppTypography.title),
          const SizedBox(height: 16),
          ...resume.sections.map((section) => _buildSectionCard(section)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Iconsax.add, color: AppColors.textPrimary, size: 20),
              label: const Text('Add Custom Section'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildSectionCard(ResumeSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(
          section.isCompleted ? Iconsax.tick_circle : Iconsax.edit_2,
          color: section.isCompleted ? AppColors.success : AppColors.textSecondary,
        ),
        title: Text(section.title, style: AppTypography.label),
        trailing: const Icon(Iconsax.arrow_right_3, size: 16, color: AppColors.textSecondary),
        onTap: () {},
      ),
    );
  }
}
