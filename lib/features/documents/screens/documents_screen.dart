import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../universities/widgets/filter_chip.dart';
import '../providers/documents_provider.dart';
import '../widgets/document_card.dart';
import '../models/document_model.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  final List<String> _filters = ['All', 'Academic', 'Identity', 'Financial', 'Certificates', 'Miscellaneous'];
  String _selectedFilter = 'All';

  Future<void> _handleFileSelection(BuildContext context, String source, String name, String category) async {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Uploading $name...'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Upload New Document', style: AppTypography.headline),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Document Title',
                      hintText: 'e.g. Passport Copy, Official Transcript',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: category,
                    items: ['Academic', 'Identity', 'Financial', 'Certificates', 'Miscellaneous']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => category = val);
                    },
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Select Attachment Source', style: AppTypography.subheading),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setModalState(() => source = 'file'),
                          icon: Icon(Iconsax.folder_add, color: source == 'file' ? AppColors.primary : Colors.grey),
                          label: Text('File', style: TextStyle(color: source == 'file' ? AppColors.primary : null)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: source == 'file' ? AppColors.primary : Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setModalState(() => source = 'gallery'),
                          icon: Icon(Iconsax.gallery, color: source == 'gallery' ? AppColors.primary : Colors.grey),
                          label: Text('Gallery', style: TextStyle(color: source == 'gallery' ? AppColors.primary : null)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: source == 'gallery' ? AppColors.primary : Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setModalState(() => source = 'camera'),
                          icon: Icon(Iconsax.camera, color: source == 'camera' ? AppColors.primary : Colors.grey),
                          label: Text('Camera', style: TextStyle(color: source == 'camera' ? AppColors.primary : null)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: source == 'camera' ? AppColors.primary : Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a document title.')),
                        );
                        return;
                      }
                      ctx.pop();
                      _handleFileSelection(context, source, name, category);
                    },
                    icon: const Icon(Iconsax.document_upload),
                    label: const Text('Select File & Upload'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showRenameModal(AppDocument doc) {
    final controller = TextEditingController(text: doc.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Document'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'New Title'),
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                ref.read(documentsNotifierProvider.notifier).renameDocument(doc.id, newName);
                ctx.pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(documentsNotifierProvider);

    final filteredDocuments = _selectedFilter == 'All'
        ? documents
        : documents.where((d) => d.category == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Vault'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: _showUploadModal,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadModal,
        icon: const Icon(Iconsax.document_upload),
        label: const Text('Upload Document'),
        backgroundColor: AppColors.primary,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stored Credentials & Application Documents',
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: AppFilterChip(
                            label: filter,
                            isSelected: _selectedFilter == filter,
                            onTap: () {
                              setState(() => _selectedFilter = filter);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (filteredDocuments.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.folder_cross, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    Text('No documents found', style: AppTypography.subheading),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the button below to upload your first document.',
                      style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final doc = filteredDocuments[index];
                    final progressState = ref.watch(activeUploadProgressProvider(doc.id));

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Stack(
                        children: [
                          DocumentCard(
                            document: doc,
                            onTap: () {
                              context.push('/documents/preview', extra: doc);
                            },
                            onDelete: () {
                              ref.read(documentsNotifierProvider.notifier).deleteDocument(doc.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Deleted ${doc.name}')),
                              );
                            },
                            onRename: () => _showRenameModal(doc),
                            onShare: () {
                              ref.read(documentsNotifierProvider.notifier).shareDocument(doc.id);
                            },
                          ),
                          if (progressState != null && !progressState.isCompleted)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(
                                        value: progressState.progress > 0 ? progressState.progress : null,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Uploading... ${(progressState.progress * 100).toInt()}%',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ).animate().fadeIn(duration: 200.ms),
                    );
                  },
                  childCount: filteredDocuments.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
