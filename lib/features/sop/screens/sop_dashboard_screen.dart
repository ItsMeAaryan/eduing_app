import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../providers/sop_provider.dart';
import '../models/sop_model.dart';

class SopDashboardScreen extends ConsumerStatefulWidget {
  const SopDashboardScreen({super.key});

  @override
  ConsumerState<SopDashboardScreen> createState() => _SopDashboardScreenState();
}

class _SopDashboardScreenState extends ConsumerState<SopDashboardScreen> {
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sop = ref.read(sopProvider);
      if (sop.fullContent.isNotEmpty) {
        _contentController.text = sop.fullContent;
      } else {
        _contentController.text = '''# Hook
[Write your opening statement here...]

# Academic Background
[Discuss your undergraduate studies and key projects...]

# Professional Experience
[Highlight internships, jobs, and relevant skills...]

# Why This University
[Explain why this specific program and faculty match your goals...]

# Conclusion
[Summarize your readiness and future vision...]''';
      }
    });

    _focusNode.addListener(() {
      setState(() {
        _isEditing = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveContent() {
    ref.read(sopProvider.notifier).updateContent(_contentController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('SOP saved securely.'),
          backgroundColor: AppColors.success),
    );
  }

  void _showAIAssistMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          margin: const EdgeInsets.all(AppSpacing.p24),
          padding: const EdgeInsets.all(AppSpacing.p16),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.darkSurface : Colors.white)
                .withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('AI Writing Assist', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.p16),
              _buildAIAction(
                  icon: Iconsax.edit_2,
                  title: 'Fix Grammar & Tone',
                  onTap: () async {
                    ctx.pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('AI is polishing your text...')));
                    await ref.read(sopProvider.notifier).improveSopWithAI();
                    _contentController.text = ref.read(sopProvider).fullContent;
                  }),
              const SizedBox(height: AppSpacing.p8),
              _buildAIAction(
                  icon: Iconsax.maximize_4,
                  title: 'Expand Current Paragraph',
                  onTap: () {
                    ctx.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Expanding context...')));
                  }),
              const SizedBox(height: AppSpacing.p8),
              _buildAIAction(
                  icon: Iconsax.brush_2,
                  title: 'Rewrite (More Professional)',
                  onTap: () {
                    ctx.pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Rewriting professionally...')));
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAIAction(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.p16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: AppSpacing.p12),
            Text(title,
                style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sop = ref.watch(sopProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: _isEditing
          ? null
          : FloatingActionButton.extended(
              onPressed: _showAIAssistMenu,
              backgroundColor: AppColors.primary,
              icon: const Icon(Iconsax.magic_star, color: Colors.white),
              label: Text('AI Assist',
                  style:
                      AppTypography.labelLarge.copyWith(color: Colors.white)),
            ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(sop, isDark),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.p32),
                    child: TextField(
                      controller: _contentController,
                      focusNode: _focusNode,
                      maxLines: null,
                      expands: true,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 18,
                        height: 1.8,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Start writing your Statement of Purpose...',
                      ),
                      onChanged: (_) {
                        // Auto-save logic could go here
                      },
                    ),
                  ),

                  // Distraction-free gradient fades
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).scaffoldBackgroundColor,
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Theme.of(context).scaffoldBackgroundColor,
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withValues(alpha: 0),
                          ],
                        ),
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

  Widget _buildHeader(UserSop sop, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.p16, AppSpacing.p16, AppSpacing.p16, AppSpacing.p24),
      child: Row(
        children: [
          AppIconButton(
            icon: Iconsax.arrow_left_2,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () {
              _saveContent();
              context.pop();
            },
          ),
          const SizedBox(width: AppSpacing.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sop.targetProgram,
                    style: AppTypography.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('${sop.universityName} • ${sop.wordCount} words',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          AppIconButton(
            icon: Iconsax.eye,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () {
              _saveContent();
              context.push('/sop/preview');
            },
          ),
          const SizedBox(width: AppSpacing.p12),
          AppIconButton(
            icon: Iconsax.tick_circle,
            isFilled: true,
            backgroundColor: AppColors.success.withValues(alpha: 0.1),
            color: AppColors.success,
            onPressed: _saveContent,
          ),
        ],
      ),
    );
  }
}
