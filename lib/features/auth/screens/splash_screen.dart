import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (_, state) {
        state.whenOrNull(
          error: (error, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Section
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EDUING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -1.5,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          TextSpan(
                            text: 'Your admission\n',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'journey starts\n',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'now.',
                            style: TextStyle(
                              color: Color(0xFF3DFF54),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Middle section (sticker cards)
            const Expanded(
              child: Center(
                child: SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _Sticker(
                        name: 'IIT Bombay',
                        tag: '#Most Visited',
                        rotate: -8,
                        left: 10,
                        top: 20,
                        width: 130,
                      ),
                      _Sticker(
                        name: 'BITS Pilani',
                        tag: '#Top Match',
                        rotate: 4,
                        left: 90,
                        top: 50,
                        width: 140,
                      ),
                      _Sticker(
                        name: 'Delhi Uni',
                        tag: '#NIRF #3',
                        rotate: 6,
                        right: 5,
                        top: 10,
                        width: 120,
                      ),
                      _Sticker(
                        name: 'VIT Vellore',
                        tag: '#Engineering',
                        rotate: -4,
                        left: 20,
                        bottom: 10,
                        width: 130,
                      ),
                      _Sticker(
                        name: 'NIT Trichy',
                        tag: '#South India',
                        rotate: 3,
                        right: 20,
                        bottom: 20,
                        width: 130,
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom section buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      ref.read(guestModeProvider.notifier).update(true);
                      context.go('/home');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24, width: 1.5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline, color: Colors.white60, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Continue as Guest",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      ref.read(authControllerProvider.notifier).signInWithGoogle();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('G', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                          SizedBox(width: 10),
                          Text(
                            "Continue with Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => context.push('/login'),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 16,
                        color: Colors.white24,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Color(0xFF3DFF54),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF3DFF54),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sticker extends StatelessWidget {
  final String name;
  final String tag;
  final double rotate;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double width;
  final bool isHighlight;

  const _Sticker({
    required this.name,
    required this.tag,
    required this.rotate,
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.width,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Transform.rotate(
        angle: rotate * math.pi / 180,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isHighlight ? const Color(0xFF3DFF54) : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHighlight ? Colors.transparent : Colors.white10,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: isHighlight ? Colors.black12 : const Color(0xFF2A4A2A),
                child: Icon(
                  Icons.account_balance,
                  color: isHighlight ? Colors.black : Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: TextStyle(
                  color: isHighlight ? Colors.black : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                tag,
                style: TextStyle(
                  color: isHighlight ? Colors.black54 : Colors.white38,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
