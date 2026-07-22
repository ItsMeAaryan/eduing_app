import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(targetDoc.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.share),
            onPressed: () {
              ref.read(documentsNotifierProvider.notifier).shareDocument(targetDoc.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreviewArea(targetDoc),
            _buildMetadata(targetDoc),
            _buildAIAnalysis(targetDoc),
          ],
        ),
      ),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Downloaded to ${downloadedFile.path}')),
                );
              }
            } else if (targetDoc.localPath != null && File(targetDoc.localPath!).existsSync()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Local file available at ${targetDoc.localPath}')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download failed: $e')),
              );
            }
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.document_download, color: Colors.white),
        label: Text('Download File', style: AppTypography.button.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildPreviewArea(AppDocument document) {
    Widget childWidget;

    if (document.localPath != null && File(document.localPath!).existsSync()) {
      final ext = document.localPath!.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png'].contains(ext)) {
        childWidget = Image.file(File(document.localPath!), fit: BoxFit.cover);
      } else {
        childWidget = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.document_text, size: 64, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(document.name, style: AppTypography.subheading),
              Text('Local File: ${document.localPath}', style: AppTypography.caption),
            ],
          ),
        );
      }
    } else if (document.previewUrl.isNotEmpty) {
      childWidget = Image.network(
        document.previewUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.document, size: 64, color: Colors.grey),
              SizedBox(height: 8),
              Text('Document Preview'),
            ],
          ),
        ),
      );
    } else {
      childWidget = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.document_upload, size: 64, color: AppColors.primary),
            SizedBox(height: 12),
            Text('Document Uploaded'),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 360,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: childWidget,
      ),
    ).animate().fade().scale();
  }

  Widget _buildMetadata(AppDocument document) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(document.name, style: AppTypography.headline),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  document.category,
                  style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Text('${document.size} • Uploaded ${document.uploadDate}', style: AppTypography.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIAnalysis(AppDocument document) {
    final analysis = document.aiAnalysis;
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.cpu, color: AppColors.primary),
              const SizedBox(width: 10),
              Text('AI Document Audit', style: AppTypography.subheading.copyWith(color: AppColors.primary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${document.aiQualityScore}% Quality',
                  style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            analysis.recommendations.isNotEmpty
                ? analysis.recommendations.first
                : 'Document legibility and resolution satisfy standard university submission guidelines.',
            style: AppTypography.body,
          ),
        ],
      ),
    );
  }
}
