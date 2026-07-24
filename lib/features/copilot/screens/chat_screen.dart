import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../../../shared/components/atoms/app_text_field.dart';
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
      ref
          .read(copilotProvider.notifier)
          .sendMessage(text, contextInjection: _selectedContext);
      _controller.clear();
      setState(() => _selectedContext = null);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(copilotProvider).history;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen(copilotProvider, (previous, next) {
      if (previous?.history.length != next.history.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.p8),
              decoration: BoxDecoration(
                gradient: AppColors.aiGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Iconsax.magic_star, color: Colors.white, size: 20),
            ),
            const SizedBox(width: AppSpacing.p12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Strategist', style: AppTypography.titleLarge),
                Text('Online',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.success)),
              ],
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: AppIconButton(
            icon: Iconsax.arrow_left_2,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () => context.pop(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AppIconButton(
              icon: Iconsax.more,
              isFilled: true,
              backgroundColor:
                  isDark ? AppColors.darkSurface : AppColors.surface,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildQuickPromptsBar(isDark),
          if (_selectedContext != null) _buildContextBadge(isDark),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.p24),
              itemCount: history.length,
              itemBuilder: (context, index) {
                return _buildMessage(history[index], isDark);
              },
            ),
          ),
          _buildInputArea(isDark),
        ],
      ),
    );
  }

  Widget _buildContextBadge(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p24, vertical: AppSpacing.p8),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p16, vertical: AppSpacing.p8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.document_text, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.p8),
          Text('Context Attached: $_selectedContext',
              style: AppTypography.caption.copyWith(color: AppColors.primary)),
          const SizedBox(width: AppSpacing.p8),
          GestureDetector(
            onTap: () => setState(() => _selectedContext = null),
            child: const Icon(Icons.close, size: 16, color: AppColors.primary),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: -0.1);
  }

  Widget _buildQuickPromptsBar(bool isDark) {
    final suggestions = [
      'What documents do I need for Stanford?',
      'How to structure an SOP for MIT?',
      'Find STEM scholarships for CS majors',
    ];

    return Container(
      height: 48,
      margin: const EdgeInsets.only(top: AppSpacing.p8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final s = suggestions[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.p8),
            child: GestureDetector(
              onTap: () => _sendMessage(s),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.p16, vertical: AppSpacing.p12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: (isDark ? AppColors.darkBorder : AppColors.border)
                          .withValues(alpha: 0.5)),
                ),
                child: Text(s,
                    style: AppTypography.labelMedium
                        .copyWith(color: AppColors.primary)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessage(ChatMessage message, bool isDark) {
    final isAI = message.role == MessageRole.ai;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.p24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAI) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.aiGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Iconsax.magic_star, color: Colors.white, size: 16),
            ),
            const SizedBox(width: AppSpacing.p12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.p16),
              decoration: BoxDecoration(
                color: isAI
                    ? (isDark ? AppColors.darkSurface : AppColors.surface)
                    : AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: Radius.circular(isAI ? 4 : 24),
                  bottomRight: Radius.circular(isAI ? 24 : 4),
                ),
                border: isAI
                    ? Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border)
                    : null,
                boxShadow: isAI
                    ? [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ]
                    : [
                        BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8))
                      ],
              ),
              child: message.isTyping
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.primary),
                        ),
                        const SizedBox(width: AppSpacing.p8),
                        Text('Analyzing Profile...',
                            style: AppTypography.labelMedium
                                .copyWith(color: AppColors.primary)),
                      ],
                    )
                  : Text(
                      message.text,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isAI
                            ? (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary)
                            : Colors.white,
                        height: 1.5,
                      ),
                    ),
            ),
          ),
          if (!isAI) ...[
            const SizedBox(width: AppSpacing.p12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: const Icon(Iconsax.user,
                  color: AppColors.textSecondary, size: 16),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fade()
        .slideY(begin: 0.1, duration: 300.ms, curve: Curves.easeOutQuart);
  }

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.p16,
        right: AppSpacing.p16,
        top: AppSpacing.p16,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.p16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
            top: BorderSide(
                color: (isDark ? AppColors.darkBorder : AppColors.border)
                    .withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          AppIconButton(
            icon: Iconsax.paperclip,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () {
              setState(() => _selectedContext = 'Application & Resume Context');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Context attached to next query'),
                    backgroundColor: AppColors.primary),
              );
            },
          ),
          const SizedBox(width: AppSpacing.p12),
          Expanded(
            child: AppTextField(
              controller: _controller,
              hintText: 'Ask Strategist...',
            ),
          ),
          const SizedBox(width: AppSpacing.p12),
          AppIconButton(
            icon: Iconsax.send_1,
            isFilled: true,
            backgroundColor: AppColors.primary,
            color: Colors.white,
            onPressed: () => _sendMessage(),
          ),
        ],
      ),
    );
  }
}
