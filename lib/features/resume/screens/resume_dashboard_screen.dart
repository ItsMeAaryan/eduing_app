import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/resume_provider.dart';
import '../models/resume_model.dart';

class ResumeDashboardScreen extends ConsumerStatefulWidget {
  const ResumeDashboardScreen({super.key});

  @override
  ConsumerState<ResumeDashboardScreen> createState() => _ResumeDashboardScreenState();
}

class _ResumeDashboardScreenState extends ConsumerState<ResumeDashboardScreen> {
  void _showEditPersonalDialog(UserResume resume) {
    final nameCtrl = TextEditingController(text: resume.fullName);
    final emailCtrl = TextEditingController(text: resume.email);
    final phoneCtrl = TextEditingController(text: resume.phone);
    final locationCtrl = TextEditingController(text: resume.location);
    final summaryCtrl = TextEditingController(text: resume.summary);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Edit Personal Details & Summary', style: AppTypography.headline),
                const SizedBox(height: 16),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
                const SizedBox(height: 12),
                TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email Address')),
                const SizedBox(height: 12),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number')),
                const SizedBox(height: 12),
                TextField(controller: locationCtrl, decoration: const InputDecoration(labelText: 'Location')),
                const SizedBox(height: 12),
                TextField(controller: summaryCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Summary Statement')),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(resumeProvider.notifier).updatePersonalInfo(
                          fullName: nameCtrl.text,
                          email: emailCtrl.text,
                          phone: phoneCtrl.text,
                          location: locationCtrl.text,
                          summary: summaryCtrl.text,
                        );
                    ctx.pop();
                  },
                  child: const Text('Save Details'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final resume = ref.watch(resumeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Resume Builder'),
            Text('Last updated ${resume.lastUpdated}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
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
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularScore('Completion', resume.completionPercentage),
              _buildCircularScore('ATS Score', resume.atsReadiness / 100.0),
              _buildCircularScore('AI Score', resume.aiResumeScore / 100.0, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analyzing resume with AI...')),
                );
                await ref.read(resumeProvider.notifier).runAIReview();
                if (mounted) {
                  context.push('/resume/review');
                }
              },
              icon: const Icon(Iconsax.magic_star, color: Colors.white, size: 20),
              label: const Text('Review with AI & Generate Score'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.05);
  }

  Widget _buildCircularScore(String label, double value, {Color color = AppColors.success}) {
    return Column(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 6,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(color),
              ),
              Center(
                child: Text(
                  '${(value * 100).toInt()}%',
                  style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  Widget _buildEditorSections(UserResume resume) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resume Sections', style: AppTypography.subheading),
          const SizedBox(height: 12),
          _buildSectionTile(
            title: 'Personal Info & Summary',
            subtitle: '${resume.fullName} • ${resume.email}',
            icon: Iconsax.user,
            isDone: resume.fullName.isNotEmpty,
            onTap: () => _showEditPersonalDialog(resume),
          ),
          _buildSectionTile(
            title: 'Education',
            subtitle: '${resume.education.length} entries added',
            icon: Iconsax.teacher,
            isDone: resume.education.isNotEmpty,
            onTap: () => context.push('/resume/preview'),
          ),
          _buildSectionTile(
            title: 'Work & Research Experience',
            subtitle: '${resume.experience.length} entries added',
            icon: Iconsax.briefcase,
            isDone: resume.experience.isNotEmpty,
            onTap: () => context.push('/resume/preview'),
          ),
          _buildSectionTile(
            title: 'Skills & Competencies',
            subtitle: '${resume.skills.length} skills listed',
            icon: Iconsax.code,
            isDone: resume.skills.isNotEmpty,
            onTap: () => context.push('/resume/preview'),
          ),
          _buildSectionTile(
            title: 'Projects & Publications',
            subtitle: '${resume.projects.length} projects listed',
            icon: Iconsax.folder_open,
            isDone: resume.projects.isNotEmpty,
            onTap: () => context.push('/resume/preview'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDone,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: AppTypography.caption),
        trailing: Icon(
          isDone ? Iconsax.tick_circle : Iconsax.arrow_right_3,
          color: isDone ? AppColors.success : AppColors.textSecondary,
        ),
      ),
    );
  }
}
