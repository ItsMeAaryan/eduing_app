import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../shared/models/university_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppUniversityCard extends StatelessWidget {
  final University university;
  final VoidCallback onFavoriteToggle;

  const AppUniversityCard({
    super.key,
    required this.university,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/university/${university.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                const SizedBox(height: 16),
                _buildTagsRow(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                ),
                _buildCourseAndFees(),
                const SizedBox(height: 16),
                _buildStatsProgress('Placement', university.placementScore, AppColors.primary),
                const SizedBox(height: 8),
                _buildStatsProgress('Career ROI', university.roiScore, AppColors.success),
                const SizedBox(height: 8),
                _buildStatsProgress('Research', university.researchScore, AppColors.primaryDark),
                const SizedBox(height: 16),
                _buildFeatureTags(),
                const SizedBox(height: 20),
                _buildFooter(context),
              ],
            ),
          ),
        ],
      ),
    )).animate().fade(duration: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildHeroImage() {
    return Stack(
      children: [
        Hero(
          tag: 'hero_${university.id}',
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              university.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: Colors.grey.shade200,
                child: const Icon(Icons.error),
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.magic_star, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  'AI Match ${university.aiMatch}%',
                  style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 2.seconds),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                university.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                color: university.isFavorite ? AppColors.error : AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(university.logoUrl),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                university.name,
                style: AppTypography.title.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Iconsax.location, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      university.location,
                      style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            const Icon(Iconsax.star1, color: AppColors.warning, size: 16),
            const SizedBox(width: 4),
            Text(
              university.rating.toString(),
              style: AppTypography.label.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildSmallBadge(university.nirfRanking, AppColors.primary.withOpacity(0.1), AppColors.primary),
        _buildSmallBadge(university.accreditation, AppColors.success.withOpacity(0.1), AppColors.success),
        _buildSmallBadge(university.type, AppColors.background, AppColors.textSecondary),
        _buildSmallBadge(university.established, AppColors.background, AppColors.textSecondary),
      ],
    );
  }

  Widget _buildSmallBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(color: textColor, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _buildCourseAndFees() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Iconsax.book, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              university.course,
              style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Text(
          university.fees,
          style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatsProgress(String label, double percentage, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.background,
              color: color,
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 24,
          child: Text(
            percentage.toInt().toString(),
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: university.tags.map((tag) {
        bool isNumber = tag.startsWith('+');
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isNumber ? Colors.transparent : AppColors.success.withOpacity(0.05),
            borderRadius: BorderRadius.circular(100),
            border: isNumber ? null : Border.all(color: AppColors.success.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isNumber) ...[
                const Icon(Iconsax.tick_circle, color: AppColors.success, size: 12),
                const SizedBox(width: 4),
              ],
              Text(
                tag,
                style: AppTypography.caption.copyWith(
                  color: isNumber ? AppColors.textSecondary : AppColors.success,
                  fontSize: 10,
                  fontWeight: isNumber ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 50,
              height: 24,
              child: Stack(
                children: [
                  Positioned(left: 0, child: _buildFace('https://i.pravatar.cc/150?img=11')),
                  Positioned(left: 14, child: _buildFace('https://i.pravatar.cc/150?img=12')),
                  Positioned(left: 28, child: _buildFace('https://i.pravatar.cc/150?img=13')),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              university.studentCount,
              style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10),
            ),
          ],
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => context.push('/compare', extra: [university.id, university.id == '1' ? '2' : '1']),
              child: Text('Compare', style: AppTypography.button.copyWith(fontSize: 12, color: AppColors.textSecondary)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                elevation: 0,
              ),
              child: Text('View Details', style: AppTypography.button.copyWith(fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFace(String url) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: 10,
        backgroundImage: NetworkImage(url),
      ),
    );
  }
}
