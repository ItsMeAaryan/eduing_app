import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/atoms/app_text_field.dart';
import '../../../shared/components/atoms/app_button.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../providers/documents_provider.dart';
import '../widgets/document_card.dart';
import '../models/document_model.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  final List<String> _filters = [
    'All',
    'Academic',
    'Identity',
    'Financial',
    'Certificates'
  ];
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  Future<void> _handleFileSelection(
      BuildContext context, String source, String name, String category) async {
    final storageService = ref.read(documentStorageServiceProvider);
    File? selectedFile;

    try {
      if (source == 'file') {
        selectedFile = await storageService.pickDocumentFile();
      } else if (source == 'gallery') {
        selectedFile = await storageService.pickImageFromGallery();
      } else if (source == 'camera') {
        selectedFile = await storageService.captureImageFromCamera();
      }

      if (selectedFile != null) {
        await ref.read(documentsNotifierProvider.notifier).uploadDocumentFile(
              file: selectedFile,
              name: name,
              category: category,
            );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Uploading $name...'),
              backgroundColor: AppColors.primary));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()), backgroundColor: AppColors.error));
      }
    }
  }

  void _showUploadModal() {
    final nameController = TextEditingController();
    String category = 'Academic';
    String source = 'file';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 32,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Upload Document', style: AppTypography.titleLarge),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: nameController,
                    hintText: 'Document Name (e.g. Passport)',
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    items: _filters
                        .where((f) => f != 'All')
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => category = val);
                    },
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _UploadSourceButton(
                          icon: Iconsax.folder_add,
                          label: 'File',
                          isSelected: source == 'file',
                          onTap: () => setModalState(() => source = 'file'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _UploadSourceButton(
                          icon: Iconsax.gallery,
                          label: 'Gallery',
                          isSelected: source == 'gallery',
                          onTap: () => setModalState(() => source = 'gallery'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _UploadSourceButton(
                          icon: Iconsax.camera,
                          label: 'Camera',
                          isSelected: source == 'camera',
                          onTap: () => setModalState(() => source = 'camera'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    text: 'Select & Upload',
                    icon: Iconsax.document_upload,
                    onPressed: () {
                      if (nameController.text.isEmpty) return;
                      ctx.pop();
                      _handleFileSelection(context, source,
                          nameController.text.trim(), category);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(documentsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredDocuments = _selectedFilter == 'All'
        ? documents
        : documents.where((d) => d.category == _selectedFilter).toList();

    final verifiedCount =
        documents.where((d) => d.status == DocumentStatus.verified).length;
    final pendingCount =
        documents.where((d) => d.status == DocumentStatus.pending).length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadModal,
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.add, color: Colors.white),
        label: Text('Upload',
            style: AppTypography.labelLarge.copyWith(color: Colors.white)),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Floating Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.p24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Secure Vault', style: AppTypography.display),
                      const SizedBox(height: AppSpacing.p4),
                      Text('${documents.length} Total Documents',
                          style: AppTypography.bodyMedium
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  AppIconButton(
                    icon: Iconsax.shield_tick,
                    isFilled: true,
                    backgroundColor:
                        isDark ? AppColors.darkSurface : AppColors.surface,
                    color: AppColors.success,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
              child: AppTextField(
                controller: _searchController,
                hintText: 'Search documents...',
                prefixIcon: Iconsax.search_normal,
              ),
            ),

            const SizedBox(height: AppSpacing.p24),

            // Summary Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
              child: Row(
                children: [
                  _SummaryChip(
                      label: 'Verified',
                      count: verifiedCount.toString(),
                      color: AppColors.success),
                  const SizedBox(width: AppSpacing.p12),
                  _SummaryChip(
                      label: 'Pending Review',
                      count: pendingCount.toString(),
                      color: AppColors.warning),
                  const SizedBox(width: AppSpacing.p12),
                  const _SummaryChip(
                      label: 'Missing',
                      count: '2',
                      color: AppColors.error), // Mock missing count
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.p24),

            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.p12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.p16,
                            vertical: AppSpacing.p8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.border)),
                        ),
                        child: Text(
                          filter,
                          style: AppTypography.labelMedium.copyWith(
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: AppSpacing.p16),

            // Content
            Expanded(
              child: filteredDocuments.isEmpty
                  ? _buildEmptyState(isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.p24, vertical: AppSpacing.p8),
                      itemCount: filteredDocuments.length,
                      itemBuilder: (context, index) {
                        final doc = filteredDocuments[index];
                        final progressState =
                            ref.watch(activeUploadProgressProvider)[doc.id];

                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.p16),
                          child: Stack(
                            children: [
                              DocumentCard(
                                document: doc,
                                onTap: () => context.push('/documents/preview',
                                    extra: doc),
                                onDelete: () => ref
                                    .read(documentsNotifierProvider.notifier)
                                    .deleteDocument(doc.id),
                                onRename:
                                    () {}, // Handled directly inside preview typically, or add modal
                                onShare: () => ref
                                    .read(documentsNotifierProvider.notifier)
                                    .shareDocument(doc.id),
                              ),
                              if (progressState != null &&
                                  !progressState.isCompleted)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: (isDark
                                              ? AppColors.darkBackground
                                              : AppColors.background)
                                          .withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: progressState.progress > 0
                                            ? progressState.progress
                                            : null,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )
                              .animate()
                              .fade()
                              .slideY(begin: 0.1, delay: (index * 50).ms),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.folder_add,
                  size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.p24),
            Text('No Documents Found', style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.p8),
            Text(
              'Upload your first document to secure it in your vault.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _SummaryChip(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p16, vertical: AppSpacing.p12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              count,
              style: AppTypography.labelLarge
                  .copyWith(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: AppSpacing.p12),
          Text(label,
              style: AppTypography.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _UploadSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _UploadSourceButton(
      {required this.icon,
      required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label, style: AppTypography.caption.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
