import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends ConsumerState<NotificationsScreen> {
  String _filter = 'All';
  final List<String> _filters = [
    'All',
    'deadline',
    'ai',
    'scholarship',
    'document',
    'application',
  ];

  static Color _colorForType(String type) {
    switch (type) {
      case 'ai':
        return NeoColors.purple;
      case 'deadline':
        return NeoColors.red;
      case 'scholarship':
        return NeoColors.yellow;
      case 'document':
        return NeoColors.green;
      case 'application':
        return NeoColors.blue;
      default:
        return NeoColors.blue;
    }
  }

  static String _iconForType(String type) {
    switch (type) {
      case 'ai':
        return '✦';
      case 'deadline':
        return '⚠️';
      case 'scholarship':
        return '🏆';
      case 'document':
        return '🛂';
      case 'application':
        return '📋';
      default:
        return '🔔';
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        shape: BoxShape.circle,
                        border: Border.all(color: NeoColors.borderDark),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'NOTIFICATIONS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white30,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  notifsAsync.maybeWhen(
                    data: (notifs) {
                      final unread =
                          notifs.where((n) => n['isRead'] != true).length;
                      if (unread > 0) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: NeoColors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('$unread NEW',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black)),
                        );
                      }
                      return const SizedBox();
                    },
                    orElse: () => const SizedBox(),
                  ),
                ],
              ),
            ),

            // ── Title + Mark all read ──
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Updates',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5)),
                  GestureDetector(
                    onTap: () {
                      notifsAsync.whenData((notifs) => ref
                          .read(notificationsActionsProvider)
                          .markAllAsRead(notifs));
                    },
                    child: const Text('Mark all read',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: NeoColors.green)),
                  ),
                ],
              ),
            ),

            // ── Filter chips ──
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: _filters.map((f) {
                  final isSelected = _filter == f;
                  final label = f == 'All'
                      ? 'All'
                      : f[0].toUpperCase() + f.substring(1);
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 32,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? NeoColors.surfDark2
                            : NeoColors.surfDark,
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : NeoColors.borderDark,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? Colors.white
                              : Colors.white60,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // ── Notification list ──
            Expanded(
              child: notifsAsync.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(
                        color: NeoColors.green)),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off,
                          color: Colors.white30, size: 40),
                      const SizedBox(height: 12),
                      Text('Error: $e',
                          style:
                              const TextStyle(color: Colors.white54)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () =>
                            ref.invalidate(notificationsProvider),
                        child: const Text('Retry',
                            style: TextStyle(
                                color: NeoColors.green,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                data: (notifications) {
                  final filtered = _filter == 'All'
                      ? notifications
                      : notifications
                          .where((n) =>
                              (n['type'] as String? ?? '') == _filter)
                          .toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔔',
                              style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 12),
                          Text(
                            _filter == 'All'
                                ? 'No notifications yet'
                                : 'No ${_filter[0].toUpperCase()}${_filter.substring(1)} notifications',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'We\'ll notify you about deadlines, AI insights and more.',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final n = filtered[index];
                      final type = (n['type'] as String? ?? '');
                      final isRead = n['isRead'] == true;
                      final title =
                          n['title'] as String? ?? 'Notification';
                      final message =
                          n['message'] ?? n['body'] ?? '';
                      final notifId = n['id'] as String? ?? '';
                      final ts = (n['createdAt'] as Timestamp?)?.toDate();
                      final dateStr = ts != null
                          ? '${ts.day}/${ts.month}'
                          : '';
                      final c = _colorForType(type);
                      final icon = _iconForType(type);

                      return GestureDetector(
                        onTap: () {
                          if (!isRead && notifId.isNotEmpty) {
                            ref
                                .read(notificationsActionsProvider)
                                .markAsRead(notifId);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isRead
                                ? NeoColors.surfDark
                                : c.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: isRead
                                    ? NeoColors.borderDark
                                    : c.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: isRead
                                          ? NeoColors.surfDark2
                                          : c.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(icon,
                                        style: const TextStyle(
                                            fontSize: 20)),
                                  ),
                                  if (!isRead)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: c,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.black,
                                              width: 2),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            title,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight:
                                                    FontWeight.w800,
                                                color: isRead
                                                    ? Colors.white
                                                    : c),
                                          ),
                                        ),
                                        if (dateStr.isNotEmpty) ...[
                                          const SizedBox(width: 8),
                                          Text(
                                            dateStr,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.white30,
                                                fontWeight:
                                                    FontWeight.w600),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      message.toString(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                          height: 1.4),
                                    ),
                                    if (type.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      neo.Badge(
                                          label: type.toUpperCase(),
                                          color: c),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
