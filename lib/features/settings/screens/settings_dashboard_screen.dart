import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/molecules/squircle_card.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../../../shared/components/atoms/app_avatar.dart';
import '../../../shared/components/atoms/app_button.dart';
import '../providers/settings_provider.dart';

class SettingsDashboardScreen extends ConsumerWidget {
  const SettingsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAccountHeader(isDark),
                    const SizedBox(height: AppSpacing.p32),
                    _buildSectionHeader('General'),
                    _buildSettingsGroup([
                      _buildListTile('Language', settings.language,
                          Iconsax.language_square, null, isDark),
                      _buildListTile('Theme', settings.themeMode, Iconsax.moon,
                          null, isDark),
                    ], isDark),
                    const SizedBox(height: AppSpacing.p32),
                    _buildSectionHeader('AI Preferences'),
                    _buildSettingsGroup([
                      _buildSwitchTile(
                          'Conversation Memory',
                          settings.conversationMemory,
                          Iconsax.data,
                          (v) => ref
                              .read(settingsProvider.notifier)
                              .updateSetting(conversationMemory: v),
                          isDark),
                      _buildSwitchTile(
                          'AI Suggestions',
                          settings.aiSuggestions,
                          Iconsax.magic_star,
                          (v) => ref
                              .read(settingsProvider.notifier)
                              .updateSetting(aiSuggestions: v),
                          isDark),
                      _buildListTile('Writing Style', settings.writingStyle,
                          Iconsax.edit_2, null, isDark),
                    ], isDark),
                    const SizedBox(height: AppSpacing.p32),
                    _buildSectionHeader('Notifications'),
                    _buildSettingsGroup([
                      _buildSwitchTile(
                          'Push Notifications',
                          settings.pushNotifications,
                          Iconsax.notification,
                          (v) => ref
                              .read(settingsProvider.notifier)
                              .updateSetting(pushNotifications: v),
                          isDark),
                      _buildSwitchTile(
                          'Application Updates',
                          settings.applicationUpdates,
                          Iconsax.document_1,
                          (v) => ref
                              .read(settingsProvider.notifier)
                              .updateSetting(applicationUpdates: v),
                          isDark),
                      _buildSwitchTile(
                          'Planner Reminders',
                          settings.plannerReminders,
                          Iconsax.calendar_1,
                          (v) => ref
                              .read(settingsProvider.notifier)
                              .updateSetting(plannerReminders: v),
                          isDark),
                    ], isDark),
                    const SizedBox(height: AppSpacing.p32),
                    _buildSectionHeader('Privacy & Data'),
                    _buildSettingsGroup([
                      _buildSwitchTile(
                          'Analytics',
                          settings.analyticsToggle,
                          Iconsax.chart,
                          (v) => ref
                              .read(settingsProvider.notifier)
                              .updateSetting(analyticsToggle: v),
                          isDark),
                      _buildActionTile(
                          'Export Data',
                          Iconsax.export_1,
                          isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                          () {},
                          isDark),
                      _buildActionTile('Clear Cache', Iconsax.trash,
                          AppColors.error, () {}, isDark),
                    ], isDark),
                    const SizedBox(height: AppSpacing.p32),
                    _buildSectionHeader('Developer'),
                    _buildSettingsGroup([
                      _buildSwitchTile(
                          'Developer Mode',
                          settings.developerMode,
                          Iconsax.code,
                          (v) => ref
                              .read(settingsProvider.notifier)
                              .updateSetting(developerMode: v),
                          isDark),
                      _buildSwitchTile(
                          'Mock API',
                          settings.mockApiToggle,
                          Iconsax.cloud_connection,
                          (v) => ref
                              .read(settingsProvider.notifier)
                              .updateSetting(mockApiToggle: v),
                          isDark),
                    ], isDark),
                    const SizedBox(height: AppSpacing.p32),
                    _buildSectionHeader('About'),
                    _buildSettingsGroup([
                      _buildListTile('Version', '1.0.0-dev.16',
                          Iconsax.info_circle, null, isDark),
                      _buildActionTile(
                          'Privacy Policy',
                          Iconsax.shield_tick,
                          isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                          () {},
                          isDark),
                    ], isDark),
                    const SizedBox(height: AppSpacing.p40),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.p24),
                      child: SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: 'Log Out',
                          variant: AppButtonVariant.secondary,
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ).animate().fade().slideY(begin: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Row(
        children: [
          AppIconButton(
            icon: Iconsax.arrow_left_2,
            isFilled: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: AppSpacing.p16),
          Expanded(
            child: Text('Settings', style: AppTypography.titleLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountHeader(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
      child: SquircleCard(
        padding: const EdgeInsets.all(AppSpacing.p20),
        child: Row(
          children: [
            const AppAvatar(
              imageUrl: 'https://i.pravatar.cc/150?img=11',
              size: 56,
            ),
            const SizedBox(width: AppSpacing.p16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prince Mittal', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.p4),
                  Text('prince.mittal@example.com',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            AppIconButton(
              icon: Iconsax.edit_2,
              isFilled: true,
              backgroundColor:
                  isDark ? AppColors.darkSurface : AppColors.surface,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding:
          const EdgeInsets.only(left: AppSpacing.p32, bottom: AppSpacing.p12),
      child: Text(title.toUpperCase(),
          style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2)),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: (isDark ? AppColors.darkBorder : AppColors.border)
                .withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                  height: 1,
                  indent: 64,
                  color: (isDark ? AppColors.darkBorder : AppColors.border)
                      .withValues(alpha: 0.5)),
          ],
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, IconData icon,
      VoidCallback? onTap, bool isDark) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p20, vertical: AppSpacing.p4),
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.p12),
        decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title,
          style: AppTypography.labelLarge.copyWith(
              color:
                  isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(subtitle,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(width: AppSpacing.p8),
          const Icon(Iconsax.arrow_right_3,
              size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, IconData icon,
      ValueChanged<bool> onChanged, bool isDark) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p20, vertical: AppSpacing.p4),
      secondary: Container(
        padding: const EdgeInsets.all(AppSpacing.p12),
        decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title,
          style: AppTypography.labelLarge.copyWith(
              color:
                  isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)),
    );
  }

  Widget _buildActionTile(String title, IconData icon, Color color,
      VoidCallback onTap, bool isDark) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p20, vertical: AppSpacing.p4),
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.p12),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      title:
          Text(title, style: AppTypography.labelLarge.copyWith(color: color)),
    );
  }
}
