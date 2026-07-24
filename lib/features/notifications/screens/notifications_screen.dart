import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../shared/components/molecules/squircle_card.dart';
import '../../../shared/components/atoms/app_icon_button.dart';
import '../providers/notifications_provider.dart';
import '../models/notification_item.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref, isDark),
            Expanded(
              child: notifications.isEmpty
                  ? _buildEmptyState(isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notif = notifications[index];
                        return _buildNotificationCard(
                            notif, isDark, index, ref);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isDark) {
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
            child: Text('Notifications', style: AppTypography.titleLarge),
          ),
          TextButton(
            onPressed: () =>
                ref.read(notificationsProvider.notifier).markAllAsRead(),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: Text('Mark all read', style: AppTypography.labelMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.p24),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkSurface : AppColors.surface)
                  .withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.notification_status,
                size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
          ),
          const SizedBox(height: AppSpacing.p24),
          Text('All caught up!', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.p8),
          Text('No new notifications right now.',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ).animate().fade().slideY(begin: 0.1),
    );
  }

  Widget _buildNotificationCard(
      NotificationItem notif, bool isDark, int index, WidgetRef ref) {
    Color getIconColor() {
      switch (notif.type) {
        case 'ai':
          return AppColors.primary;
        case 'deadline':
          return AppColors.error;
        case 'success':
          return AppColors.success;
        default:
          return Colors.blueAccent;
      }
    }

    IconData getIcon() {
      switch (notif.type) {
        case 'ai':
          return Iconsax.magic_star;
        case 'deadline':
          return Iconsax.clock;
        case 'success':
          return Iconsax.tick_circle;
        default:
          return Iconsax.info_circle;
      }
    }

    final String timeAgo = _formatTimeAgo(notif.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p24, vertical: AppSpacing.p8),
      child: GestureDetector(
        onTap: () =>
            ref.read(notificationsProvider.notifier).markAsRead(notif.id),
        child: SquircleCard(
          padding: const EdgeInsets.all(AppSpacing.p16),
          color: notif.isRead
              ? (isDark ? AppColors.darkSurface : Colors.white)
              : (isDark
                  ? AppColors.primary.withOpacity(0.05)
                  : AppColors.primary.withOpacity(0.05)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.p12),
                decoration: BoxDecoration(
                  color: getIconColor().withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(getIcon(), color: getIconColor(), size: 24),
              ),
              const SizedBox(width: AppSpacing.p16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: notif.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 4, left: 8),
                            decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.p8),
                    Text(
                      notif.message,
                      style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: AppSpacing.p12),
                    Text(
                      timeAgo,
                      style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fade(delay: (50 * index).ms).slideY(begin: 0.1),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
    return 'Just now';
  }
}
