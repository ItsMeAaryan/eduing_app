import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../models/interview_model.dart';

class QuestionPracticeScreen extends StatelessWidget {
  final InterviewQuestion? question;

  const QuestionPracticeScreen({super.key, this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Practice'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question?.question ?? 'Tell me about yourself and your academic goals.',
              style: AppTypography.headline,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Suggested Response Structure', style: AppTypography.subheading),
                    const SizedBox(height: 8),
                    Text(
                      question?.suggestedStructure ?? '1. Brief introduction\n2. Key academic highlights\n3. Why this program fits career goals',
                      style: AppTypography.body,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/interview/mock'),
              icon: const Icon(Iconsax.microphone),
              label: const Text('Practice Answering Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ).animate().fade(),
      ),
    );
  }
}
