import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/molecules/squircle_card.dart';

import '../../../shared/components/atoms/app_icon_button.dart';
import '../providers/documents_provider.dart';
import '../models/document_model.dart';

class DocumentPreviewScreen extends ConsumerWidget {
  final AppDocument? document;
  final String? documentId;

  const DocumentPreviewScreen({
    super.key,
    this.document,
    this.documentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(documentsNotifierProvider);
    final targetDoc = document ??
        documents.firstWhere(
          (d) => d.id == documentId,
          orElse: () => documents.isNotEmpty
              ? documents.first
              : const AppDocument(
                  id: 'unknown',
                  name: 'Document',
                  category: 'General',
                  size: '0 KB',
                  uploadDate: '',
                  status: DocumentStatus.pending,
                  aiQualityScore: 80,
                  previewUrl: '',
                ),
        );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final storageService = ref.read(documentStorageServiceProvider);
          try {
            if (targetDoc.previewUrl.isNotEmpty) {
              final downloadedFile = await storageService.downloadDocument(
                targetDoc.previewUrl,
                '${targetDoc.name.replaceAll(' ', '_')}.pdf',
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloaded to ${downloadedFile.path}'), backgroundColor: AppColors.success));
              }
            } else if (targetDoc.localPath != null && File(targetDoc.localPath!).existsSync()) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Local file available at ${targetDoc.localPath}')));
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Download failed: $e'), backgroundColor: AppColors.error));
            }
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.document_download, color: Colors.white),
        label: Text('Download', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref, targetDoc, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPreviewArea(targetDoc, isDark),
                    _buildMetadata(targetDoc, isDark),
                    _buildAIAnalysis(targetDoc, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, AppDocument targetDoc, bool isDark) {
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
              targetDoc.name,
              style: AppTypography.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppIconButton(
            icon: Iconsax.share,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () => ref.read(documentsNotifierProvider.notifier).shareDocument(targetDoc.id),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewArea(AppDocument document, bool isDark) {
    Widget childWidget;

    if (document.localPath != null && File(document.localPath!).existsSync()) {
      final ext = document.localPath!.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png'].contains(ext)) {
        childWidget = Image.file(File(document.localPath!), fit: BoxFit.cover);
      } else {
        childWidget = _buildPlaceholder(document.name, 'Local File: ${document.localPath}');
      }
    } else if (document.previewUrl.isNotEmpty) {
      childWidget = Image.network(
        document.previewUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder('Document Preview', 'Tap to download'),
      );
    } else {
      childWidget = _buildPlaceholder('Document Uploaded', 'Processing preview...');
    }

    return Container(
      width: double.infinity,
      height: 360,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: childWidget,
      ),
    ).animate().fade().scale();
  }
  
  Widget _buildPlaceholder(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.document_text, size: 64, color: AppColors.primary),
          const SizedBox(height: AppSpacing.p16),
          Text(title, style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p8),
          Text(subtitle, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildMetadata(AppDocument document, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.p24, AppSpacing.p32, AppSpacing.p24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Details', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p16),
          SquircleCard(
            padding: const EdgeInsets.all(AppSpacing.p20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p12, vertical: AppSpacing.p8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    document.category,
                    style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  '${document.size} • ${document.uploadDate}',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildAIAnalysis(AppDocument document, bool isDark) {
    final analysis = document.aiAnalysis;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.p24, AppSpacing.p32, AppSpacing.p24, 0),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.p24),
        decoration: BoxDecoration(
          gradient: AppColors.aiGradient,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Iconsax.magic_star, color: Colors.white, size: 24),
                const SizedBox(width: AppSpacing.p12),
                Text('AI Document Audit', style: AppTypography.titleLarge.copyWith(color: Colors.white)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${document.aiQualityScore}% Quality',
                    style: AppTypography.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.p24),
            Text(
              analysis.recommendations.isNotEmpty
                  ? analysis.recommendations.first
                  : 'Document legibility and resolution satisfy standard university submission guidelines.',
              style: AppTypography.bodyMedium.copyWith(color: Colors.white.withOpacity(0.9), height: 1.5),
            ),
          ],
        ),
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }
}
