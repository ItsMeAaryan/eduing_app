import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../models/document_model.dart';

class DocumentCard extends StatelessWidget {
  final AppDocument document;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onRename;
  final VoidCallback? onShare;

  const DocumentCard({
    super.key,
    required this.document,
    required this.onTap,
    this.onDelete,
    this.onRename,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.p16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getCategoryColor(document.category).withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(_getCategoryIcon(document.category),
                  color: _getCategoryColor(document.category), size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style: AppTypography.label
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(document.size,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textSecondary)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: CircleAvatar(
                            radius: 2,
                            backgroundColor: AppColors.textSecondary),
                      ),
                      Text(document.uploadDate,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(document.status)
                              .withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          document.status.name.toUpperCase(),
                          style: AppTypography.caption.copyWith(
                            color: _getStatusColor(document.status),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (document.expiryDate != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Exp: ${document.expiryDate}',
                            style: AppTypography.caption.copyWith(
                                color: AppColors.error,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Iconsax.more, color: AppColors.textSecondary),
              onSelected: (val) {
                if (val == 'rename' && onRename != null) onRename!();
                if (val == 'share' && onShare != null) onShare!();
                if (val == 'delete' && onDelete != null) onDelete!();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 'rename',
                    child: Row(children: [
                      Icon(Iconsax.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Rename')
                    ])),
                const PopupMenuItem(
                    value: 'share',
                    child: Row(children: [
                      Icon(Iconsax.share, size: 18),
                      SizedBox(width: 8),
                      Text('Share')
                    ])),
                const PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Iconsax.trash, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red))
                    ])),
              ],
            ),
          ],
        ),
      ),
    ).animate().fade().slideY(begin: 0.05);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Academic':
        return AppColors.primary;
      case 'Identity':
        return AppColors.secondary;
      case 'Financial':
        return Colors.amber;
      case 'Certificates':
        return Colors.teal;
      default:
        return Colors.purple;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Iconsax.teacher;
      case 'Identity':
        return Iconsax.personalcard;
      case 'Financial':
        return Iconsax.wallet;
      case 'Certificates':
        return Iconsax.award;
      default:
        return Iconsax.folder;
    }
  }

  Color _getStatusColor(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.verified:
        return AppColors.success;
      case DocumentStatus.pending:
        return Colors.orange;
      case DocumentStatus.rejected:
        return AppColors.error;
    }
  }
}
