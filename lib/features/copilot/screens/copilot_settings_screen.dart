import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';

class CopilotSettingsScreen extends StatelessWidget {
  const CopilotSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Preferences & Settings'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preferences', style: AppTypography.subheading),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Iconsax.language_square,
                        color: AppColors.primary),
                    title: Text('Primary Language', style: AppTypography.label),
                    trailing: Text('English', style: AppTypography.caption),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Iconsax.cpu, color: AppColors.primary),
                    title:
                        Text('AI Engine Provider', style: AppTypography.label),
                    trailing:
                        Text('Gemini Flash 1.5', style: AppTypography.caption),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
