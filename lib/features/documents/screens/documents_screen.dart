import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../universities/widgets/filter_chip.dart';
import '../providers/documents_provider.dart';
import '../widgets/document_card.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  final List<String> _filters = ['All', 'Academic', 'Identity', 'Financial', 'Certificates', 'Miscellaneous'];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(documentsProvider);

    final filteredDocs = _selectedFilter == 'All'
        ? documents
        : documents.where((d) => d.category == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            _buildAIHealthCard(),
            _buildStats(),
            _buildSearchBar(),
            _buildFilters(),
            Expanded(
              child: filteredDocs.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: filteredDocs.length + 1,
                      itemBuilder: (context, index) {
                        if (index == filteredDocs.length) return const SizedBox(height: 100);
                        return AppDocumentCard(document: filteredDocs[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.document_upload, color: Colors.white),
        label: Text('Upload', style: AppTypography.button.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Document Vault', style: AppTypography.headline),
                  const SizedBox(height: 4),
                  Text('Manage your admissions documents securely.', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Iconsax.scan, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildAIHealthCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text('Document Health', style: AppTypography.title.copyWith(color: Colors.white)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                child: Text('92% Verified', style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 2.seconds),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularIndicator('Completion', 0.8),
              _buildCircularIndicator('Verification', 0.92),
              _buildCircularIndicator('AI Readiness', 0.85),
            ],
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildCircularIndicator(String label, double value) {
    return Column(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                backgroundColor: Colors.white24,
                color: Colors.white,
                strokeWidth: 4,
              ),
              Center(
                child: Text(
                  '${(value * 100).toInt()}%',
                  style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTypography.caption.copyWith(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        children: [
          _buildStatCard('Uploaded', '12', Iconsax.document_upload),
          const SizedBox(width: 12),
          _buildStatCard('Pending', '3', Iconsax.document_1, color: AppColors.warning),
          const SizedBox(width: 12),
          _buildStatCard('Verified', '9', Iconsax.verify, color: AppColors.success),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildStatCard(String title, String value, IconData icon, {Color color = AppColors.textPrimary}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 12),
            Text(value, style: AppTypography.headline.copyWith(fontSize: 24, color: color)),
            const SizedBox(height: 4),
            Text(title, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.search_normal, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search documents...',
                style: AppTypography.body.copyWith(color: AppColors.textSecondary, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    ).animate().fade().slideY(begin: 0.1);
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            final filter = _filters[index];
            return AppFilterChip(
              label: filter,
              isSelected: _selectedFilter == filter,
              onTap: () => setState(() => _selectedFilter = filter),
            );
          },
        ),
      ),
    ).animate().fade().slideX();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.document_text_1, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No Documents Found', style: AppTypography.title),
          const SizedBox(height: 8),
          Text(
            'Upload documents to securely store them.',
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Upload Document'),
          ),
        ],
      ),
    ).animate().fade().scale();
  }
}
