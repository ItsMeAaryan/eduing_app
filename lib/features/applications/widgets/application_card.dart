import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../models/university_application.dart';

class AppApplicationCard extends StatefulWidget {
  final UniversityApplication application;

  const AppApplicationCard({super.key, required this.application});

  @override
  State<AppApplicationCard> createState() => _AppApplicationCardState();
}

class _AppApplicationCardState extends State<AppApplicationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final app = widget.application;
    final uni = app.university;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(app, uni),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCourseInfo(app),
                const SizedBox(height: 16),
                _buildProgress(app),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                ),
                _buildFooter(app),
                if (_isExpanded) _buildExpandedTimeline(app),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildHeader(UniversityApplication app, dynamic uni) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Image.network(
            uni.imageUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(height: 120, color: Colors.grey.shade200),
          ),
        ),
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.6)],
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(app.status),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              app.statusDisplay.toUpperCase(),
              style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),
        ),
        const Positioned(
          top: 16,
          right: 16,
          child: Icon(Iconsax.more, color: Colors.white),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(uni.logoUrl),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    uni.name,
                    style: AppTypography.label.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'App ID: ${app.id.toUpperCase()}',
                    style: AppTypography.caption.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseInfo(UniversityApplication app) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Course', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(app.course, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Deadline', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(app.deadline, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, color: AppColors.error)),
          ],
        ),
      ],
    );
  }

  Widget _buildProgress(UniversityApplication app) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Application Progress', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            Text('${(app.progress * 100).toInt()}%', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: app.progress,
            backgroundColor: AppColors.background,
            color: AppColors.primary,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              const Icon(Iconsax.magic_star, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI Success Prediction: ${app.aiSuccessPrediction}%',
                  style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(UniversityApplication app) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          icon: Icon(_isExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1, size: 16),
          label: Text('Timeline', style: AppTypography.button.copyWith(color: AppColors.textPrimary)),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text('Continue', style: AppTypography.button.copyWith(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildExpandedTimeline(UniversityApplication app) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: app.timeline.map((stage) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: stage.isCompleted ? AppColors.success : (stage.isActive ? AppColors.primary : Colors.grey.shade300),
                        shape: BoxShape.circle,
                      ),
                      child: stage.isCompleted ? const Icon(Icons.check, color: Colors.white, size: 10) : null,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stage.title, style: AppTypography.label.copyWith(fontWeight: stage.isActive ? FontWeight.bold : FontWeight.normal)),
                      Text(stage.date, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ).animate().fade().slideY(begin: -0.1);
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.draft: return AppColors.textSecondary;
      case ApplicationStatus.submitted: return AppColors.info;
      case ApplicationStatus.review: return AppColors.warning;
      case ApplicationStatus.accepted: return AppColors.success;
      case ApplicationStatus.rejected: return AppColors.error;
      case ApplicationStatus.interview: return AppColors.primary;
      case ApplicationStatus.scholarship: return AppColors.secondary;
    }
  }
}
