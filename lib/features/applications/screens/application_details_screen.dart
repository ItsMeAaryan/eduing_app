import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/applications_provider.dart';
import '../models/university_application.dart';

class ApplicationDetailsScreen extends ConsumerStatefulWidget {
  final UniversityApplication? application;
  final String? applicationId;

  const ApplicationDetailsScreen({super.key, this.application, this.applicationId});

  @override
  ConsumerState<ApplicationDetailsScreen> createState() => _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState extends ConsumerState<ApplicationDetailsScreen> {
  void _showNotesDialog(UniversityApplication app) {
    final controller = TextEditingController(text: app.notes);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Application Notes'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'Add notes regarding interview, contact, or requirements...'),
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ref.read(applicationsNotifierProvider.notifier).updateNotes(app.id, controller.text);
              ctx.pop();
            },
            child: const Text('Save Notes'),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(UniversityApplication app) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Update Application Status'),
        children: ApplicationStatus.values.map((status) {
          return SimpleDialogOption(
            onPressed: () {
              ref.read(applicationsNotifierProvider.notifier).updateStatus(app.id, status);
              ctx.pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(status.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationsNotifierProvider);
    final app = widget.application ??
        (widget.applicationId != null
            ? applications.firstWhere(
                (a) => a.id == widget.applicationId,
                orElse: () => applications.first,
              )
            : (applications.isNotEmpty ? applications.first : null));

    if (app == null) {
      return Scaffold(
        appBar: AppBar(leading: IconButton(icon: const Icon(Iconsax.arrow_left), onPressed: () => context.pop())),
        body: const Center(child: Text('Application not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(app.university.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.trash, color: Colors.red),
            onPressed: () {
              ref.read(applicationsNotifierProvider.notifier).deleteApplication(app.id);
              context.pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderTile(app),
            const SizedBox(height: 16),
            _buildTimelineTile(app),
            const SizedBox(height: 16),
            _buildNotesTile(app),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTile(UniversityApplication app) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(app.university.name, style: AppTypography.headline),
          const SizedBox(height: 4),
          Text('${app.course} • Deadline: ${app.deadline}', style: AppTypography.caption),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status: ${app.status.name.toUpperCase()}', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
              OutlinedButton.icon(
                onPressed: () => _showStatusDialog(app),
                icon: const Icon(Iconsax.edit_2, size: 16),
                label: const Text('Change Status'),
              ),
            ],
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.05);
  }

  Widget _buildTimelineTile(UniversityApplication app) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Application Milestone Timeline', style: AppTypography.subheading),
          const SizedBox(height: 12),
          if (app.timeline.isEmpty)
            Text('No timeline stages created.', style: AppTypography.caption)
          else
            ...app.timeline.map(
              (stage) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      stage.isCompleted ? Iconsax.tick_circle : Iconsax.clock,
                      color: stage.isCompleted ? AppColors.success : AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(stage.title, style: AppTypography.body)),
                    Text(stage.date, style: AppTypography.caption),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesTile(UniversityApplication app) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Notes & Reminders', style: AppTypography.subheading),
              IconButton(
                icon: const Icon(Iconsax.edit, color: AppColors.primary),
                onPressed: () => _showNotesDialog(app),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            app.notes.isNotEmpty ? app.notes : 'No notes added. Tap edit to write application notes.',
            style: AppTypography.body,
          ),
        ],
      ),
    );
  }
}
