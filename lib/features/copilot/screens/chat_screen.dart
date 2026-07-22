import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/copilot_provider.dart';
import '../models/chat_message.dart';

class CopilotChatScreen extends ConsumerStatefulWidget {
  const CopilotChatScreen({super.key});

  @override
  ConsumerState<CopilotChatScreen> createState() => _CopilotChatScreenState();
}

class _CopilotChatScreenState extends ConsumerState<CopilotChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _selectedContext;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _controller.text.trim();
    if (text.isNotEmpty) {
      ref.read(copilotProvider.notifier).sendMessage(text, contextInjection: _selectedContext);
      _controller.clear();
      setState(() => _selectedContext = null);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(copilotProvider).history;

    ref.listen(copilotProvider, (previous, next) {
      if (previous?.history.length != next.history.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.magic_star, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text('AI Copilot Assistant', style: AppTypography.title.copyWith(fontSize: 16)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildQuickPromptsBar(),
          if (_selectedContext != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: AppColors.primary.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Iconsax.document_text, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Context Attached: $_selectedContext', style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16, color: AppColors.primary),
                    onPressed: () => setState(() => _selectedContext = null),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                return _buildMessage(history[index]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildQuickPromptsBar() {
    final suggestions = [
      'What documents do I need for Stanford?',
      'How to structure an SOP for MIT?',
      'Find STEM scholarships for CS majors',
    ];

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final s = suggestions[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(s, style: const TextStyle(fontSize: 11)),
              onPressed: () => _sendMessage(s),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    final isAI = message.role == MessageRole.ai;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAI) ...[
            const CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 16,
              child: Icon(Iconsax.magic_star, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isAI ? Theme.of(context).cardColor : AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                border: isAI ? Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)) : null,
              ),
              child: message.isTyping
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        ),
                        SizedBox(width: 8),
                        Text('Generating response...', style: TextStyle(fontSize: 12)),
                      ],
                    )
                  : Text(
                      message.text,
                      style: AppTypography.body.copyWith(
                        color: isAI ? Theme.of(context).textTheme.bodyMedium?.color : Colors.white,
                      ),
                    ),
            ),
          ),
          if (!isAI) ...[
            const SizedBox(width: 10),
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 16,
              child: Icon(Iconsax.user, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    ).animate().fade();
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Iconsax.paperclip, color: AppColors.primary),
            onPressed: () {
              setState(() => _selectedContext = 'Application & Resume Context');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Attached application context to next query.')),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _sendMessage(),
              decoration: const InputDecoration(
                hintText: 'Ask Copilot anything...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.send_1, color: AppColors.primary),
            onPressed: () => _sendMessage(),
          ),
        ],
      ),
    );
  }
}
