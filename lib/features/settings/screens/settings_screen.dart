import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifs = true;
  bool darkMode = true;
  bool biometric = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account
                    const Text(
                      'ACCOUNT',
                      style: TextStyle(
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
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        children: [
                          _buildListItem(
                            icon: '✉️',
                            label: 'Email',
                            value: 'aaryan@example.com',
                            showBorder: true,
                          ),
                          _buildListItem(
                            icon: '📱',
                            label: 'Phone',
                            value: '+91 98765 43210',
                            showBorder: true,
                          ),
                          _buildListItem(
                            icon: '🔑',
                            label: 'Change Password',
                            showBorder: false,
                          ),
                        ],
                      ),
                    ),

                    // Preferences
                    const Text(
                      'PREFERENCES',
                      style: TextStyle(
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
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        children: [
                          _buildToggleItem('🔔', 'Push Notifications', notifs, (val) => setState(() => notifs = val), true),
                          _buildToggleItem('🌙', 'Dark Mode', darkMode, (val) => setState(() => darkMode = val), true),
                          _buildToggleItem('👆', 'Biometric Login', biometric, (val) => setState(() => biometric = val), true),
                          _buildListItem(icon: '🌐', label: 'Language', value: 'English', showBorder: true),
                          _buildListItem(icon: '🔔', label: 'Notification Prefs', showBorder: false),
                        ],
                      ),
                    ),

                    // Privacy
                    const Text(
                      'PRIVACY & LEGAL',
                      style: TextStyle(
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
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        children: ['Privacy Policy', 'Terms of Service', 'Data & Storage', 'Connected Apps'].asMap().entries.map((e) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              border: e.key < 3
                                  ? const Border(bottom: BorderSide(color: NeoColors.borderDark))
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(e.value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
                                const Text('›', style: TextStyle(fontSize: 16, color: NeoColors.subDark)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // App info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        border: Border.all(color: NeoColors.borderDark),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Text('🎓', style: TextStyle(fontSize: 32)),
                          SizedBox(height: 6),
                          Text('EDUING', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                          Text('Version 1.0.0 · Build 42', style: TextStyle(fontSize: 11, color: NeoColors.subDark)),
                        ],
                      ),
                    ),

                    // Danger
                    Container(
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        border: Border.all(color: NeoColors.red.withValues(alpha: 0.13)), // 22 hex
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: NeoColors.borderDark)),
                            ),
                            child: const Row(
                              children: [
                                Text('🚪', style: TextStyle(fontSize: 18)),
                                SizedBox(width: 12),
                                Text('Log Out', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white60)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: const Row(
                              children: [
                                Text('🗑️', style: TextStyle(fontSize: 18)),
                                SizedBox(width: 12),
                                Text('Delete Account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: NeoColors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({required String icon, required String label, String? value, required bool showBorder}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showBorder ? const Border(bottom: BorderSide(color: NeoColors.borderDark)) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(icon, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                if (value != null)
                  Text(value, style: const TextStyle(fontSize: 11, color: NeoColors.subDark)),
              ],
            ),
          ),
          const Text('›', style: TextStyle(fontSize: 16, color: NeoColors.subDark)),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String icon, String label, bool value, Function(bool) onChanged, bool showBorder) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showBorder ? const Border(bottom: BorderSide(color: NeoColors.borderDark)) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(icon, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
          _CustomToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _CustomToggle extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const _CustomToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 44,
        height: 26,
        decoration: BoxDecoration(
          color: value ? NeoColors.green : NeoColors.surfDark2,
          border: Border.all(
            color: value ? NeoColors.green : NeoColors.borderDark,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(13),
          boxShadow: value
              ? [BoxShadow(color: NeoColors.green.withValues(alpha: 0.33), blurRadius: 10)] // 55 hex approx
              : [],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              top: 2,
              left: value ? 20 : 2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? Colors.black : NeoColors.subDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
