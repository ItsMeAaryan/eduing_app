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
import '../../../shared/components/organisms/university_card.dart';
import '../providers/universities_provider.dart';

class UniversitiesScreen extends ConsumerStatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  ConsumerState<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends ConsumerState<UniversitiesScreen> {
  final List<String> _filters = ['All', 'Engineering', 'Management', 'Sciences', 'Arts', 'Medical'];
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final universities = ref.watch(universitiesProvider);
    final notifier = ref.read(universitiesProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Premium Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.p24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Discover', style: AppTypography.display),
                      const SizedBox(height: AppSpacing.p4),
                      Text('Explore global universities.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: (isDark ? AppColors.darkBorder : AppColors.border).withOpacity(0.5)),
                    ),
                    child: const Icon(Iconsax.bookmark, size: 20),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
              child: AppTextField(
                controller: _searchController,
                hintText: 'Search universities, programs...',
                prefixIcon: Iconsax.search_normal,
                onChanged: (val) => notifier.filterByQuery(val),
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
                      onTap: () {
                        setState(() => _selectedFilter = filter);
                        notifier.filterByCategory(filter);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p16, vertical: AppSpacing.p12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColors.primary 
                              : (isDark ? AppColors.darkSurface : AppColors.surface),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.border).withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          filter,
                          style: AppTypography.labelMedium.copyWith(
                            color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: AppSpacing.p24),
            
            // Results Count & Sort
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${universities.length} Universities', style: AppTypography.titleMedium),
                  Row(
                    children: [
                      Text('Sort by Match', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                      const SizedBox(width: AppSpacing.p4),
                      const Icon(Iconsax.arrow_down_1, size: 16, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.p16),

            // University List
            Expanded(
              child: universities.isEmpty
                  ? _buildEmptyState(isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
                      itemCount: universities.length,
                      itemBuilder: (context, index) {
                        final uni = universities[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.p16),
                          child: GestureDetector(
                            onTap: () => context.push('/universities/details', extra: uni),
                            child: UniversityCard(
                              logoUrl: uni.logoUrl.isNotEmpty ? uni.logoUrl : 'https://placehold.co/100x100/png',
                              name: uni.name,
                              location: uni.location,
                              rank: uni.nirfRanking.toString(),
                            ),
                          ),
                        ).animate().fade().slideY(begin: 0.1, delay: (index * 50).ms);
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
              child: const Icon(Iconsax.search_normal_1, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.p24),
            Text('No Results Found', style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.p8),
            Text(
              'Try adjusting your search query or filters to find the right university for you.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.p32),
            AppButton(
              text: 'Reset Filters',
              onPressed: () {
                setState(() => _selectedFilter = 'All');
                _searchController.clear();
                ref.read(universitiesProvider.notifier).filterByQuery('');
                ref.read(universitiesProvider.notifier).filterByCategory('All');
              },
              icon: Iconsax.refresh,
            ),
          ],
        ),
      ),
    );
  }
}
