import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../shared/models/university_model.dart';
import '../providers/universities_provider.dart';
import '../../applications/providers/applications_provider.dart';

class UniversityDetailsScreen extends ConsumerWidget {
  final String universityId;

  const UniversityDetailsScreen({super.key, required this.universityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final universities = ref.watch(universitiesProvider);
    final university = universities.firstWhere(
      (u) => u.id == universityId,
      orElse: () => universities.first, // fallback
    );
    final notifier = ref.read(universitiesProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, university, notifier),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100), // Space for bottom bar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderInfo(university),
                      _buildAIMatchCard(university),
                      _buildAboutSection(university),
                      _buildCourses(university),
                      _buildStatistics(university),
                      _buildFacilities(university),
                      _buildGallery(university),
                      _buildPlacements(university),
                      _buildScholarships(university),
                      _buildAdmissionTimeline(),
                      _buildReviews(),
                      _buildAIInsights(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomActionBar(context, university, ref),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, University university, UniversitiesNotifier notifier) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left_2),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(university.isFavorite ? Iconsax.heart5 : Iconsax.heart),
          color: university.isFavorite ? AppColors.error : AppColors.textSecondary,
          onPressed: () => notifier.toggleFavorite(university.id),
        ),
        IconButton(
          icon: const Icon(Iconsax.share),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'hero_${university.id}',
              child: Image.network(
                university.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(University university) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
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
                      style: AppTypography.headline.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Iconsax.location, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            university.location,
                            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(university.nirfRanking, AppColors.primary),
              _buildTag(university.accreditation, AppColors.success),
              _buildTag(university.type, AppColors.textSecondary),
            ],
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAIMatchCard(University university) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('AI Match Analysis', style: AppTypography.label.copyWith(color: Colors.white)),
              const Spacer(),
              Text('${university.aiMatch}% Match', style: AppTypography.title.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 24),
          _buildAIProgressRow('Admission Probability', university.admissionProbability),
          const SizedBox(height: 12),
          _buildAIProgressRow('Career ROI', university.roiScore),
          const SizedBox(height: 12),
          _buildAIProgressRow('Placement Confidence', university.placementScore),
          const SizedBox(height: 12),
          _buildAIProgressRow('Scholarship Probability', university.scholarshipProbability),
          const SizedBox(height: 12),
          _buildAIProgressRow('Hostel Compatibility', university.hostelCompatibility),
          const SizedBox(height: 12),
          _buildAIProgressRow('International Opportunities', university.internationalOpportunities),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildAIProgressRow(String label, double value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: AppTypography.caption.copyWith(color: Colors.white70)),
        ),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.white24,
              color: Colors.white,
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 32,
          child: Text('${value.toInt()}%', style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildAboutSection(University university) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About', style: AppTypography.title),
          const SizedBox(height: 12),
          Text(
            university.description,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary, height: 1.6),
          ),
          const SizedBox(height: 8),
          Text('Read More', style: AppTypography.label.copyWith(color: AppColors.primary)),
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildCourses(University university) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Courses', style: AppTypography.title),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: university.coursesList.map((course) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(course, style: AppTypography.label),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildStatistics(University university) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Statistics', style: AppTypography.title),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard('Students', university.studentCount),
              _buildStatCard('Faculty', '1.2K+'),
              _buildStatCard('Research Papers', '10K+'),
              _buildStatCard('Patents', '250+'),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.title),
        ],
      ),
    );
  }

  Widget _buildFacilities(University university) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Facilities', style: AppTypography.title),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: university.facilities.map((facility) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Iconsax.tick_circle, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Text(facility, style: AppTypography.body),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fade(delay: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildGallery(University university) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Gallery', style: AppTypography.title),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Iconsax.gallery, color: Colors.grey),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildPlacements(University university) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Placements', style: AppTypography.title),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Average', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(university.fees, style: AppTypography.title.copyWith(color: AppColors.primary)),
                  ],
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                Column(
                  children: [
                    Text('Highest', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text('₹1.2 Cr', style: AppTypography.title.copyWith(color: AppColors.success)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 700.ms).slideY(begin: 0.1);
  }

  Widget _buildScholarships(University university) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Scholarships', style: AppTypography.title),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Merit Scholarship', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Up to 50% waiver on tuition fees for students above 90% in academics.', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: Text('View Details', style: AppTypography.button.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 800.ms).slideY(begin: 0.1);
  }

  Widget _buildAdmissionTimeline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Admission Timeline', style: AppTypography.title),
          const SizedBox(height: 16),
          _buildTimelineItem('Registration Opens', '01 Jan 2025', true),
          _buildTimelineItem('Exam Date', '15 Apr 2025', false),
          _buildTimelineItem('Counselling', '20 May 2025', false),
        ],
      ),
    ).animate().fade(delay: 900.ms).slideY(begin: 0.1);
  }

  Widget _buildTimelineItem(String title, String date, bool isPast) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isPast ? AppColors.primary : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.label),
                Text(date, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Student Reviews', style: AppTypography.title),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
                        Text('Computer Science • 3rd Year', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '"The coding culture here is fantastic. Lots of hackathons and great placements."',
                  style: AppTypography.body.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 1000.ms).slideY(begin: 0.1);
  }

  Widget _buildAIInsights() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(gradient: AppColors.aiGradient, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Iconsax.magic_star, color: Colors.white),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Recommendation', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'This university aligns extremely well with your academic profile. You have a high probability of admission.',
                  style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 1100.ms).slideY(begin: 0.1);
  }

  Widget _buildBottomActionBar(BuildContext context, University university, WidgetRef ref) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/compare', extra: [university.id, university.id == '1' ? '2' : '1']),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Text('Compare', style: AppTypography.button.copyWith(color: AppColors.textPrimary)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(applicationsNotifierProvider.notifier).createApplication(
                      universityName: university.name,
                      course: university.course,
                      deadline: '01 Dec 2025',
                    );
                    context.go('/applications');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Apply Now', style: AppTypography.button.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
