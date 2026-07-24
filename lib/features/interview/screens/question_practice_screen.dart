import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/molecules/squircle_card.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../../../shared/components/atoms/app_button.dart';
import '../models/interview_model.dart';

class QuestionPracticeScreen extends StatelessWidget {
  final InterviewQuestion? question;

  const QuestionPracticeScreen({super.key, this.question});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
        child: SizedBox(
          width: double.infinity,
          child: AppButton(
            text: 'Practice Answering Now',
            icon: Iconsax.microphone_2,
            onPressed: () => context.push('/interview/mock'),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.p24, 0, AppSpacing.p24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question?.question ??
                          'Tell me about yourself and your academic goals.',
                      style: AppTypography.display
                          .copyWith(fontSize: 32, color: AppColors.primary),
                    ),
                    const SizedBox(height: AppSpacing.p32),
                    SquircleCard(
                      padding: const EdgeInsets.all(AppSpacing.p24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Iconsax.task_square,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: AppSpacing.p12),
                              Text('Suggested Response Structure',
                                  style: AppTypography.titleMedium),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.p16),
                          Text(
                            question?.suggestedStructure ??
                                '1. Brief introduction\n2. Key academic highlights\n3. Why this program fits career goals',
                            style:
                                AppTypography.bodyMedium.copyWith(height: 1.8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fade().slideY(begin: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
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
            child: Text(
              'Question Prep',
              style: AppTypography.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
