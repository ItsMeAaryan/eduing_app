import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';

class NeoColors {
  // Backgrounds
  static const Color bgLight = Color(0xFFF2F2F7);
  static const Color bgDark = Color(0xFF0C0C0E);
  static const Color surfLight = Color(0xFFFFFFFF);
  static const Color surfDark = Color(0xFF1C1C1F);
  static const Color surf2Light = Color(0xFFE8E8ED);
  static const Color surf2Dark = Color(0xFF2C2C30);

  // Accents
  static const Color purple = Color(0xFF7B5EA7);
  static const Color purpleSoft = Color(0xFFA78BCA);
  static const Color purpleBlock = Color(0xFFEDE9F6);
  static const Color blue = Color(0xFF3B5BFF);
  static const Color blueBlock = Color(0xFFE8EDFF);
  static const Color green = Color(0xFF34C759);
  static const Color greenBlock = Color(0xFFE3F9EA);
  static const Color yellow = Color(0xFFF5A623);
  static const Color yellowBlock = Color(0xFFFFF3E0);
  static const Color red = Color(0xFFFF3B30);

  // Text
  static const Color textLight = Color(0xFF0C0C0E);
  static const Color textDark = Color(0xFFF2F2F7);
  static const Color subLight = Color(0xFF6E6E73);
  static const Color subDark = Color(0xFF98989F);
  static const Color mutedLight = Color(0xFFAEAEB2);
  static const Color mutedDark = Color(0xFF636366);

  // Borders
  static const Color borderLight = Color(0xFFD1D1D6);
  static const Color borderDark = Color(0xFF3A3A3E);
}

class NeoThemeData {
  final bool isDark;
  final Color bg;
  final Color surf;
  final Color surf2;
  final Color text;
  final Color sub;
  final Color muted;
  final Color border;
  final List<BoxShadow> shadow;

  NeoThemeData({required this.isDark})
      : bg = isDark ? NeoColors.bgDark : NeoColors.bgLight,
        surf = isDark ? NeoColors.surfDark : NeoColors.surfLight,
        surf2 = isDark ? NeoColors.surf2Dark : NeoColors.surf2Light,
        text = isDark ? NeoColors.textDark : NeoColors.textLight,
        sub = isDark ? NeoColors.subDark : NeoColors.subLight,
        muted = isDark ? NeoColors.mutedDark : NeoColors.mutedLight,
        border = isDark ? NeoColors.borderDark : NeoColors.borderLight,
        shadow = isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ];

  static NeoThemeData of(BuildContext context) {
    return NeoThemeData(isDark: Theme.of(context).brightness == Brightness.dark);
  }
}

// ── SQUIRCLE CARD ──────────────────────────────────────────────
class SCard extends StatefulWidget {
  final Widget child;
  final Color? bg;
  final VoidCallback? onClick;
  final double radius;
  final bool shadow;
  final bool border;
  final EdgeInsetsGeometry padding;

  const SCard({
    super.key,
    required this.child,
    this.bg,
    this.onClick,
    this.radius = 24.0,
    this.shadow = true,
    this.border = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<SCard> createState() => _SCardState();
}

class _SCardState extends State<SCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final t = NeoThemeData.of(context);

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: widget.padding,
      decoration: ShapeDecoration(
        color: widget.bg ?? t.surf,
        shadows: widget.shadow ? t.shadow : null,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: widget.radius,
            cornerSmoothing: 1,
          ),
          side: widget.border ? BorderSide(color: t.border, width: 1.5) : BorderSide.none,
        ),
      ),
      child: widget.child,
    );

    if (widget.onClick != null) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onClick,
          child: AnimatedScale(
            scale: _isHovered ? 0.985 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: card,
          ),
        ),
      );
    }
    return card;
  }
}

// ── PILL BUTTON ────────────────────────────────────────────────
class PillBtn extends StatefulWidget {
  final String label;
  final VoidCallback? onClick;
  final Color? bg;
  final Color? color;
  final String size; // "sm", "md", "lg"
  final String? icon;
  final bool ghost;
  final bool flex;

  const PillBtn({
    super.key,
    required this.label,
    this.onClick,
    this.bg,
    this.color,
    this.size = "md",
    this.icon,
    this.ghost = false,
    this.flex = false,
  });

  @override
  State<PillBtn> createState() => _PillBtnState();
}

