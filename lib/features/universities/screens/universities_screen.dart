import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/universities_provider.dart';
import '../widgets/filter_chip.dart';
import '../widgets/university_card.dart';

class UniversitiesScreen extends ConsumerStatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  ConsumerState<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends ConsumerState<UniversitiesScreen> {
  final List<String> _filters = ['All', 'Engineering', 'Management', 'Sciences', 'Arts', 'Medical', 'More'];
  String _selectedFilter = 'All';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final universities = ref.watch(universitiesProvider);
    final notifier = ref.read(universitiesProvider.notifier);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(notifier),
            _buildFilters(notifier),
            _buildResultsHeader(universities.length),
            Expanded(
              child: universities.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: universities.length,
                      itemBuilder: (context, index) {
                        final uni = universities[index];
                        return AppUniversityCard(
                          university: uni,
                          onFavoriteToggle: () => notifier.toggleFavorite(uni.id),
                        );
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Universities',
                style: AppTypography.headline,
              ),
              const SizedBox(height: 4),
              Text(
                'Discover and compare the best universities for your future.',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(Iconsax.notification, size: 24),
              ),
              const SizedBox(width: 12),
              const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(UniversitiesNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => notifier.filterByQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search universities, courses...',
                  hintStyle: AppTypography.body.copyWith(color: AppColors.textSecondary, fontSize: 14),
                  icon: const Icon(Iconsax.search_normal, color: AppColors.textSecondary, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            notifier.filterByQuery('');
                            setState(() {});
                          },
                        )
                      : const Icon(Iconsax.microphone, color: AppColors.textSecondary, size: 20),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.filter, color: AppColors.textPrimary, size: 20),
                const SizedBox(width: 8),
                Text('Filters', style: AppTypography.label),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(UniversitiesNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 24),
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
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
                notifier.filterByCategory(filter);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultsHeader(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Iconsax.magic_star, color: AppColors.textSecondary, size: 16),
              const SizedBox(width: 8),
              Text('$count universities found', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          Row(
            children: [
              Text('Sort by: AI Match', style: AppTypography.label.copyWith(fontSize: 12)),
              const Icon(Iconsax.arrow_down_1, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.search_normal_1, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No universities found.', style: AppTypography.title),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms.',
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedFilter = 'All';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }
}
