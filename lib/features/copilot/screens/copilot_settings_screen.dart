import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';

class CopilotSettingsScreen extends StatelessWidget {
  const CopilotSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('AI Settings',
            style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preferences', style: AppTypography.title),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Iconsax.language_square,
                        color: AppColors.primary),
                    title: Text('Language', style: AppTypography.label),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('English',
                            style: AppTypography.caption
                                .copyWith(color: AppColors.textSecondary)),
                        const Icon(Iconsax.arrow_right_3,
                            size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Iconsax.moon, color: AppColors.primary),
                    title: Text('Theme', style: AppTypography.label),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('System',
                            style: AppTypography.caption
                                .copyWith(color: AppColors.textSecondary)),
                        const Icon(Iconsax.arrow_right_3,
                            size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Data & Privacy', style: AppTypography.title),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: true,
                    onChanged: (v) {},
                    activeColor: AppColors.primary,
                    secondary:
                        const Icon(Iconsax.save_2, color: AppColors.primary),
                    title:
                        Text('Conversation Memory', style: AppTypography.label),
                    subtitle: Text('Allow AI to remember past contexts.',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  side: const BorderSide(color: AppColors.error),
                ),
                child: Text('Reset Conversation History',
                    style: AppTypography.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
