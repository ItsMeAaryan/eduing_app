import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlowInput extends StatefulWidget {
  final String label;
  final String placeholder;
  final String value;
  final ValueChanged<String> onChange;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? right;

  const GlowInput({
    super.key,
    required this.label,
    required this.placeholder,
    required this.value,
    required this.onChange,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.right,
  });

  @override
  State<GlowInput> createState() => _GlowInputState();
}

class _GlowInputState extends State<GlowInput> {
  bool _focused = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(covariant GlowInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.text30,
              letterSpacing: 10 * 0.1, // 0.1em
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _focused ? AppColors.primaryAccent : AppColors.border,
                width: 1.5,
              ),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.09), // 18 hex approx
                        spreadRadius: 3,
                      )
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: widget.onChange,
                    keyboardType: widget.keyboardType,
                    obscureText: widget.obscureText,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.text,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: const TextStyle(
                        color: AppColors.text30, // placeholder rgba(255,255,255,0.2) roughly text30
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 2), // Align text vertically
                    ),
                  ),
                ),
                if (widget.right != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: widget.right!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
