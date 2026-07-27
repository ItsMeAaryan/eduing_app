import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      body: Stack(
        children: [
          // Background Pulse Glow
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.3),
                radius: 0.8,
                colors: [
                  const Color(0xFF3DFF54).withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .fadeIn(duration: 3000.ms, begin: 0.3),

          SafeArea(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Your admission',
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            letterSpacing: -1.5,
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        ).animate()
                         .fadeIn(delay: 0.ms, duration: 500.ms)
                         .slideX(begin: -0.2, end: 0),
                        const Text(
                          'journey starts',
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            letterSpacing: -1.5,
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        ).animate()
                         .fadeIn(delay: 150.ms, duration: 500.ms)
                         .slideX(begin: -0.2, end: 0),
                        const Text(
                          'now.',
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            letterSpacing: -1.5,
                            fontFamily: 'Inter',
                            color: Color(0xFF3DFF54),
                            fontStyle: FontStyle.italic,
                          ),
                        ).animate()
                         .fadeIn(delay: 300.ms, duration: 500.ms)
                         .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
                      ],
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
                        delay: 100,
                        moveYEnd: -6,
                      ),
                      _Sticker(
                        name: 'BITS Pilani',
                        tag: '#Top Match',
                        rotate: 4,
                        left: 90,
                        top: 50,
                        width: 140,
                        delay: 200,
                        moveYEnd: -8,
                      ),
                      _Sticker(
                        name: 'Delhi Uni',
                        tag: '#NIRF #3',
                        rotate: 6,
                        right: 5,
                        top: 10,
                        width: 120,
                        delay: 300,
                        moveYEnd: -5,
                      ),
                      _Sticker(
                        name: 'VIT Vellore',
                        tag: '#Engineering',
                        rotate: -4,
                        left: 20,
                        bottom: 10,
                        width: 130,
                        delay: 150,
                        moveYEnd: -7,
                      ),
                      _Sticker(
                        name: 'NIT Trichy',
                        tag: '#South India',
                        rotate: 3,
                        right: 20,
                        bottom: 20,
                        width: 130,
                        isHighlight: true,
                        delay: 250,
                        moveYEnd: -9,
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
            ).animate().fadeIn(delay: 600.ms, duration: 400.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
          ],
        ),
      ),
        ],
      ),
    );
  }
}

class _Sticker extends StatefulWidget {
  final String name;
  final String tag;
  final double rotate;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double width;
  final bool isHighlight;
  final int delay;
  final double moveYEnd;

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
    required this.delay,
    required this.moveYEnd,
  });

  @override
  State<_Sticker> createState() => _StickerState();
}

class _StickerState extends State<_Sticker> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() async {
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: widget.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isHighlight ? const Color(0xFF3DFF54) : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isHighlight ? Colors.transparent : Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: widget.isHighlight ? Colors.black12 : const Color(0xFF2A4A2A),
            child: Icon(
              Icons.account_balance,
              color: widget.isHighlight ? Colors.black : Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.name,
            style: TextStyle(
              color: widget.isHighlight ? Colors.black : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            widget.tag,
            style: TextStyle(
              color: widget.isHighlight ? Colors.black54 : Colors.white38,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );

    return Positioned(
      left: widget.left,
      right: widget.right,
      top: widget.top,
      bottom: widget.bottom,
      child: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Transform.rotate(
            angle: widget.rotate * math.pi / 180,
            child: card,
          ),
        ),
      )
      .animate()
      .fadeIn(duration: 400.ms, delay: widget.delay.ms)
      .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack)
      .then()
      .animate(onPlay: (c) => c.repeat(reverse: true))
      .moveY(begin: 0, end: widget.moveYEnd, duration: 3000.ms, curve: Curves.easeInOut),
    );
  }
}