class _PillBtnState extends State<PillBtn> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final t = NeoThemeData.of(context);
    final double h = widget.size == "sm" ? 36 : (widget.size == "lg" ? 56 : 46);
    final double px = widget.size == "sm" ? 14 : (widget.size == "lg" ? 28 : 20);
    final double fs = widget.size == "sm" ? 13 : (widget.size == "lg" ? 16 : 14);
    final bgColor = widget.bg ?? NeoColors.purple;

    Widget btn = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: h,
      padding: EdgeInsets.symmetric(horizontal: px),
      decoration: BoxDecoration(
        color: widget.ghost ? Colors.transparent : bgColor,
        borderRadius: BorderRadius.circular(h / 2),
        border: widget.ghost ? Border.all(color: t.border, width: 1.5) : null,
        boxShadow: widget.ghost
            ? null
            : [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.26), // roughly 44 hex
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Row(
        mainAxisSize: widget.flex ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Text(widget.icon!, style: TextStyle(fontSize: fs + 2)),
            const SizedBox(width: 6),
          ],
          Text(
            widget.label,
            style: TextStyle(
              fontSize: fs,
              fontWeight: FontWeight.w700,
              color: widget.ghost ? t.sub : (widget.color ?? Colors.white),
              letterSpacing: 0.1, // 0.01em approx
            ),
          ),
        ],
      ),
    );

    if (widget.onClick != null) {
      return GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onClick!();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: btn,
        ),
      );
    }
    return btn;
  }
}

// ── NOTCHED CARD ───────────────────────────────────────────────
class NotchedCard extends StatelessWidget {
  final Widget child;
  final Color? bg;
  final double notchSize;
  final String notchPos; // "br", "bl", "tr", "tl"
  final EdgeInsetsGeometry padding;

  const NotchedCard({
    super.key,
    required this.child,
    this.bg,
    this.notchSize = 44,
    this.notchPos = "br",
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final t = NeoThemeData.of(context);
    const double r = 24.0;
    final double n = notchSize + 8;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            color: bg ?? t.surf,
            shadows: t.shadow,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: r,
                cornerSmoothing: 1,
              ),
            ),
          ),
          padding: padding,
          child: child,
        ),
        // Notch circle cutout faker
        Positioned(
          bottom: (notchPos == "br" || notchPos == "bl") ? -n / 2 + 4 : null,
          top: (notchPos == "tr" || notchPos == "tl") ? -n / 2 + 4 : null,
          right: (notchPos == "br" || notchPos == "tr") ? -n / 2 + 4 : null,
          left: (notchPos == "bl" || notchPos == "tl") ? -n / 2 + 4 : null,
          child: Container(
            width: n,
            height: n,
            decoration: BoxDecoration(
              color: t.bg,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

// ── FLOATING ACTION ────────────────────────────────────────────
class FloatingActionBtn extends StatefulWidget {
  final String icon;
  final Color bg;
  final double size;
  final VoidCallback? onClick;

  const FloatingActionBtn({
    super.key,
    required this.icon,
    this.bg = NeoColors.purple,
    this.size = 44,
    this.onClick,
  });

  @override
  State<FloatingActionBtn> createState() => _FloatingActionBtnState();
}

class _FloatingActionBtnState extends State<FloatingActionBtn> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (widget.onClick != null) widget.onClick!();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.bg,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.bg.withValues(alpha: 0.33), // 55 hex
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.icon,
            style: TextStyle(fontSize: widget.size * 0.42, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ── STAT CHIP ──────────────────────────────────────────────────
class StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String? delta;
  final Color? accent;
  final Color? accentBg;

  const StatChip({
    super.key,
    required this.label,
    required this.value,
    this.delta,
    this.accent,
    this.accentBg,
  });

  @override
  Widget build(BuildContext context) {
    final t = NeoThemeData.of(context);
    return SCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: t.sub,
              letterSpacing: 0.4, // 0.04em approx
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: t.text,
              letterSpacing: -0.5,
            ),
          ),
          if (delta != null) ...[
            const SizedBox(height: 4),
            Container(
              height: 18,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: accentBg ?? NeoColors.greenBlock,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    delta!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: accent ?? NeoColors.green,
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}

// ── PROGRESS BAR ───────────────────────────────────────────────
class ProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;

  const ProgressBar({
    super.key,
    required this.value,
    this.color = NeoColors.purple,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final t = NeoThemeData.of(context);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: t.surf2,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        width: MediaQuery.of(context).size.width * (value / 100),
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }
}

// ── TAG / BADGE ────────────────────────────────────────────────
class Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? bg;

  const Badge({
    super.key,
    required this.label,
    this.color = NeoColors.purple,
    this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bg ?? color.withValues(alpha: 0.09), // 18 hex
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── INPUT ──────────────────────────────────────────────────────
class NeoInput extends StatefulWidget {
  final String? label;
  final String placeholder;
  final bool isPassword;
  final TextEditingController? controller;
  final Widget? rightEl;

  const NeoInput({
    super.key,
    this.label,
    required this.placeholder,
    this.isPassword = false,
    this.controller,
    this.rightEl,
  });

  @override
  State<NeoInput> createState() => _NeoInputState();
}

class _NeoInputState extends State<NeoInput> {
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
    final t = NeoThemeData.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                widget.label!.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: t.muted,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 50,
            decoration: BoxDecoration(
              color: t.surf,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isFocused ? NeoColors.purple : t.border,
                width: 2,
              ),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: NeoColors.purple.withValues(alpha: 0.09), // 18 hex
                        blurRadius: 0,
                        spreadRadius: 3,
                      )
                    ]
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    obscureText: widget.isPassword,
                    style: TextStyle(fontSize: 15, color: t.text),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                if (widget.rightEl != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: widget.rightEl,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
