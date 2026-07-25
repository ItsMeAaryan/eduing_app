import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GreenButton extends StatefulWidget {
  final String label;
  final VoidCallback? onClick;
  final String? icon;
  final bool outline;
  final bool loading;
  final bool disabled;

  const GreenButton({
    super.key,
    required this.label,
    this.onClick,
    this.icon,
    this.outline = false,
    this.loading = false,
    this.disabled = false,
  });

  @override
  State<GreenButton> createState() => _GreenButtonState();
}

class _GreenButtonState extends State<GreenButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = widget.outline ? Colors.transparent : AppColors.primaryAccent;
    final effectiveColor = widget.outline ? AppColors.text : AppColors.background;
    final isDisabled = widget.disabled || widget.loading;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTapDown: isDisabled ? null : (_) => setState(() => _pressed = true),
        onTapUp: isDisabled ? null : (_) => setState(() => _pressed = false),
        onTapCancel: isDisabled ? null : () => setState(() => _pressed = false),
        onTap: isDisabled ? null : widget.onClick,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: effectiveBg,
              borderRadius: BorderRadius.circular(26),
              border: widget.outline ? Border.all(color: AppColors.border, width: 1.5) : null,
              boxShadow: widget.outline || isDisabled
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.26), // 44 hex
                        blurRadius: 24,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.loading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
                    ),
                  )
                else ...[
                  if (widget.icon != null) ...[
                    Text(
                      widget.icon!,
                      style: const TextStyle(fontSize: 17),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: effectiveColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.01 * 15, // 0.01em
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
