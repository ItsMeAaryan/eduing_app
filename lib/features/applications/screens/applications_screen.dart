import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../universities/widgets/filter_chip.dart';
import '../providers/applications_provider.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  final List<String> _filters = ['All', 'Draft', 'Submitted', 'Review', 'Accepted', 'Rejected'];
  String _selectedFilter = 'All';

  void _showAddApplicationDialog() {
    final uniController = TextEditingController();
    final courseController = TextEditingController();
    final deadlineController = TextEditingController(text: '01 Dec 2025');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Create New Application', style: AppTypography.headline),
              const SizedBox(height: 16),
              TextField(
                controller: uniController,
                decoration: const InputDecoration(labelText: 'University Name', hintText: 'e.g. Oxford University'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: courseController,
                decoration: const InputDecoration(labelText: 'Degree / Course', hintText: 'e.g. M.Sc. Data Science'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deadlineController,
                decoration: const InputDecoration(labelText: 'Application Deadline'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  final uniName = uniController.text.trim();
                  final course = courseController.text.trim();
                  if (uniName.isEmpty || course.isEmpty) return;

                  ref.read(applicationsNotifierProvider.notifier).createApplication(
                        universityName: uniName,
                        course: course,
                        deadline: deadlineController.text.trim(),
                      );
                  ctx.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Created application for $uniName')),
                  );
                },
                icon: const Icon(Iconsax.add_circle),
                label: const Text('Add Application'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationsNotifierProvider);

    final filteredApps = _selectedFilter == 'All'
        ? applications
        : applications.where((a) => a.status.name.toLowerCase() == _selectedFilter.toLowerCase()).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: _showAddApplicationDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddApplicationDialog,
        icon: const Icon(Iconsax.add),
        label: const Text('New Application'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
          ),
          Expanded(
            child: filteredApps.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.folder_cross, size: 64, color: AppColors.textSecondary),
                        const SizedBox(height: 16),
                        Text('No applications found', style: AppTypography.subheading),
                        const SizedBox(height: 8),
                        Text('Tap + to start tracking a new university application.', style: AppTypography.caption),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredApps.length,
                    itemBuilder: (context, index) {
                      final app = filteredApps[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          onTap: () {
                            context.push('/applications/details', extra: app);
                          },
                          title: Text(app.university.name, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold)),
                          subtitle: Text('${app.course} • Deadline: ${app.deadline}', style: AppTypography.caption),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              app.status.name.toUpperCase(),
                              style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                        ),
                      ).animate().fade().slideY(begin: 0.05);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
