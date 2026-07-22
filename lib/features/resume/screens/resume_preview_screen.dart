import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/resume_provider.dart';
import '../models/resume_model.dart';

class ResumePreviewScreen extends ConsumerWidget {
  const ResumePreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(resumeProvider);
    final pdfService = ref.watch(resumePdfServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${resume.template} Template Preview', style: AppTypography.title.copyWith(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.share, color: AppColors.primary),
            onPressed: () async {
              await pdfService.shareResumePdf(resume);
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.printer, color: AppColors.primary),
            onPressed: () async {
              await pdfService.printOrExportPdf(resume);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTemplateSelector(context, ref, resume),
            _buildA4Preview(context, resume),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final file = await pdfService.savePdfFile(resume);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Saved ATS-friendly PDF to ${file.path}')),
            );
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.document_download, color: Colors.white),
        label: Text('Export ATS PDF', style: AppTypography.button.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildTemplateSelector(BuildContext context, WidgetRef ref, UserResume resume) {
    final templates = ['Modern', 'Executive', 'Academic', 'Minimal'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final t = templates[index];
            final isSelected = resume.template == t;
            return GestureDetector(
              onTap: () {
                ref.read(resumeProvider.notifier).setTemplate(t);
              },
              child: Container(
                width: 90,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withOpacity(0.12) : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Theme.of(context).dividerColor.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.document_text, color: isSelected ? AppColors.primary : Colors.grey, size: 22),
                    const SizedBox(height: 4),
                    Text(
                      t,
                      style: AppTypography.caption.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primary : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildA4Preview(BuildContext context, UserResume resume) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resume.fullName.isNotEmpty ? resume.fullName : 'Alex Morgan',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 4),
          Text(
            '${resume.email} • ${resume.phone} • ${resume.location}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
          const Divider(height: 24, thickness: 1.5),

          if (resume.summary.isNotEmpty) ...[
            _sectionTitle('SUMMARY'),
            Text(resume.summary, style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.black87)),
            const SizedBox(height: 16),
          ],

          if (resume.education.isNotEmpty) ...[
            _sectionTitle('EDUCATION'),
            ...resume.education.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $e', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                )),
            const SizedBox(height: 16),
          ],

          if (resume.experience.isNotEmpty) ...[
            _sectionTitle('EXPERIENCE'),
            ...resume.experience.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $e', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                )),
            const SizedBox(height: 16),
          ],

          if (resume.skills.isNotEmpty) ...[
            _sectionTitle('SKILLS'),
            Text(resume.skills.join(' • '), style: const TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 16),
          ],

          if (resume.projects.isNotEmpty) ...[
            _sectionTitle('PROJECTS'),
            ...resume.projects.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $p', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                )),
          ],
        ],
      ),
    ).animate().fade().scale();
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.indigo),
      ),
    );
  }
}
