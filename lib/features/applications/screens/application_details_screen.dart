import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../models/university_application.dart';
import '../providers/applications_provider.dart';

class ApplicationDetailsScreen extends ConsumerWidget {
  final String applicationId;

  const ApplicationDetailsScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationsProvider);
    final application = applications.firstWhere(
      (app) => app.id == applicationId,
      orElse: () => applications.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, application),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProgressSection(application),
                    const SizedBox(height: 32),
                    _buildAICoachCard(),
                    const SizedBox(height: 32),
                    _buildTimeline(application),
                    const SizedBox(height: 32),
                    _buildDocumentChecklist(context, application),
                    const SizedBox(height: 32),
                    _buildMetricsSection(application),
                    const SizedBox(height: 32),
                    _buildActivityLog(application),
                    const SizedBox(height: 32),
                    _buildContactInfo(application),
                  ]),
                ),
              ),
            ],
          ),
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, UniversityApplication app) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left_2, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(icon: const Icon(Iconsax.heart, color: Colors.white), onPressed: () {}),
        IconButton(icon: const Icon(Iconsax.share, color: Colors.white), onPressed: () {}),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'hero_app_${app.id}',
              child: Image.network(
                app.university.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(app.university.logoUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            app.statusDisplay.toUpperCase(),
                            style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(app.university.name, style: AppTypography.headline.copyWith(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(app.course, style: AppTypography.caption.copyWith(color: Colors.white70)),
                      ],
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

  Widget _buildProgressSection(UniversityApplication app) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Application Progress', style: AppTypography.title),
            Text('${(app.progress * 100).toInt()}%', style: AppTypography.title.copyWith(color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: app.progress,
            backgroundColor: Colors.grey.shade200,
            color: AppColors.primary,
            minHeight: 12,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Iconsax.clock, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text('Estimated time remaining: ${app.estimatedTimeRemaining}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ],
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildAICoachCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Text('AI Admission Coach', style: AppTypography.title.copyWith(color: Colors.white)),
            ],
          ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 2.seconds),
          const SizedBox(height: 16),
          Text(
            'Complete your SOP to increase your admission probability by 12%. Upload pending recommendation letters to proceed to the review stage.',
            style: AppTypography.body.copyWith(color: Colors.white, height: 1.5),
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildTimeline(UniversityApplication app) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Timeline', style: AppTypography.title),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: app.timeline.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              final isLast = index == app.timeline.length - 1;
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: stage.isCompleted ? AppColors.success : (stage.isActive ? AppColors.primary : Colors.grey.shade300),
                            shape: BoxShape.circle,
                            border: stage.isActive ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 4) : null,
                          ),
                          child: stage.isCompleted ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: stage.isCompleted ? AppColors.success : Colors.grey.shade200,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stage.title,
                              style: AppTypography.label.copyWith(
                                fontWeight: stage.isActive ? FontWeight.bold : FontWeight.normal,
                                color: stage.isCompleted || stage.isActive ? AppColors.textPrimary : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(stage.date, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildDocumentChecklist(BuildContext context, UniversityApplication app) {
    if (app.documents.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Documents', style: AppTypography.title),
            TextButton(
              onPressed: () => context.push('/documents'),
              child: Text('Manage', style: AppTypography.button),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: app.documents.map((doc) {
              final isUploaded = doc.status == 'Uploaded';
              final isPending = doc.status == 'Pending';
              return ListTile(
                leading: Icon(
                  isUploaded ? Iconsax.document_copy : (isPending ? Iconsax.document_1 : Iconsax.document_filter),
                  color: isUploaded ? AppColors.success : (isPending ? AppColors.warning : AppColors.error),
                ),
                title: Text(doc.name, style: AppTypography.label),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUploaded ? AppColors.success.withOpacity(0.1) : (isPending ? AppColors.warning.withOpacity(0.1) : AppColors.error.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    doc.status,
                    style: AppTypography.caption.copyWith(
                      color: isUploaded ? AppColors.success : (isPending ? AppColors.warning : AppColors.error),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildMetricsSection(UniversityApplication app) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Application Metrics', style: AppTypography.title),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildMetricCard('Admission\nProbability', '${app.metrics.admissionProbability}%', AppColors.primary),
            const SizedBox(width: 12),
            _buildMetricCard('Scholarship\nChance', '${app.metrics.scholarshipChance}%', AppColors.secondary),
          ],
        ),
      ],
    ).animate().fade(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppTypography.headline.copyWith(color: color, fontSize: 24)),
            const SizedBox(height: 8),
            Text(title, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLog(UniversityApplication app) {
    if (app.activities.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: AppTypography.title),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: app.activities.map((activity) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(Iconsax.clock, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(child: Text(activity.action, style: AppTypography.label)),
                    Text(activity.date, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fade(delay: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildContactInfo(UniversityApplication app) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Admissions', style: AppTypography.title),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Iconsax.sms, color: AppColors.textSecondary, size: 20),
                  const SizedBox(width: 16),
                  Text(app.contactEmail, style: AppTypography.label),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
              Row(
                children: [
                  const Icon(Iconsax.call, color: AppColors.textSecondary, size: 20),
                  const SizedBox(width: 16),
                  Text(app.contactPhone, style: AppTypography.label),
                ],
              ),
            ],
          ),
        ),
      ],
    ).animate().fade(delay: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildQuickActions(BuildContext context) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/resume/builder'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Resume', style: AppTypography.button.copyWith(color: AppColors.textPrimary)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/sop/builder'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('SOP', style: AppTypography.button.copyWith(color: AppColors.textPrimary)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/interview'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Coach', style: AppTypography.button.copyWith(color: AppColors.textPrimary)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => context.push('/documents'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Upload Documents', style: AppTypography.button.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
            ],
          ),
        ),
      ),
    );
  }
}

