import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:figma_squircle/figma_squircle.dart';

class AuthColors {
  static const Color bg = Color(0xFF05060F);
  static const Color bg2 = Color(0xFF0B0D1A);
  static const Color surface = Color(0x0DFFFFFF); // rgba(255,255,255,0.05)
  static const Color surfaceHover = Color(0x14FFFFFF); // 0.08
  static const Color border = Color(0x14FFFFFF); // 0.08
  static const Color borderFocus = Color(0xCC7C3AED); // 0.8
  static const Color blue1 = Color(0xFF1A1AFF);
  static const Color blue2 = Color(0xFF3B5BFF);
  static const Color purple = Color(0xFF7C3AED);
  static const Color purple2 = Color(0xFF9F6FFF);
  static const Color violet = Color(0xFFC084FC);
  static const Color glow = Color(0x597C3AED); // 0.35
  static const Color glow2 = Color(0x403B5BFF); // 0.25
  static const Color text = Color(0xFFFFFFFF);
  static const Color textSub = Color(0x80FFFFFF); // 0.5
  static const Color textMuted = Color(0x47FFFFFF); // 0.28
  static const Color error = Color(0xFFFF5C5C);
  static const Color success = Color(0xFF34D399);
}

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AuthColors.bg,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Base gradients
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AuthColors.purple.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AuthColors.blue2.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),
          // Floating Orbs
          Positioned(
            top: MediaQuery.of(context).size.height * -0.05,
            left: MediaQuery.of(context).size.width * 0.6,
            child: _buildOrb(
              size: 200,
              color: AuthColors.purple.withValues(alpha: 0.18),
              blur: 60,
              moveX: -20,
              moveY: 15,
              delay: 0,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * -0.1,
            child: _buildOrb(
              size: 160,
              color: AuthColors.blue2.withValues(alpha: 0.15),
              blur: 50,
              moveX: 15,
              moveY: -20,
              delay: 2000,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: MediaQuery.of(context).size.width * 0.7,
            child: _buildOrb(
              size: 120,
              color: AuthColors.violet.withValues(alpha: 0.12),
              blur: 40,
              moveX: -10,
              moveY: 10,
              delay: 4000,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb({
    required double size,
    required Color color,
    required double blur,
    required double moveX,
    required double moveY,
    required int delay,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 0.7],
        ),
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
          delay: delay.ms,
        )
        .move(
          duration: 4000.ms,
          curve: Curves.easeInOut,
          begin: const Offset(0, 0),
          end: Offset(moveX, moveY),
        )
        .then()
        .move(
          duration: 4000.ms,
          curve: Curves.easeInOut,
          begin: Offset(moveX, moveY),
          end: const Offset(0, 0),
        );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool glow;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.glow = false,
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: borderRadius,
        cornerSmoothing: 1,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0x0AFFFFFF), // rgba(255,255,255,0.04)
            border: Border.all(
              color: glow ? AuthColors.purple.withValues(alpha: 0.4) : const Color(0x12FFFFFF), // 0.07
              width: 1,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: glow
                ? [
                    BoxShadow(
                      color: AuthColors.purple.withValues(alpha: 0.2),
                      blurRadius: 40,
                    ),
                  ]
                : [],
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlowInput extends StatefulWidget {
  final String? label;
  final String placeholder;
  final bool isPassword;
  final TextEditingController controller;
  final String? errorText;
  final Widget? rightElement;
  final TextInputType keyboardType;

  const GlowInput({
    super.key,
    this.label,
    required this.placeholder,
    required this.controller,
    this.isPassword = false,
    this.errorText,
    this.rightElement,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<GlowInput> createState() => _GlowInputState();
}

class _GlowInputState extends State<GlowInput> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.label!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AuthColors.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 52,
            decoration: ShapeDecoration(
              color: _isFocused
                  ? AuthColors.purple.withValues(alpha: 0.08)
                  : const Color(0x0AFFFFFF),
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 14,
                  cornerSmoothing: 1,
                ),
                side: BorderSide(
                  color: hasError
                      ? AuthColors.error
                      : _isFocused
                          ? AuthColors.purple2
                          : AuthColors.border,
                  width: 1.5,
                ),
              ),
              shadows: _isFocused && !hasError
                  ? [
                      BoxShadow(
                        color: AuthColors.purple.withValues(alpha: 0.1),
                        blurRadius: 20,
                      ),
                      BoxShadow(
                        color: AuthColors.purple.withValues(alpha: 0.15),
                        blurRadius: 0,
                        spreadRadius: 3,
                      )
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    obscureText: widget.isPassword,
                    keyboardType: widget.keyboardType,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AuthColors.text,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: const TextStyle(
                        color: Color(0x33FFFFFF), // rgba(255,255,255,0.2)
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                if (widget.rightElement != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: widget.rightElement,
                  ),
              ],
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                widget.errorText!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AuthColors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class GlowBtn extends StatefulWidget {
  final String label;
  final VoidCallback? onClick;
  final bool disabled;
  final bool loading;
  final bool isPrimary;

  const GlowBtn({
    super.key,
    required this.label,
    this.onClick,
    this.disabled = false,
    this.loading = false,
    this.isPrimary = true,
  });

  @override
  State<GlowBtn> createState() => _GlowBtnState();
}

class _GlowBtnState extends State<GlowBtn> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.disabled || widget.loading;

    return GestureDetector(
      onTapDown: (_) => {if (!isDisabled) setState(() => _isPressed = true)},
      onTapUp: (_) {
        if (!isDisabled) {
          setState(() => _isPressed = false);
          widget.onClick?.call();
        }
      },
      onTapCancel: () => {if (!isDisabled) setState(() => _isPressed = false)},
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Opacity(
          opacity: isDisabled ? 0.4 : 1.0,
          child: Container(
            width: double.infinity,
            height: 56,
            clipBehavior: Clip.hardEdge,
            decoration: ShapeDecoration(
              shape: const StadiumBorder(
                side: BorderSide.none,
              ),
              gradient: widget.isPrimary
                  ? const LinearGradient(
                      colors: [AuthColors.purple, AuthColors.blue2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: !widget.isPrimary ? const Color(0x0DFFFFFF) : null,
              shadows: widget.isPrimary && !isDisabled
                  ? [
                      BoxShadow(
                        color: AuthColors.purple.withValues(alpha: 0.5),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!widget.isPrimary)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AuthColors.border),
                    ),
                  ),
                if (widget.isPrimary && !isDisabled)
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Positioned(
                        left: -300 + (_shimmerController.value * 900),
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.15),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.loading)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: widget.isPrimary ? Colors.white : AuthColors.text,
                        letterSpacing: 0.32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleBtn extends StatefulWidget {
  const GoogleBtn({super.key});

  @override
  State<GoogleBtn> createState() => _GoogleBtnState();
}

class _GoogleBtnState extends State<GoogleBtn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0x14FFFFFF) : const Color(0x0DFFFFFF),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _isHovered ? const Color(0x26FFFFFF) : AuthColors.border,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGoogleLogo(),
                const SizedBox(width: 10),
                const Text(
                  "Continue with Google",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AuthColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleLogo() {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(
        painter: GoogleLogoPainter(),
      ),
    );
  }
}

class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path1 = Path()
      ..moveTo(22.56/24*size.width, 12.25/24*size.height)
      ..relativeLineTo(0, -2.25/24*size.height)
      ..lineTo(12/24*size.width, 10/24*size.height)
      ..lineTo(12/24*size.width, 14.26/24*size.height)
      ..lineTo(17.92/24*size.width, 14.26/24*size.height)
      ..relativeCubicTo(-.26/24*size.width, 1.37/24*size.height, -1.04/24*size.width, 2.53/24*size.height, -2.21/24*size.width, 3.31/24*size.height)
      ..relativeLineTo(0, 2.77/24*size.height)
      ..relativeLineTo(3.57/24*size.width, 0)
      ..relativeCubicTo(2.08/24*size.width, -1.92/24*size.height, 3.28/24*size.width, -4.74/24*size.height, 3.28/24*size.width, -8.09/24*size.height)
      ..close();
    canvas.drawPath(path1, Paint()..color = const Color(0xFF4285F4));

    final path2 = Path()
      ..moveTo(12/24*size.width, 23/24*size.height)
      ..relativeCubicTo(2.97/24*size.width, 0, 5.46/24*size.width, -.98/24*size.height, 7.28/24*size.width, -2.66/24*size.height)
      ..relativeLineTo(-3.57/24*size.width, -2.77/24*size.height)
      ..relativeCubicTo(-.98/24*size.width, .66/24*size.height, -2.23/24*size.width, 1.06/24*size.height, -3.71/24*size.width, 1.06/24*size.height)
      ..relativeCubicTo(-2.86/24*size.width, 0, -5.29/24*size.width, -1.93/24*size.height, -6.16/24*size.width, -4.53/24*size.height)
      ..lineTo(2.18/24*size.width, 14.1/24*size.height)
      ..relativeLineTo(0, 2.84/24*size.height)
      ..cubicTo(3.99/24*size.width, 20.53/24*size.height, 7.7/24*size.width, 23/24*size.height, 12/24*size.width, 23/24*size.height)
      ..close();
    canvas.drawPath(path2, Paint()..color = const Color(0xFF34A853));

    final path3 = Path()
      ..moveTo(5.84/24*size.width, 14.09/24*size.height)
      ..relativeCubicTo(-.22/24*size.width, -.66/24*size.height, -.35/24*size.width, -1.36/24*size.height, -.35/24*size.width, -2.09/24*size.height)
      ..relativeCubicTo(0, -.73/24*size.height, .13/24*size.width, -1.43/24*size.height, .35/24*size.width, -2.09/24*size.height)
      ..lineTo(5.84/24*size.width, 7.07/24*size.height)
      ..lineTo(2.18/24*size.width, 7.07/24*size.height)
      ..cubicTo(1.43/24*size.width, 8.55/24*size.height, 1/24*size.width, 10.22/24*size.height, 1/24*size.width, 12/24*size.height)
      ..relativeCubicTo(0, 1.78/24*size.height, .43/24*size.width, 3.45/24*size.height, 1.18/24*size.width, 4.93/24*size.height)
      ..lineTo(5.84/24*size.width, 14.09/24*size.height)
      ..close();
    canvas.drawPath(path3, Paint()..color = const Color(0xFFFBBC05));

    final path4 = Path()
      ..moveTo(12/24*size.width, 5.38/24*size.height)
      ..relativeCubicTo(1.62/24*size.width, 0, 3.06/24*size.width, .56/24*size.height, 4.21/24*size.width, 1.64/24*size.height)
      ..lineTo(19.36/24*size.width, 3.87/24*size.height)
      ..cubicTo(17.45/24*size.width, 2.09/24*size.height, 14.97/24*size.width, 1/24*size.height, 12/24*size.width, 1/24*size.height)
      ..cubicTo(7.7/24*size.width, 1/24*size.height, 3.99/24*size.width, 3.47/24*size.height, 2.18/24*size.width, 7.07/24*size.height)
      ..lineTo(5.84/24*size.width, 9.91/24*size.height)
      ..relativeCubicTo(.87/24*size.width, -2.6/24*size.height, 3.3/24*size.width, -4.53/24*size.height, 6.16/24*size.width, -4.53/24*size.height)
      ..close();
    canvas.drawPath(path4, Paint()..color = const Color(0xFFEA4335));
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: AuthColors.border,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "OR",
              style: TextStyle(
                fontSize: 12,
                color: AuthColors.textMuted,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: AuthColors.border,
            ),
          ),
        ],
      ),
    );
  }
}

class LogoMark extends StatelessWidget {
  final double size;

  const LogoMark({super.key, this.size = 48.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.3),
        gradient: const LinearGradient(
          colors: [AuthColors.purple, AuthColors.blue2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AuthColors.purple.withValues(alpha: 0.5),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          const BoxShadow(
            color: Color(0x26FFFFFF),
            blurRadius: 0,
            spreadRadius: 1,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: Center(
        child: Text(
          "🎓",
          style: TextStyle(fontSize: size * 0.45),
        ),
      ),
    );
  }
}
