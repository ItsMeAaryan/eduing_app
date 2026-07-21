import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/interview_provider.dart';
import '../models/interview_model.dart';
import '../../universities/widgets/filter_chip.dart';

class InterviewDashboardScreen extends ConsumerStatefulWidget {
  const InterviewDashboardScreen({super.key});

  @override
  ConsumerState<InterviewDashboardScreen> createState() => _InterviewDashboardScreenState();
}

class _InterviewDashboardScreenState extends ConsumerState<InterviewDashboardScreen> {
  final List<String> _filters = ['All', 'General', 'Behavioral', 'Why This University', 'Technical'];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(interviewProvider);
    final filteredQuestions = _selectedFilter == 'All' ? data.questions : data.questions.where((q) => q.category == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Interview Coach', style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.chart, color: AppColors.primary),
            onPressed: () => context.push('/interview/report'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReadinessCard(data),
            _buildActionButtons(context),
            _buildFilters(),
            _buildQuestionList(filteredQuestions),
            _buildSessionHistory(data.history),
          ],
        ),
      ),
    );
  }

  Widget _buildReadinessCard(InterviewDashboardData data) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: data.overallReadiness / 100.0,
                      backgroundColor: Colors.grey.shade200,
                      color: AppColors.primary,
                      strokeWidth: 8,
                    ),
                    Center(
                      child: Text('${data.overallReadiness}', style: AppTypography.headline.copyWith(fontSize: 24, color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Overall Readiness', style: AppTypography.title),
                    const SizedBox(height: 8),
                    Text('You are well prepared. Focus on Technical knowledge.', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniScore('Confidence', data.confidenceScore, AppColors.success),
              _buildMiniScore('Communication', data.communicationScore, AppColors.success),
              _buildMiniScore('Technical', data.technicalScore, AppColors.warning),
            ],
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildMiniScore(String label, int score, Color color) {
    return Column(
      children: [
        Text('$score', style: AppTypography.title.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => context.push('/interview/mock'),
              icon: const Icon(Iconsax.video, color: Colors.white, size: 20),
              label: const Text('Mock Interview'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            final filter = _filters[index];
            return AppFilterChip(
              label: filter,
              isSelected: _selectedFilter == filter,
              onTap: () => setState(() => _selectedFilter = filter),
            );
          },
        ),
      ),
    ).animate().fade(delay: 200.ms).slideX();
  }

  Widget _buildQuestionList(List<InterviewQuestion> questions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final q = questions[index];
        return GestureDetector(
          onTap: () => context.push('/interview/practice', extra: q),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.category, style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(q.question, style: AppTypography.label),
                    ],
                  ),
                ),
                Icon(q.isPracticed ? Iconsax.tick_circle : Iconsax.arrow_right_3, color: q.isPracticed ? AppColors.success : AppColors.textSecondary),
              ],
            ),
          ),
        );
      },
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildSessionHistory(List<InterviewSession> history) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Session History', style: AppTypography.title),
          const SizedBox(height: 16),
          ...history.map((s) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: AppColors.background, child: Icon(Iconsax.video5, color: AppColors.primary, size: 20)),
                  title: Text(s.university, style: AppTypography.label),
                  subtitle: Text('${s.date} • ${s.duration}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${s.overallScore}', style: AppTypography.title.copyWith(color: AppColors.primary)),
                      Text(s.improvement, style: AppTypography.caption.copyWith(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    ).animate().fade(delay: 400.ms).slideY(begin: 0.1);
  }
}
