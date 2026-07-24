import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/atoms/app_text_field.dart';
import '../../../shared/components/organisms/premium_application_card.dart';

import '../../../shared/components/atoms/status_pill.dart';
import '../../../shared/components/atoms/app_button.dart';
import '../providers/applications_provider.dart';
import '../models/university_application.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final inReviewApps = applications.where((a) => a.status == ApplicationStatus.review || a.status == ApplicationStatus.interview).toList();
    final actionRequiredApps = applications.where((a) => a.status == ApplicationStatus.draft).toList();
    final submittedApps = applications.where((a) => a.status == ApplicationStatus.submitted).toList();
    final decidedApps = applications.where((a) => a.status == ApplicationStatus.accepted || a.status == ApplicationStatus.rejected || a.status == ApplicationStatus.scholarship).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // To be wired up
        backgroundColor: AppColors.primary,
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Floating Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.p24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Applications', style: AppTypography.display),
                      const SizedBox(height: AppSpacing.p4),
                      Text('${applications.length} Total Applications', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Iconsax.sort),
                        onPressed: () {},
                      ),
                      const SizedBox(width: AppSpacing.p8),
                      IconButton(
                        icon: const Icon(Iconsax.filter),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
              child: AppTextField(
                controller: _searchController,
                hintText: 'Search by University, Course, or Country...',
                prefixIcon: Iconsax.search_normal,
              ),
            ),
            
            const SizedBox(height: AppSpacing.p24),
            
            // Summary Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
              child: Row(
                children: [
                  _SummaryChip(label: 'Total', count: applications.length.toString(), color: AppColors.primary),
                  const SizedBox(width: AppSpacing.p12),
                  _SummaryChip(label: 'Action Required', count: actionRequiredApps.length.toString(), color: AppColors.error),
                  const SizedBox(width: AppSpacing.p12),
                  _SummaryChip(label: 'In Review', count: inReviewApps.length.toString(), color: AppColors.warning),
                  const SizedBox(width: AppSpacing.p12),
                  _SummaryChip(label: 'Decided', count: decidedApps.length.toString(), color: AppColors.success),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.p32),
            
            // Content
            Expanded(
              child: applications.isEmpty
                  ? _buildEmptyState(isDark)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (actionRequiredApps.isNotEmpty) ...[
                            _buildSectionHeader('Action Required'),
                            ...actionRequiredApps.map((app) => _buildApplicationCard(context, app)),
                            const SizedBox(height: AppSpacing.p32),
                          ],
                          if (inReviewApps.isNotEmpty) ...[
                            _buildSectionHeader('In Review'),
                            ...inReviewApps.map((app) => _buildApplicationCard(context, app)),
                            const SizedBox(height: AppSpacing.p32),
                          ],
                          if (submittedApps.isNotEmpty) ...[
                            _buildSectionHeader('Submitted'),
                            ...submittedApps.map((app) => _buildApplicationCard(context, app)),
                            const SizedBox(height: AppSpacing.p32),
                          ],
                          if (decidedApps.isNotEmpty) ...[
                            _buildSectionHeader('Decisions'),
                            ...decidedApps.map((app) => _buildApplicationCard(context, app)),
                            const SizedBox(height: AppSpacing.p48), // Bottom padding
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.p16),
      child: Text(title, style: AppTypography.titleLarge),
    );
  }

  Widget _buildApplicationCard(BuildContext context, UniversityApplication app) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.p16),
      child: PremiumApplicationCard(
        logoUrl: app.university.logoUrl.isNotEmpty ? app.university.logoUrl : 'https://placehold.co/100x100/png',
        universityName: app.university.name,
        course: app.course,
        status: _mapStatus(app.status),
        deadline: app.deadline,
        progress: app.progress,
        onTap: () => context.push('/applications/details', extra: app),
        onMenuTap: () {},
      ),
    ).animate().fade().slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.folder_add, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.p24),
            Text('No Applications Yet', style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.p8),
            Text(
              'Your application workspace is empty. Explore universities to start your admission journey.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.p32),
            AppButton(
              text: 'Explore Universities',
              onPressed: () => context.go('/universities'),
              icon: Iconsax.building,
            ),
          ],
        ),
      ),
    );
  }

  StatusType _mapStatus(ApplicationStatus status) {
    switch(status) {
      case ApplicationStatus.draft: return StatusType.draft;
      case ApplicationStatus.submitted: return StatusType.submitted;
      case ApplicationStatus.review: return StatusType.underReview;
      case ApplicationStatus.interview: return StatusType.underReview;
      case ApplicationStatus.accepted: return StatusType.accepted;
      case ApplicationStatus.scholarship: return StatusType.accepted;
      case ApplicationStatus.rejected: return StatusType.rejected;
      default: return StatusType.inProgress;
    }
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _SummaryChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p16, vertical: AppSpacing.p12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              count,
              style: AppTypography.labelLarge.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: AppSpacing.p12),
          Text(label, style: AppTypography.labelMedium.copyWith(color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)),
        ],
      ),
    );
  }
}
