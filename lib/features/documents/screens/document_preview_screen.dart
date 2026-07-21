import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/documents_provider.dart';
import '../models/document_model.dart';

class DocumentPreviewScreen extends ConsumerWidget {
  final String documentId;

  const DocumentPreviewScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(documentsProvider);
    final document = documents.firstWhere((d) => d.id == documentId, orElse: () => documents.first);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Document Preview', style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Iconsax.share, color: AppColors.textPrimary), onPressed: () {}),
          IconButton(icon: const Icon(Iconsax.more, color: AppColors.textPrimary), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreviewArea(document),
            _buildMetadata(document),
            _buildAIAnalysis(document),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.document_download, color: Colors.white),
        label: Text('Download', style: AppTypography.button.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildPreviewArea(AppDocument document) {
    return Container(
      width: double.infinity,
      height: 400,
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          document.previewUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(child: Icon(Iconsax.document, size: 64, color: Colors.grey)),
        ),
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
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  document.category,
                  style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Text('${document.size} • Uploaded ${document.uploadDate}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildAIAnalysis(AppDocument document) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Text('AI Verification', style: AppTypography.title),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildAnalysisRow('Verification Status', document.status.name.toUpperCase(), document.status == DocumentStatus.verified ? AppColors.success : AppColors.warning),
                const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                _buildAnalysisRow('OCR Readability', '${document.aiAnalysis.readabilityScore}%', AppColors.textPrimary),
                const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                _buildAnalysisRow('Image Resolution', '${document.aiAnalysis.resolutionScore}%', AppColors.textPrimary),
                if (document.aiAnalysis.recommendations.isNotEmpty) ...[
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recommendations', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      ...document.aiAnalysis.recommendations.map((rec) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: AppColors.textSecondary)),
                                Expanded(child: Text(rec, style: AppTypography.caption)),
                              ],
                            ),
                          )),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildAnalysisRow(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTypography.label.copyWith(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
