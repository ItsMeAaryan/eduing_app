import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/molecules/squircle_card.dart';
import '../../../shared/components/atoms/status_pill.dart';
import '../../../shared/components/atoms/app_button.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../../../shared/components/atoms/progress_bar.dart';
import '../providers/applications_provider.dart';
import '../models/university_application.dart';

class ApplicationDetailsScreen extends ConsumerStatefulWidget {
  final UniversityApplication? application;
  final String? applicationId;

  const ApplicationDetailsScreen(
      {super.key, this.application, this.applicationId});

  @override
  ConsumerState<ApplicationDetailsScreen> createState() =>
      _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState
    extends ConsumerState<ApplicationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationsNotifierProvider);
    final app = widget.application ??
        (widget.applicationId != null
            ? applications.firstWhere(
                (a) => a.id == widget.applicationId,
                orElse: () => applications.first,
              )
            : (applications.isNotEmpty ? applications.first : null));

    if (app == null) {
      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Iconsax.arrow_left),
                onPressed: () => context.pop())),
        body: const Center(child: Text('Application not found')),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Premium Hero Header
              SliverToBoxAdapter(
                child: _buildHeroHeader(context, app, isDark),
              ),

              // Workspace Content
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.p24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProgressOverview(isDark, app),
                    const SizedBox(height: AppSpacing.p24),
                    _buildRequirementsTile(isDark, app),
                    const SizedBox(height: AppSpacing.p24),
                    _buildTimelineTile(isDark, app),
                    const SizedBox(height: AppSpacing.p24),
                    _buildDocumentsTile(isDark, app),
                    const SizedBox(height: AppSpacing.p24),
                    _buildNotesTile(isDark, app),
                    const SizedBox(height: AppSpacing.p24),
                    _buildActivityTile(isDark, app),
                    const SizedBox(height: 100), // Space for floating actions
                  ]),
                ),
              ),
            ],
          ),

          // Floating Actions Bar
          Positioned(
            bottom: AppSpacing.p24,
            left: AppSpacing.p24,
            right: AppSpacing.p24,
            child: _buildFloatingActions(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(
      BuildContext context, UniversityApplication app, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.p24, 60, AppSpacing.p24, AppSpacing.p40),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconButton(
            icon: Iconsax.arrow_left,
            isFilled: true,
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.background,
            onPressed: () => context.pop(),
          ),
          const SizedBox(height: AppSpacing.p32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(app.university.logoUrl.isNotEmpty
                        ? app.university.logoUrl
                        : 'https://placehold.co/100x100/png'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                      width: 2),
                ),
              ),
              const SizedBox(width: AppSpacing.p20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.university.name,
                      style: AppTypography.display.copyWith(
                          fontWeight: FontWeight.w800, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: AppSpacing.p8),
                    Text(
                      app.course,
                      style: AppTypography.titleMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.p12),
                    StatusPill(type: _mapStatus(app.status)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(bool isDark, UniversityApplication app) {
    return SquircleCard(
      hasShadow: true,
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Overall Progress', style: AppTypography.titleLarge),
              Text('${(app.progress * 100).toInt()}%',
                  style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: AppSpacing.p16),
          ProgressBar(progress: app.progress, color: AppColors.primary),
          const SizedBox(height: AppSpacing.p24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Submission Deadline', style: AppTypography.caption),
                    const SizedBox(height: AppSpacing.p4),
                    Text(app.deadline,
                        style: AppTypography.titleMedium
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                  width: 1,
                  height: 40,
                  color: isDark ? AppColors.darkBorder : AppColors.border),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.p24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Success Rate', style: AppTypography.caption),
                      const SizedBox(height: AppSpacing.p4),
                      Row(
                        children: [
                          const Icon(Iconsax.magic_star,
                              color: AppColors.warning, size: 16),
                          const SizedBox(width: AppSpacing.p4),
                          Text('${app.aiSuccessPrediction}%',
                              style: AppTypography.titleMedium
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildRequirementsTile(bool isDark, UniversityApplication app) {
    return SquircleCard(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Requirements', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p16),
          _buildChecklistItem('IELTS / TOEFL Score', true),
          _buildChecklistItem('Transcripts', true),
          _buildChecklistItem('Statement of Purpose', false),
          _buildChecklistItem('2x Letters of Recommendation', false),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String title, bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.p12),
      child: Row(
        children: [
          Icon(
            isDone ? Iconsax.tick_circle : Iconsax.clock,
            color: isDone ? AppColors.success : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.p12),
          Text(title,
              style: AppTypography.bodyMedium.copyWith(
                  decoration: isDone ? TextDecoration.lineThrough : null)),
        ],
      ),
    );
  }

  Widget _buildTimelineTile(bool isDark, UniversityApplication app) {
    return SquircleCard(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Application Timeline', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p24),
          if (app.timeline.isEmpty)
            Text('No timeline stages created.', style: AppTypography.caption)
          else
            ...app.timeline.map(
              (stage) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.p16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: stage.isCompleted
                                ? AppColors.success
                                : AppColors.border,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (stage != app.timeline.last)
                          Container(
                            width: 2,
                            height: 30,
                            color: stage.isCompleted
                                ? AppColors.success
                                : AppColors.border,
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.p16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(stage.title,
                              style: AppTypography.labelLarge.copyWith(
                                  fontWeight: stage.isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                          if (stage.date.isNotEmpty)
                            Text(stage.date, style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTile(bool isDark, UniversityApplication app) {
    return SquircleCard(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Documents', style: AppTypography.titleLarge),
              Text('View Vault',
                  style: AppTypography.labelLarge
                      .copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: AppSpacing.p16),
          if (app.documents.isEmpty)
            Text('No documents required.', style: AppTypography.caption)
          else
            ...app.documents.map((d) => _buildDocumentRow(d)),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(DocumentRequirement doc) {
    final isDone = doc.status == 'Verified' || doc.status == 'Uploaded';
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.p16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Iconsax.document,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.name, style: AppTypography.labelLarge),
                Text(doc.status,
                    style: AppTypography.caption.copyWith(
                        color: isDone ? AppColors.success : AppColors.warning)),
              ],
            ),
          ),
          if (!isDone)
            AppIconButton(icon: Iconsax.document_upload, onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildNotesTile(bool isDark, UniversityApplication app) {
    return SquircleCard(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Notes', style: AppTypography.titleLarge),
              AppIconButton(
                icon: Iconsax.edit_2,
                backgroundColor:
                    isDark ? AppColors.darkBackground : AppColors.background,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.p8),
          Text(
            app.notes.isNotEmpty
                ? app.notes
                : 'No notes added. Tap edit to write application notes.',
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(bool isDark, UniversityApplication app) {
    return SquircleCard(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Activity', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p16),
          if (app.activities.isEmpty)
            Text('No recent activity.', style: AppTypography.caption)
          else
            ...app.activities.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.p12),
                  child: Row(
                    children: [
                      const Icon(Iconsax.info_circle,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.p12),
                      Expanded(
                          child:
                              Text(a.action, style: AppTypography.bodyMedium)),
                      Text(a.date, style: AppTypography.caption),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildFloatingActions(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.p16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.9)
            : AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              text: 'Upload Document',
              onPressed: () {},
              icon: Iconsax.document_upload,
              variant: AppButtonVariant.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.p12),
          AppIconButton(
            icon: Iconsax.more,
            isFilled: true,
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.background,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  StatusType _mapStatus(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.draft:
        return StatusType.draft;
      case ApplicationStatus.submitted:
        return StatusType.submitted;
      case ApplicationStatus.review:
        return StatusType.underReview;
      case ApplicationStatus.interview:
        return StatusType.underReview;
      case ApplicationStatus.accepted:
        return StatusType.accepted;
      case ApplicationStatus.scholarship:
        return StatusType.accepted;
      case ApplicationStatus.rejected:
        return StatusType.rejected;
    }
  }
}
