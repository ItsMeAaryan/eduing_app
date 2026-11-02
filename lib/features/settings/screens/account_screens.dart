// Account settings that are actually wired up: password reset and
// notification preferences (same users/{uid}.notificationPrefs keys as the website).
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../profile/providers/profile_provider.dart';

PreferredSizeWidget _bar(String title) => AppBar(
      backgroundColor: NeoColors.bgDark,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
    );

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});
  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _sending = false;
  String? _note;

  Future<void> _reset() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;
    setState(() => _sending = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _note = 'We sent a password reset link to $email.';
    } catch (_) {
      _note = 'Couldn’t send the email. Try again in a minute.';
    }
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    return Scaffold(
      backgroundColor: NeoColors.bgDark,
      appBar: _bar('Security'),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        const Text('Signed in as', style: TextStyle(color: NeoColors.subDark, fontSize: 12.5)),
        Text(email, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 22),
        const Text('Change password', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('We’ll email you a secure link to set a new password.', style: TextStyle(color: NeoColors.subDark, fontSize: 13)),
        const SizedBox(height: 14),
        GreenBtn(label: _sending ? 'Sending…' : 'Email me a reset link', disabled: _sending, onClick: _reset),
        if (_note != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_note!, style: const TextStyle(color: Colors.white70))),
      ]),
    );
  }
}

class NotificationPrefsScreen extends ConsumerWidget {
  const NotificationPrefsScreen({super.key});

  static const _prefs = [
    ['applicationUpdates', 'Application updates', 'Offers, exam schedules, document checks and fee verification.'],
    ['deadlineReminders', 'Deadline reminders', 'Alerts 7 days and 24 hours before each application deadline.'],
    ['scholarshipAlerts', 'Scholarship alerts', 'When a new scholarship matches your profile.'],
    ['email', 'Email copies', 'Also send important updates to your email address.'],
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value ?? const {};
    final stored = (profile['notificationPrefs'] as Map?) ?? const {};
    return Scaffold(
      backgroundColor: NeoColors.bgDark,
      appBar: _bar('Notifications'),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        for (final p in _prefs)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(color: NeoColors.surfDark, borderRadius: BorderRadius.circular(18), border: Border.all(color: NeoColors.borderDark)),
            child: SwitchListTile(
              value: stored[p[0]] is bool ? stored[p[0]] as bool : true,
              activeThumbColor: NeoColors.green,
              title: Text(p[1], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              subtitle: Text(p[2], style: const TextStyle(color: NeoColors.subDark, fontSize: 12.5)),
              onChanged: (v) async {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid == null) return;
                try {
                  await FirebaseFirestore.instance.collection('users').doc(uid).update({'notificationPrefs.${p[0]}': v});
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Couldn’t save that setting. Try again.')));
                  }
                }
              },
            ),
          ),
      ]),
    );
  }
}
