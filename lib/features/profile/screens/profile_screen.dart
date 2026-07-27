import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);

    final sections = [
      {
        'title': 'PERSONAL',
        'items': [
          {'icon': '👤', 'label': 'Personal Information', 'sub': 'Name, DOB, gender', 'color': NeoColors.blue, 'route': '/profile/personal'},
          {'icon': '📚', 'label': 'Academic Details', 'sub': 'Boards, scores, grades', 'color': NeoColors.purple, 'route': '/profile/academic'},
          {'icon': '👨‍👩‍👦', 'label': 'Parent / Guardian', 'sub': 'Contact & income info', 'color': const Color(0xFFFF6B35), 'route': '/profile/guardian'},
          {'icon': '📍', 'label': 'Address', 'sub': 'Permanent & current', 'color': NeoColors.yellow, 'route': '/profile/address'},
        ]
      },
      {
        'title': 'ADMISSION',
        'items': [
          {'icon': '🏆', 'label': 'Entrance Exams', 'sub': 'JEE, NEET, CAT scores', 'color': NeoColors.green, 'route': '/profile/exams'},
          {'icon': '📋', 'label': 'Category & Quota', 'sub': 'General / OBC / SC / ST', 'color': const Color(0xFFFF3B7A), 'route': '/profile/category'},
          {'icon': '🪪', 'label': 'Student ID', 'sub': 'Digital ID card & QR', 'color': NeoColors.blue, 'route': '/profile/student-id'},
        ]
      },
      {
        'title': 'ACCOUNT',
        'items': [
          {'icon': '🔒', 'label': 'Security', 'sub': 'Password, 2FA, sessions', 'color': NeoColors.red, 'route': '/settings/security'},
          {'icon': '🔔', 'label': 'Notifications', 'sub': 'Email, SMS, push', 'color': NeoColors.yellow, 'route': '/settings/notifications'},
          {'icon': '🎨', 'label': 'Appearance', 'sub': 'Theme, language', 'color': NeoColors.purple, 'route': '/settings/appearance'},
          {'icon': '🔗', 'label': 'Connected Accounts', 'sub': 'Google, Apple', 'color': NeoColors.blue, 'route': '/settings/connected'},
        ]
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black, // spec uses G.black
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
          child: Column(
            children: [
              // Profile hero
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 24),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Stack(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [NeoColors.purple, NeoColors.blue],
                              ),
                              border: Border.all(color: NeoColors.green, width: 3),
                            ),
                            alignment: Alignment.center,
                            child: const Text('👤', style: TextStyle(fontSize: 36)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => context.push('/profile/edit'),
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: NeoColors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                alignment: Alignment.center,
                                child: const Text('✏️', style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      state.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${state.email} · ${state.phone}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: NeoColors.subDark,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Profile completion
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        border: Border.all(color: NeoColors.borderDark),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Profile Completion',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white60,
                                ),
                              ),
                              Text(
                                '${state.completion}%',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: NeoColors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ProgressBar(value: state.completion.toDouble(), color: NeoColors.green, height: 5),
                          const SizedBox(height: 6),
                          const Text(
                            'Add entrance exam scores to reach 85%',
                            style: TextStyle(
                              fontSize: 11,
                              color: NeoColors.subDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Digital ID Card
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: NotchedCard(
                  bg: Colors.transparent, // handeled internally by Container
                  padding: EdgeInsets.zero,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [NeoColors.purple, NeoColors.blue],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DIGITAL STUDENT ID',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white.withValues(alpha: 0.5),
                            letterSpacing: 10 * 0.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: EDU-2025-78432',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            neo.Badge(label: 'B.Tech CSE', color: Colors.white, bg: Colors.white.withValues(alpha: 0.15)),
                            const SizedBox(width: 10),
                            neo.Badge(label: '2025 BATCH', color: Colors.white, bg: Colors.white.withValues(alpha: 0.15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    right: -10,
                    child: FloatingActionBtn(
                      icon: 'QR',
                      bg: NeoColors.green,
                      onClick: () {},
                    ),
                  ),
                  ],
                ),
                ),
              ),

              // Sections
              ...sections.map((sec) {
                final items = sec['items'] as List<Map<String, dynamic>>;
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sec['title'] as String,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: NeoColors.subDark,
                          letterSpacing: 10 * 0.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: NeoColors.surfDark,
                          border: Border.all(color: NeoColors.borderDark),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: List.generate(items.length, (i) {
                            final item = items[i];
                            final color = item['color'] as Color;
                            return GestureDetector(
                              onTap: () {
                                if (item.containsKey('route')) {
                                  context.push(item['route'] as String);
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: i < items.length - 1 ? NeoColors.borderDark : Colors.transparent,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.09), // 18 hex
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: color.withValues(alpha: 0.2)), // 33 hex
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(item['icon'] as String, style: const TextStyle(fontSize: 17)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['label'] as String,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          item['sub'] as String,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: NeoColors.subDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text('›', style: TextStyle(fontSize: 16, color: NeoColors.subDark)),
                                ],
                              ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Danger zone
              Container(
                decoration: BoxDecoration(
                  color: NeoColors.surfDark,
                  border: Border.all(color: NeoColors.red.withValues(alpha: 0.13)), // 22 hex
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _DangerItem(
                      icon: '🚪',
                      label: 'Log out',
                      color: Colors.white60,
                      hasBorder: true,
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) context.go('/');
                      },
                    ),
                    _DangerItem(
                      icon: '🗑️',
                      label: 'Delete Account',
                      color: NeoColors.red,
                      hasBorder: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DangerItem extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final bool hasBorder;
  final VoidCallback onTap;

  const _DangerItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.hasBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: hasBorder ? NeoColors.borderDark : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
