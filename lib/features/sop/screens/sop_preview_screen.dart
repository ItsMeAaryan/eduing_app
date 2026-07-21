import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/sop_provider.dart';

class SopPreviewScreen extends ConsumerWidget {
  const SopPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sop = ref.watch(sopProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('SOP Preview', style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.magic_star, color: AppColors.primary),
            onPressed: () => context.push('/sop/review'),
          ),
          IconButton(
            icon: const Icon(Iconsax.export_1, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 15)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Statement of Purpose',
                    style: AppTypography.headline.copyWith(fontSize: 24, decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 32),
                ...sop.sections.where((s) => s.isCompleted && s.content.isNotEmpty).map((section) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      section.content,
                      style: AppTypography.body.copyWith(height: 1.8, fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                  );
                }),
              ],
            ),
          ).animate().fade().scale(begin: const Offset(0.95, 0.95)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/sop/review'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.scan, color: Colors.white),
        label: Text('AI Review', style: AppTypography.button.copyWith(color: Colors.white)),
      ),
    );
  }
}
