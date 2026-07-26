import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/green_button.dart';
import '../../../core/widgets/ghost_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  int _idx = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _slides = [
    {
      'bg': AppColors.primaryAccent,
      'textColor': AppColors.background,
      'accentColor': AppColors.background,
      'headline': ['Your', 'journey', 'starts', 'now.'],
    },
    {
      'bg': AppColors.orange,
      'textColor': AppColors.text,
      'accentColor': AppColors.primaryAccent,
      'headline': ['Chase', 'dreams', 'not', 'limits.'],
    },
    {
      'bg': AppColors.background,
      'textColor': AppColors.text,
      'accentColor': AppColors.primaryAccent,
      'headline': ['Apply', 'smarter,', 'get', 'in.'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_idx < _slides.length - 1) {
        setState(() => _idx++);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    final slide = _slides[_idx];
    final bg = slide['bg'] as Color;
    final textColor = slide['textColor'] as Color;
    final accentColor = slide['accentColor'] as Color;
    final headline = slide['headline'] as List<String>;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: bg,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Back arrow
              if (_idx > 0)
                Positioned(
                  top: 10,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      _timer?.cancel();
                      setState(() => _idx--);
                      _startTimer();
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back,
                        color: _idx == 1 ? AppColors.text : AppColors.background,
                        size: 16,
                      ),
                    ),
                  ),
                ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // EDUING logo top
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Text(
                      'EDUING',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: (_idx == 0 ? AppColors.background : AppColors.text).withValues(alpha: 0.5),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  // Hero headline and stickers
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, left: 22, right: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 500),
                            style: TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                              letterSpacing: -1.5,
                              color: textColor,
                              fontFamily: 'Inter',
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                  height: 1.05,
                                  letterSpacing: -1.5,
                                  color: textColor,
                                  fontFamily: 'Inter',
                                ),
                                children: [
                                  TextSpan(text: '${headline[0]}\n${headline[1]}\n${headline[2]}\n'),
                                  TextSpan(
                                    text: headline[3],
                                    style: TextStyle(
                                      color: _idx == 0 ? AppColors.background : accentColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Floating sticker cards
                          SizedBox(
                            height: 160,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                _Sticker(label: 'IIT Bombay', sub: '#Most Visited', rotate: -8, left: 15, top: 10, bg: _idx == 0 ? AppColors.surface : Colors.black.withValues(alpha: 0.4)),
                                _Sticker(label: 'BITS Pilani', sub: '#Top Match', rotate: 5, left: 120, top: 30, bg: _idx == 0 ? AppColors.surface2 : Colors.black.withValues(alpha: 0.4), size: 'sm'),
                                _Sticker(label: 'Delhi Uni', sub: '#NIRF #3', rotate: -3, left: 210, top: 5, bg: _idx == 0 ? AppColors.surface : Colors.black.withValues(alpha: 0.4), size: 'sm'),
                                _Sticker(label: 'VIT Vellore', sub: '#Engineering', rotate: 7, left: 25, top: 90, bg: _idx == 0 ? const Color(0xFF333333) : Colors.black.withValues(alpha: 0.4), size: 'sm'),
                                const _Sticker(label: 'NIT Trichy', sub: '#South India', rotate: -5, left: 150, top: 100, bg: AppColors.primaryAccent, color: AppColors.background),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Dot indicator
                          Row(
                            children: List.generate(_slides.length, (i) {
                              return GestureDetector(
                                onTap: () {
                                  _timer?.cancel();
                                  setState(() => _idx = i);
                                  _startTimer();
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(right: 6),
                                  height: 4,
                                  width: i == _idx ? 24 : 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: _idx == 0
                                        ? (i == _idx ? AppColors.background : Colors.black.withValues(alpha: 0.25))
                                        : (i == _idx ? AppColors.primaryAccent : AppColors.text30),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom auth actions
                  Container(
                    padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          _idx == 0 ? Colors.black.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: [
                          GhostButton(
                            label: 'Continue As Guest',
                            icon: '👤',
                            onClick: () {
                              ref.read(guestModeProvider.notifier).update(true);
                              context.go('/home');
                            },
                          ),
                          const SizedBox(height: 10),
                          if (Theme.of(context).platform == TargetPlatform.iOS) ...[
                            GreenButton(
                              label: 'Continue with Apple',
                              icon: '🍎',
                              onClick: () => context.go('/register'),
                            ),
                            const SizedBox(height: 10),
                          ],
                          GreenButton(
                            label: 'Continue with Google',
                            icon: 'G',
                            onClick: () {
                              ref.read(authControllerProvider.notifier).signInWithGoogle();
                            },
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 15,
                                color: _idx == 0 ? Colors.black.withValues(alpha: 0.7) : Colors.white,
                                fontFamily: 'Inter',
                              ),
                              children: [
                                const TextSpan(text: 'Already have an account? '),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: GestureDetector(
                                    onTap: () => context.go('/login'),
                                    child: Text(
                                      'Log in',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: _idx == 0 ? AppColors.background : AppColors.primaryAccent,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _Sticker extends StatelessWidget {
  final String label;
  final String? sub;
  final double rotate;
  final double left;
  final double top;
  final Color color;
  final Color bg;
  final String size;

  const _Sticker({
    required this.label,
    this.sub,
    required this.rotate,
    required this.left,
    required this.top,
    this.color = AppColors.text,
    this.bg = AppColors.surface,
    this.size = 'md',
  });

  @override
  Widget build(BuildContext context) {
    final w = size == 'sm' ? 90.0 : 110.0;
    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: rotate * math.pi / 180,
        child: Container(
          width: w,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000), // rgba(0,0,0,0.4)
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withValues(alpha: 0.2), // 33 hex approx
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text('🏛', style: TextStyle(fontSize: 14)),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1.2,
                ),
              ),
              if (sub != null) ...[
                const SizedBox(height: 2),
                Text(
                  sub!,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
