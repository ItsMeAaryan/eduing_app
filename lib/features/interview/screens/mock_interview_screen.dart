import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../providers/interview_provider.dart';

class MockInterviewScreen extends ConsumerStatefulWidget {
  const MockInterviewScreen({super.key});

  @override
  ConsumerState<MockInterviewScreen> createState() =>
      _MockInterviewScreenState();
}

class _MockInterviewScreenState extends ConsumerState<MockInterviewScreen> {
  bool _isRecording = false;
  final TextEditingController _answerController = TextEditingController();
  final String _currentQuestion =
      'Why did you select this university and what are your long-term career goals?';
  bool _isEvaluating = false;

  Future<void> _toggleRecording() async {
    final speechService = ref.read(speechAudioServiceProvider);
    if (!_isRecording) {
      try {
        setState(() => _isRecording = true);
        await speechService.startListening(
          onResult: (text) {
            setState(() {
              _answerController.text = text;
            });
          },
        );
      } catch (e) {
        setState(() => _isRecording = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Speech recognition unavailable. Use manual text input.'),
                backgroundColor: AppColors.error),
          );
        }
      }
    } else {
      await speechService.stopListening();
      setState(() => _isRecording = false);
    }
  }

  Future<void> _submitAnswer() async {
    final text = _answerController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please record audio or type your answer.'),
            backgroundColor: AppColors.warning),
      );
      return;
    }

    setState(() => _isEvaluating = true);
    final router = GoRouter.of(context);
    final session =
        await ref.read(interviewNotifierProvider.notifier).evaluateAnswer(
              questionTitle: _currentQuestion,
              answerText: text,
            );
    setState(() => _isEvaluating = false);

    if (mounted) {
      router.pushReplacement('/interview/report', extra: session);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simulated camera viewfinder background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Colors.grey.shade900,
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildQuestionCard(),
                Expanded(
                  child: _buildTranscriptArea(),
                ),
                _buildControlBar(),
              ],
            ),
          ),

          if (_isEvaluating)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                            color: AppColors.primary),
                        const SizedBox(height: AppSpacing.p24),
                        Text('AI Evaluating Response...',
                            style: AppTypography.titleLarge
                                .copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppIconButton(
            icon: Iconsax.close_square,
            isFilled: true,
            backgroundColor: Colors.white10,
            color: Colors.white,
            onPressed: () => context.pop(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.p16, vertical: AppSpacing.p8),
            decoration: BoxDecoration(
              color:
                  _isRecording ? Colors.red.withOpacity(0.2) : Colors.white10,
              borderRadius: BorderRadius.circular(100),
              border:
                  Border.all(color: _isRecording ? Colors.red : Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(
                        target: _isRecording ? 1 : 0, onPlay: (c) => c.repeat())
                    .fade(duration: 500.ms)
                    .then()
                    .fade(begin: 1, end: 0.2, duration: 800.ms),
                const SizedBox(width: AppSpacing.p8),
                Text(
                  _isRecording ? 'REC 00:00' : 'READY',
                  style: AppTypography.labelMedium.copyWith(
                      color: _isRecording ? Colors.red : Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48), // Balance header
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p24, vertical: AppSpacing.p16),
      padding: const EdgeInsets.all(AppSpacing.p24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.message_question,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: AppSpacing.p8),
              Text('QUESTION 1 / 5',
                  style: AppTypography.labelMedium
                      .copyWith(color: AppColors.primary, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: AppSpacing.p16),
          Text(_currentQuestion,
              style: AppTypography.titleLarge
                  .copyWith(color: Colors.white, height: 1.4)),
        ],
      ),
    ).animate().fade().slideY(begin: -0.05);
  }

  Widget _buildTranscriptArea() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p24, vertical: AppSpacing.p8),
      padding: const EdgeInsets.all(AppSpacing.p24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Transcript',
              style: AppTypography.caption.copyWith(color: Colors.white54)),
          const SizedBox(height: AppSpacing.p12),
          Expanded(
            child: TextField(
              controller: _answerController,
              maxLines: null,
              expands: true,
              style: AppTypography.bodyMedium
                  .copyWith(color: Colors.white, fontSize: 18, height: 1.6),
              decoration: InputDecoration(
                hintText: _isRecording
                    ? 'Listening...'
                    : 'Tap record to speak, or type your answer here...',
                hintStyle: const TextStyle(color: Colors.white24),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.05);
  }

  Widget _buildControlBar() {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.p24,
        right: AppSpacing.p24,
        top: AppSpacing.p24,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.p24,
      ),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _toggleRecording,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color:
                    _isRecording ? Colors.red.withOpacity(0.2) : Colors.white10,
                shape: BoxShape.circle,
                border: Border.all(
                    color: _isRecording ? Colors.red : Colors.white24,
                    width: 2),
              ),
              child: Center(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : Colors.white,
                    shape: _isRecording ? BoxShape.rectangle : BoxShape.circle,
                    borderRadius:
                        _isRecording ? BorderRadius.circular(8) : null,
                  ),
                  child: Icon(
                    _isRecording ? Iconsax.stop : Iconsax.microphone_2,
                    color: _isRecording ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.p32),
          AppIconButton(
            icon: Iconsax.send_1,
            isFilled: true,
            backgroundColor: AppColors.primary,
            color: Colors.white,
            onPressed: _isEvaluating ? () {} : _submitAnswer,
          ),
        ],
      ),
    );
  }
}
