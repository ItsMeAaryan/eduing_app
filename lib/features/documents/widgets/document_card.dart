import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../models/document_model.dart';

class AppDocumentCard extends StatelessWidget {
  final AppDocument document;

  const AppDocumentCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/document/${document.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getCategoryColor(document.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(_getCategoryIcon(document.category), color: _getCategoryColor(document.category), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(document.name, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(document.size, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: CircleAvatar(radius: 2, backgroundColor: AppColors.textSecondary),
                      ),
                      Text(document.uploadDate, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(document.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          document.status.name.toUpperCase(),
                          style: AppTypography.caption.copyWith(color: _getStatusColor(document.status), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (document.expiryDate != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Exp: ${document.expiryDate}',
                            style: AppTypography.caption.copyWith(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Iconsax.more, color: AppColors.textSecondary),
          ],
        ),
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Academic': return AppColors.primary;
      case 'Identity': return AppColors.secondary;
      case 'Financial': return AppColors.success;
      case 'Certificates': return AppColors.warning;
      default: return AppColors.textPrimary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic': return Iconsax.book;
      case 'Identity': return Iconsax.personalcard;
      case 'Financial': return Iconsax.bank;
      case 'Certificates': return Iconsax.award;
      default: return Iconsax.document;
    }
  }

  Color _getStatusColor(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.verified: return AppColors.success;
      case DocumentStatus.pending: return AppColors.warning;
      case DocumentStatus.rejected: return AppColors.error;
    }
  }
}
