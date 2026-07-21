import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      ref.read(copilotProvider.notifier).sendMessage(text);
      _controller.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(copilotProvider).history;
    
    // Auto-scroll when history changes
    ref.listen(copilotProvider, (previous, next) {
      if (previous?.history.length != next.history.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.magic_star, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text('Copilot', style: AppTypography.title.copyWith(fontSize: 16)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final message = history[index];
                return _buildMessage(message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    final isAI = message.role == MessageRole.ai;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAI) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(Iconsax.magic_star, color: AppColors.primary, size: 16),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isAI ? Colors.white : AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: Radius.circular(isAI ? 4 : 24),
                  bottomRight: Radius.circular(isAI ? 24 : 4),
                ),
                boxShadow: isAI ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))] : null,
              ),
              child: message.isTyping
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(radius: 4, backgroundColor: AppColors.primary).animate(onPlay: (c) => c.repeat()).fade(duration: 500.ms),
                        const SizedBox(width: 4),
                        const CircleAvatar(radius: 4, backgroundColor: AppColors.primary).animate(onPlay: (c) => c.repeat()).fade(duration: 500.ms, delay: 200.ms),
                        const SizedBox(width: 4),
                        const CircleAvatar(radius: 4, backgroundColor: AppColors.primary).animate(onPlay: (c) => c.repeat()).fade(duration: 500.ms, delay: 400.ms),
                      ],
                    )
                  : Text(
                      message.text,
                      style: AppTypography.body.copyWith(
                        color: isAI ? AppColors.textPrimary : Colors.white,
                        height: 1.5,
                      ),
                    ),
            ),
          ),
          if (!isAI) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Iconsax.user, color: AppColors.textSecondary, size: 16),
            ),
          ],
        ],
      ).animate().fade().slideY(begin: 0.1),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -10))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Iconsax.attach_circle, color: AppColors.textSecondary),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Message Copilot...',
                    hintStyle: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary,
                child: Icon(Iconsax.send_1, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
