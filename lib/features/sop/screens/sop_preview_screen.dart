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
      appBar: AppBar(
        title: Text('${sop.universityName} SOP', style: AppTypography.title.copyWith(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.share, color: AppColors.primary),
            onPressed: () async {
              await ref.read(sopProvider.notifier).shareSopPdf();
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.printer, color: AppColors.primary),
            onPressed: () async {
              await ref.read(sopProvider.notifier).printSopPdf();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 600),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'STATEMENT OF PURPOSE',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 4),
              Text(
                'Target Program: ${sop.targetProgram} — ${sop.universityName}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
              ),
              const Divider(height: 24, thickness: 1.5),
              Text(
                sop.fullContent,
                style: const TextStyle(fontSize: 12, height: 1.6, color: Colors.black87),
              ),
            ],
          ),
        ).animate().fade().scale(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final file = await ref.read(sopProvider.notifier).exportSopPdf();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('SOP PDF exported to ${file.path}')),
            );
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.document_download, color: Colors.white),
        label: Text('Export PDF', style: AppTypography.button.copyWith(color: Colors.white)),
      ),
    );
  }
}
