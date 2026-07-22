import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/interview_provider.dart';

class MockInterviewScreen extends ConsumerStatefulWidget {
  const MockInterviewScreen({super.key});

  @override
  ConsumerState<MockInterviewScreen> createState() => _MockInterviewScreenState();
}

class _MockInterviewScreenState extends ConsumerState<MockInterviewScreen> {
  bool _isRecording = false;
  final TextEditingController _answerController = TextEditingController();
  final String _currentQuestion = 'Why did you select this university and what are your long-term career goals?';
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
            const SnackBar(content: Text('Speech recognition unavailable. Use manual text input below.')),
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
        const SnackBar(content: Text('Please record audio or type your answer.')),
      );
      return;
    }

    setState(() => _isEvaluating = true);
    final session = await ref.read(interviewNotifierProvider.notifier).evaluateAnswer(
          questionTitle: _currentQuestion,
          answerText: text,
        );
    setState(() => _isEvaluating = false);

    if (mounted) {
      context.push('/interview/report', extra: session);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('AI Mock Interview', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('QUESTION', style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(_currentQuestion, style: AppTypography.subheading.copyWith(color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: TextField(
                  controller: _answerController,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Spoken transcript or manual answer input will appear here...',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _toggleRecording,
                      icon: Icon(_isRecording ? Iconsax.stop : Iconsax.microphone, color: _isRecording ? Colors.red : Colors.white),
                      label: Text(_isRecording ? 'Stop Recording' : 'Voice Record', style: TextStyle(color: _isRecording ? Colors.red : Colors.white)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _isRecording ? Colors.red : Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isEvaluating ? null : _submitAnswer,
                      icon: _isEvaluating
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Iconsax.send_1),
                      label: Text(_isEvaluating ? 'Evaluating...' : 'Submit Answer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
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
}
