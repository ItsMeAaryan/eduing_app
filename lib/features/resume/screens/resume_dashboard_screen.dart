import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/molecules/squircle_card.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../../../shared/components/atoms/app_button.dart';
import '../providers/resume_provider.dart';
import '../models/resume_model.dart';

class ResumeDashboardScreen extends ConsumerStatefulWidget {
  const ResumeDashboardScreen({super.key});

  @override
  ConsumerState<ResumeDashboardScreen> createState() =>
      _ResumeDashboardScreenState();
}

class _ResumeDashboardScreenState extends ConsumerState<ResumeDashboardScreen> {
  final Map<String, bool> _expandedSections = {
    'personal': true,
    'education': false,
    'experience': false,
    'projects': false,
    'skills': false,
  };

  void _toggleSection(String key) {
    setState(() {
      _expandedSections[key] = !(_expandedSections[key] ?? false);
    });
  }

  void _showEditPersonalDialog(UserResume resume) {
    final nameCtrl = TextEditingController(text: resume.fullName);
    final emailCtrl = TextEditingController(text: resume.email);
    final phoneCtrl = TextEditingController(text: resume.phone);
    final locationCtrl = TextEditingController(text: resume.location);
    final summaryCtrl = TextEditingController(text: resume.summary);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: EdgeInsets.only(
            left: AppSpacing.p24,
            right: AppSpacing.p24,
            top: AppSpacing.p24,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.p24,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Personal Info & Summary',
                    style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.p24),
                TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Full Name', border: OutlineInputBorder())),
                const SizedBox(height: AppSpacing.p12),
                TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder())),
                const SizedBox(height: AppSpacing.p12),
                TextField(
                    controller: phoneCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder())),
                const SizedBox(height: AppSpacing.p12),
                TextField(
                    controller: locationCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Location', border: OutlineInputBorder())),
                const SizedBox(height: AppSpacing.p12),
                TextField(
                    controller: summaryCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                        labelText: 'Summary Statement',
                        border: OutlineInputBorder())),
                const SizedBox(height: AppSpacing.p24),
                AppButton(
                  text: 'Save Details',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, resume, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  children: [
                    _buildHeroScoreCard(resume, isDark),
                    _buildInteractiveForm(resume, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/resume/preview'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.eye, color: Colors.white),
        label: Text('Preview Resume',
            style: AppTypography.labelLarge.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserResume resume, bool isDark) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resume Builder', style: AppTypography.titleLarge),
                Text('Last updated ${resume.lastUpdated}',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          AppIconButton(
            icon: Iconsax.magic_star,
            isFilled: true,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            color: AppColors.primary,
            onPressed: () async {
              final router = GoRouter.of(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analyzing resume with AI...')));
              await ref.read(resumeProvider.notifier).runAIReview();
              if (mounted) router.push('/resume/review');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeroScoreCard(UserResume resume, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p24, vertical: AppSpacing.p8),
      padding: const EdgeInsets.all(AppSpacing.p32),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('${resume.atsReadiness}',
                  style: AppTypography.display
                      .copyWith(color: Colors.white, fontSize: 64)),
              Text('%',
                  style: AppTypography.headline.copyWith(color: Colors.white)),
            ],
          ),
          Text('ATS Compatibility Score',
              style: AppTypography.labelLarge.copyWith(color: Colors.white70)),
          const SizedBox(height: AppSpacing.p24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMetricBadge('Completion',
                  '${(resume.completionPercentage * 100).toInt()}%'),
              _buildMetricBadge('AI Score', '${resume.aiResumeScore}'),
              _buildMetricBadge('Format', 'Perfect'),
            ],
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.05);
  }

  Widget _buildMetricBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p16, vertical: AppSpacing.p8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value,
              style: AppTypography.titleLarge.copyWith(color: Colors.white)),
          Text(label,
              style: AppTypography.caption.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildInteractiveForm(UserResume resume, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p24, vertical: AppSpacing.p16),
      child: Column(
        children: [
          _buildAccordionSection(
            key: 'personal',
            title: 'Personal Info & Summary',
            subtitle: resume.fullName.isNotEmpty
                ? resume.fullName
                : 'Add your details',
            icon: Iconsax.user,
            isDone: resume.fullName.isNotEmpty,
            onAction: () => _showEditPersonalDialog(resume),
          ),
          _buildAccordionSection(
            key: 'education',
            title: 'Education',
            subtitle: '${resume.education.length} entries added',
            icon: Iconsax.teacher,
            isDone: resume.education.isNotEmpty,
            onAction: () => context.push('/resume/preview'),
          ),
          _buildAccordionSection(
            key: 'experience',
            title: 'Experience',
            subtitle: '${resume.experience.length} entries added',
            icon: Iconsax.briefcase,
            isDone: resume.experience.isNotEmpty,
            onAction: () => context.push('/resume/preview'),
          ),
          _buildAccordionSection(
            key: 'projects',
            title: 'Projects',
            subtitle: '${resume.projects.length} entries added',
            icon: Iconsax.folder_open,
            isDone: resume.projects.isNotEmpty,
            onAction: () => context.push('/resume/preview'),
          ),
          _buildAccordionSection(
            key: 'skills',
            title: 'Skills',
            subtitle: '${resume.skills.length} skills added',
            icon: Iconsax.code,
            isDone: resume.skills.isNotEmpty,
            onAction: () => context.push('/resume/preview'),
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildAccordionSection({
    required String key,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDone,
    required VoidCallback onAction,
  }) {
    final isExpanded = _expandedSections[key] ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.p12),
      child: SquircleCard(
        padding: const EdgeInsets.all(AppSpacing.p8),
        child: Column(
          children: [
            ListTile(
              onTap: () => _toggleSection(key),
              leading: Container(
                padding: const EdgeInsets.all(AppSpacing.p12),
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon,
                    color: isDone ? AppColors.success : AppColors.primary,
                    size: 20),
              ),
              title: Text(title, style: AppTypography.titleMedium),
              subtitle: Text(subtitle,
                  style: AppTypography.labelMedium
                      .copyWith(color: AppColors.textSecondary)),
              trailing: Icon(
                  isExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1,
                  color: AppColors.textSecondary),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    72, 0, AppSpacing.p24, AppSpacing.p16),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: isDone ? 'Edit Section' : 'Add Detail',
                        variant: isDone
                            ? AppButtonVariant.outline
                            : AppButtonVariant.primary,
                        onPressed: onAction,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
