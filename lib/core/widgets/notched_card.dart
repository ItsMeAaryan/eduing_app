import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NotchedCard extends StatefulWidget {
  final Widget child;
  final Color bg;
  final Color notchColor;
  final Widget? actionIcon;
  final Color actionBg;
  final Color actionColor;
  final VoidCallback? onAction;
  final EdgeInsets padding;

  const NotchedCard({
    super.key,
    required this.child,
    this.bg = AppColors.surface,
    this.notchColor = AppColors.background,
    this.actionIcon,
    this.actionBg = AppColors.primaryAccent,
    this.actionColor = AppColors.background,
    this.onAction,
    this.padding = const EdgeInsets.all(20.0),
  });

  @override
  State<NotchedCard> createState() => _NotchedCardState();
}

class _NotchedCardState extends State<NotchedCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.bg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000), // rgba(0,0,0,0.4)
                blurRadius: 32,
                offset: Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Padding(
                padding: widget.padding,
                child: widget.child,
              ),
              Positioned(
                bottom: -20,
                right: -20,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: widget.notchColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.actionIcon != null)
          Positioned(
            bottom: -10,
            right: -10,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) => setState(() => _pressed = false),
              onTapCancel: () => setState(() => _pressed = false),
              onTap: widget.onAction,
              child: AnimatedScale(
                scale: _pressed ? 0.9 : 1.0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.actionBg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.actionBg.withValues(alpha: 0.4), // approx 66 hex
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: IconTheme(
                    data: IconThemeData(
                      color: widget.actionColor,
                      size: 20,
                    ),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: widget.actionColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                      child: widget.actionIcon!,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
