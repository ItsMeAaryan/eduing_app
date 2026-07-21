import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../models/interview_model.dart';

class QuestionPracticeScreen extends StatelessWidget {
  final InterviewQuestion question;

  const QuestionPracticeScreen({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Practice', style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(question.isBookmarked ? Iconsax.bookmark_25 : Iconsax.bookmark_2, color: question.isBookmarked ? AppColors.primary : AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestionHeader(),
            _buildHints(),
            _buildSuggestedStructure(),
            _buildSampleAnswer(),
            _buildTips(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.success,
        icon: const Icon(Iconsax.tick_circle, color: Colors.white),
        label: Text('Mark as Practiced', style: AppTypography.button.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
            child: Text(question.category, style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          Text(question.question, style: AppTypography.headline.copyWith(color: Colors.white, fontSize: 24)),
        ],
      ),
    ).animate().fade().scale();
  }

  Widget _buildHints() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.lamp_on, color: AppColors.warning, size: 20),
              const SizedBox(width: 12),
              Text('Hints', style: AppTypography.title),
            ],
          ),
          const SizedBox(height: 16),
          ...question.hints.map((hint) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 3, backgroundColor: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(child: Text(hint, style: AppTypography.body)),
                  ],
                ),
              )),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildSuggestedStructure() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Suggested Structure', style: AppTypography.label.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(question.suggestedStructure, style: AppTypography.body),
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildSampleAnswer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sample Answer', style: AppTypography.title),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(question.sampleAnswer, style: AppTypography.body.copyWith(fontStyle: FontStyle.italic, height: 1.5)),
          ),
        ],
      ),
    ).animate().fade(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildTips() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preparation Tips', style: AppTypography.title),
          const SizedBox(height: 16),
          ...question.preparationTips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Iconsax.info_circle, color: AppColors.textSecondary, size: 16),
                    const SizedBox(width: 12),
                    Expanded(child: Text(tip, style: AppTypography.caption.copyWith(color: AppColors.textSecondary))),
                  ],
                ),
              )),
        ],
      ),
    ).animate().fade(delay: 400.ms).slideY(begin: 0.1);
  }
}
