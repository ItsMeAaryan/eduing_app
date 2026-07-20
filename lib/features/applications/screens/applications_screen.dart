import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../universities/widgets/filter_chip.dart';
import '../providers/applications_provider.dart';
import '../widgets/application_card.dart';
import '../models/university_application.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  final List<String> _filters = ['All', 'Draft', 'Submitted', 'Review', 'Accepted', 'Rejected', 'Interview'];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationsProvider);

    final filteredApps = _selectedFilter == 'All' 
        ? applications 
        : applications.where((a) => a.statusDisplay == _selectedFilter || a.status.name.toLowerCase() == _selectedFilter.toLowerCase()).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildStats(applications),
            _buildSearchBar(),
            _buildFilters(),
            Expanded(
              child: filteredApps.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: filteredApps.length + 1,
                      itemBuilder: (context, index) {
                        if (index == filteredApps.length) return const SizedBox(height: 100);
                        return AppApplicationCard(application: filteredApps[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Applications', style: AppTypography.headline),
              const SizedBox(height: 4),
              Text('Track all your university applications.', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(Iconsax.add, size: 24, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(List<UniversityApplication> applications) {
    final submitted = applications.where((a) => a.status != ApplicationStatus.draft).length;
    final accepted = applications.where((a) => a.status == ApplicationStatus.accepted).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _buildStatCard('Total\nStarted', applications.length.toString(), Iconsax.folder_open),
          const SizedBox(width: 12),
          _buildStatCard('Submitted', submitted.toString(), Iconsax.send_2, color: AppColors.primary),
          const SizedBox(width: 12),
          _buildStatCard('Accepted', accepted.toString(), Iconsax.tick_circle, color: AppColors.success),
        ],
      ),
    ).animate().fade().slideY(begin: -0.1);
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
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
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
                'Search applications...',
                style: AppTypography.body.copyWith(color: AppColors.textSecondary, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    ).animate().fade().slideY(begin: -0.1);
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
          Text('No Applications Yet', style: AppTypography.title),
          const SizedBox(height: 8),
          Text(
            'Browse universities and start applying.',
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
            child: const Text('Browse Universities'),
          ),
        ],
      ),
    ).animate().fade().scale();
  }
}
