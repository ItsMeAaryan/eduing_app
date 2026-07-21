import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';

class MockInterviewScreen extends StatelessWidget {
  const MockInterviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildVideoArea(),
            _buildControls(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const Icon(Iconsax.clock, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text('12:45', style: AppTypography.label.copyWith(color: Colors.white)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: Text('End', style: AppTypography.button.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: -0.1);
  }

  Widget _buildVideoArea() {
    return Expanded(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.video_circle, color: Colors.white24, size: 64),
                  const SizedBox(height: 16),
                  Text('Camera Active', style: AppTypography.caption.copyWith(color: Colors.white54)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 48,
            right: 48,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('QUESTION 3 OF 10', style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Tell me about a time you had to lead a project under a tight deadline.', style: AppTypography.title.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fade().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Iconsax.previous, color: Colors.white54, size: 32),
            onPressed: () {},
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.error.withOpacity(0.5), blurRadius: 20, spreadRadius: 5),
                ],
              ),
              child: const Icon(Iconsax.microphone_2, color: Colors.white, size: 32),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
          ),
          IconButton(
            icon: const Icon(Iconsax.next, color: Colors.white, size: 32),
            onPressed: () => context.pushReplacement('/interview/report'),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }
}
