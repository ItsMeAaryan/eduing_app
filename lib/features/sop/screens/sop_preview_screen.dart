import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../providers/sop_provider.dart';

class SopPreviewScreen extends ConsumerWidget {
  const SopPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sop = ref.watch(sopProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final file = await ref.read(sopProvider.notifier).exportSopPdf();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('SOP PDF exported to ${file.path}'),
                  backgroundColor: AppColors.success),
            );
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.document_download, color: Colors.white),
        label: Text('Export PDF',
            style: AppTypography.labelLarge.copyWith(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.p24, 0, AppSpacing.p24, 100),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 800),
                    margin: const EdgeInsets.only(top: AppSpacing.p16),
                    padding: const EdgeInsets.all(AppSpacing.p32),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 15)),
                      ],
                      border: Border.all(
                          color:
                              (isDark ? AppColors.darkBorder : AppColors.border)
                                  .withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STATEMENT OF PURPOSE',
                          style: AppTypography.titleLarge.copyWith(
                              letterSpacing: 2, color: AppColors.primary),
                        ),
                        const SizedBox(height: AppSpacing.p8),
                        Text(
                          'Target Program: ${sop.targetProgram} — ${sop.universityName}',
                          style: AppTypography.labelMedium
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.p24),
                        Divider(
                            height: 1,
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.border),
                        const SizedBox(height: AppSpacing.p32),
                        Text(
                          sop.fullContent,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 15,
                            height: 1.8,
                            color:
                                isDark ? Colors.grey.shade300 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().scale(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isDark) {
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
              'Print Preview',
              style: AppTypography.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppIconButton(
            icon: Iconsax.share,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () => ref.read(sopProvider.notifier).shareSopPdf(),
          ),
          const SizedBox(width: AppSpacing.p12),
          AppIconButton(
            icon: Iconsax.printer,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () => ref.read(sopProvider.notifier).printSopPdf(),
          ),
        ],
      ),
    );
  }
}
