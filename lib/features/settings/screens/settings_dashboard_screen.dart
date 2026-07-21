import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/settings_provider.dart';

class SettingsDashboardScreen extends ConsumerWidget {
  const SettingsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Settings', style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildAccountHeader(),
          const SizedBox(height: 24),
          _buildSectionHeader('General'),
          _buildSettingsGroup([
            _buildListTile('Language', settings.language, Iconsax.language_square, null),
            _buildListTile('Theme', settings.themeMode, Iconsax.moon, null),
          ]),
          const SizedBox(height: 24),
          _buildSectionHeader('AI Preferences'),
          _buildSettingsGroup([
            _buildSwitchTile('Conversation Memory', settings.conversationMemory, Iconsax.data, (v) => ref.read(settingsProvider.notifier).updateSetting(conversationMemory: v)),
            _buildSwitchTile('AI Suggestions', settings.aiSuggestions, Iconsax.magic_star, (v) => ref.read(settingsProvider.notifier).updateSetting(aiSuggestions: v)),
            _buildListTile('Writing Style', settings.writingStyle, Iconsax.edit_2, null),
          ]),
          const SizedBox(height: 24),
          _buildSectionHeader('Notifications'),
          _buildSettingsGroup([
            _buildSwitchTile('Push Notifications', settings.pushNotifications, Iconsax.notification, (v) => ref.read(settingsProvider.notifier).updateSetting(pushNotifications: v)),
            _buildSwitchTile('Application Updates', settings.applicationUpdates, Iconsax.document_1, (v) => ref.read(settingsProvider.notifier).updateSetting(applicationUpdates: v)),
            _buildSwitchTile('Planner Reminders', settings.plannerReminders, Iconsax.calendar_1, (v) => ref.read(settingsProvider.notifier).updateSetting(plannerReminders: v)),
          ]),
          const SizedBox(height: 24),
          _buildSectionHeader('Privacy & Data'),
          _buildSettingsGroup([
            _buildSwitchTile('Analytics', settings.analyticsToggle, Iconsax.chart, (v) => ref.read(settingsProvider.notifier).updateSetting(analyticsToggle: v)),
            _buildActionTile('Export Data', Iconsax.export_1, AppColors.textPrimary, () {}),
            _buildActionTile('Clear Cache', Iconsax.trash, AppColors.error, () {}),
          ]),
          const SizedBox(height: 24),
          _buildSectionHeader('Developer'),
          _buildSettingsGroup([
            _buildSwitchTile('Developer Mode', settings.developerMode, Iconsax.code, (v) => ref.read(settingsProvider.notifier).updateSetting(developerMode: v)),
            _buildSwitchTile('Mock API', settings.mockApiToggle, Iconsax.cloud_connection, (v) => ref.read(settingsProvider.notifier).updateSetting(mockApiToggle: v)),
          ]),
          const SizedBox(height: 24),
          _buildSectionHeader('About'),
          _buildSettingsGroup([
            _buildListTile('Version', '1.0.0-dev.16', Iconsax.info_circle, null),
            _buildActionTile('Privacy Policy', Iconsax.shield_tick, AppColors.textPrimary, () {}),
          ]),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: const BorderSide(color: AppColors.error),
                ),
                child: Text('Log Out', style: AppTypography.button),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ).animate().fade().slideY(begin: 0.1),
    );
  }

  Widget _buildAccountHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Prince Mittal', style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('prince.mittal@example.com', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, bottom: 8),
      child: Text(title.toUpperCase(), style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) const Divider(height: 1, indent: 56),
          ],
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, IconData icon, VoidCallback? onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTypography.label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          const Icon(Iconsax.arrow_right_3, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, IconData icon, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTypography.label),
    );
  }

  Widget _buildActionTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(title, style: AppTypography.label.copyWith(color: color)),
    );
  }
}
