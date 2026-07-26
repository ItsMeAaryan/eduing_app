import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = "All";
  final List<String> _filters = ["All", "Deadline", "AI", "Scholarship", "Document", "Application"];

  final List<Map<String, dynamic>> _notifications = [
    {
      "id": 1,
      "title": "Application Deadline Approaching",
      "body": "Stanford MS CS application is due in 3 days. Complete pending steps.",
      "time": "2h ago",
      "tag": "Deadline",
      "color": NeoColors.red,
      "icon": "⚠️",
      "read": false,
    },
    {
      "id": 2,
      "title": "AI Profile Analysis Complete",
      "body": "Your profile has been analyzed. You have a strong match for MIT.",
      "time": "5h ago",
      "tag": "AI",
      "color": NeoColors.purple,
      "icon": "✦",
      "read": false,
    },
    {
      "id": 3,
      "title": "New Scholarship Match",
      "body": "You are eligible for the STEM Innovators Grant (₹2L/yr).",
      "time": "1d ago",
      "tag": "Scholarship",
      "color": NeoColors.yellow,
      "icon": "🏆",
      "read": true,
    },
    {
      "id": 4,
      "title": "Document Verified",
      "body": "Your Passport has been successfully verified.",
      "time": "2d ago",
      "tag": "Document",
      "color": NeoColors.green,
      "icon": "🛂",
      "read": true,
    },
  ];

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n['read'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == "All" ? _notifications : _notifications.where((n) => n['tag'] == _filter).toList();
    final unreadCount = _notifications.where((n) => !n['read']).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
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
                  if (unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: NeoColors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('$unreadCount NEW', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black)),
                    ),
                ],
              ),
            ),

            // Top Actions & Filters
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Updates', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                  GestureDetector(
                    onTap: _markAllRead,
                    child: const Text('Mark all read', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: NeoColors.green)),
                  ),
                ],
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: _filters.map((f) {
                  final isSelected = _filter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? NeoColors.surfDark2 : NeoColors.surfDark,
                        border: Border.all(
                          color: isSelected ? Colors.white : NeoColors.borderDark,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : Colors.white60,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Notifications List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final notif = filtered[index];
                  final isRead = notif['read'];
                  final Color c = notif['color'];

                  return GestureDetector(
                    onTap: () {
                      setState(() => notif['read'] = true);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isRead ? NeoColors.surfDark : c.withValues(alpha: 0.05), // ~0D hex equivalent
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isRead ? NeoColors.borderDark : c.withValues(alpha: 0.2)), // ~33 hex
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isRead ? NeoColors.surfDark2 : c.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(notif['icon'], style: const TextStyle(fontSize: 20)),
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
                                      border: Border.all(color: Colors.black, width: 2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(notif['title'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isRead ? Colors.white : c)),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(notif['time'], style: const TextStyle(fontSize: 11, color: Colors.white30, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(notif['body'], style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.7), height: 1.4)),
                                const SizedBox(height: 12),
                                neo.Badge(label: notif['tag'], color: c),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
