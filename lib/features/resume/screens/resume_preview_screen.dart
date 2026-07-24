import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../providers/resume_provider.dart';
import '../models/resume_model.dart';

class ResumePreviewScreen extends ConsumerWidget {
  const ResumePreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(resumeProvider);
    final pdfService = ref.watch(resumePdfServiceProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final file = await pdfService.savePdfFile(resume);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Saved ATS-friendly PDF to ${file.path}'),
                  backgroundColor: AppColors.success),
            );
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.document_download, color: Colors.white),
        label: Text('Export ATS PDF',
            style: AppTypography.labelLarge.copyWith(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref, resume, pdfService, isDark),
            _buildTemplateSelector(context, ref, resume, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: _buildA4Preview(context, resume, isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, UserResume resume,
      dynamic pdfService, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Row(
        children: [
          AppIconButton(
            icon: Iconsax.arrow_left_2,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: AppSpacing.p16),
          Expanded(
            child: Text(
              'Resume Preview',
              style: AppTypography.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppIconButton(
            icon: Iconsax.share,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () => pdfService.shareResumePdf(resume),
          ),
          const SizedBox(width: AppSpacing.p12),
          AppIconButton(
            icon: Iconsax.printer,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () => pdfService.printOrExportPdf(resume),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateSelector(
      BuildContext context, WidgetRef ref, UserResume resume, bool isDark) {
    final templates = ['Modern', 'Executive', 'Academic', 'Minimal'];

    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: AppSpacing.p16),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
        scrollDirection: Axis.horizontal,
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final t = templates[index];
          final isSelected = resume.template == t;
          return GestureDetector(
            onTap: () => ref.read(resumeProvider.notifier).setTemplate(t),
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.p12),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.p20, vertical: AppSpacing.p12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkSurface : AppColors.surface),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.darkBorder : AppColors.border)
                            .withOpacity(0.5)),
              ),
              child: Center(
                child: Text(
                  t,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildA4Preview(BuildContext context, UserResume resume, bool isDark) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 800),
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.p24, vertical: AppSpacing.p16),
        padding: const EdgeInsets.all(AppSpacing.p32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 15)),
          ],
          border: Border.all(
              color: (isDark ? AppColors.darkBorder : AppColors.border)
                  .withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resume.fullName.isNotEmpty ? resume.fullName : 'Alex Morgan',
              style: AppTypography.display
                  .copyWith(color: AppColors.primary, fontSize: 32),
            ),
            const SizedBox(height: AppSpacing.p8),
            Text(
              '${resume.email} • ${resume.phone} • ${resume.location}',
              style: AppTypography.labelMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.p24),
            Divider(
                height: 1,
                color: isDark ? AppColors.darkBorder : AppColors.border),
            const SizedBox(height: AppSpacing.p24),
            if (resume.summary.isNotEmpty) ...[
              _sectionTitle('SUMMARY'),
              Text(resume.summary,
                  style: AppTypography.bodyMedium.copyWith(
                      height: 1.6,
                      color: isDark ? Colors.grey.shade300 : Colors.black87)),
              const SizedBox(height: AppSpacing.p24),
            ],
            if (resume.education.isNotEmpty) ...[
              _sectionTitle('EDUCATION'),
              ...resume.education.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.p8),
                    child: Text('• $e',
                        style: AppTypography.bodyMedium.copyWith(
                            color: isDark
                                ? Colors.grey.shade300
                                : Colors.black87)),
                  )),
              const SizedBox(height: AppSpacing.p24),
            ],
            if (resume.experience.isNotEmpty) ...[
              _sectionTitle('EXPERIENCE'),
              ...resume.experience.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.p8),
                    child: Text('• $e',
                        style: AppTypography.bodyMedium.copyWith(
                            color: isDark
                                ? Colors.grey.shade300
                                : Colors.black87)),
                  )),
              const SizedBox(height: AppSpacing.p24),
            ],
            if (resume.skills.isNotEmpty) ...[
              _sectionTitle('SKILLS'),
              Text(resume.skills.join(' • '),
                  style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? Colors.grey.shade300 : Colors.black87)),
              const SizedBox(height: AppSpacing.p24),
            ],
            if (resume.projects.isNotEmpty) ...[
              _sectionTitle('PROJECTS'),
              ...resume.projects.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.p8),
                    child: Text('• $p',
                        style: AppTypography.bodyMedium.copyWith(
                            color: isDark
                                ? Colors.grey.shade300
                                : Colors.black87)),
                  )),
            ],
          ],
        ),
      ).animate().fade().scale(),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.p12),
      child: Text(
        title,
        style: AppTypography.titleMedium
            .copyWith(letterSpacing: 1.2, color: AppColors.primary),
      ),
    );
  }
}
