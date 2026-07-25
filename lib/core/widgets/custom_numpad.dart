import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomNumpad extends StatelessWidget {
  final ValueChanged<String> onKeyPress;

  const CustomNumpad({
    super.key,
    required this.onKeyPress,
  });

  @override
  Widget build(BuildContext context) {
    final numpad = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      [null, '0', 'del'],
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      color: const Color(0xFF111111), // G.black2
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: numpad.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Row(
              children: row.map((keyVal) {
                if (keyVal == null) {
                  return Expanded(
                    child: Container(
                      height: 56,
                      margin: const EdgeInsets.all(3),
                    ),
                  );
                }
                return Expanded(
                  child: _NumpadKey(
                    keyVal: keyVal,
                    onPress: () => onKeyPress(keyVal),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NumpadKey extends StatefulWidget {
  final String keyVal;
  final VoidCallback onPress;

  const _NumpadKey({
    required this.keyVal,
    required this.onPress,
  });

  @override
  State<_NumpadKey> createState() => _NumpadKeyState();
}

class _NumpadKeyState extends State<_NumpadKey> {
  bool _pressed = false;

  String _getSubText(String key) {
    const subs = {
      '2': 'ABC', '3': 'DEF', '4': 'GHI', '5': 'JKL',
      '6': 'MNO', '7': 'PQRS', '8': 'TUV', '9': 'WXYZ',
      '0': 'DEF' // Note: React says '0': 'DEF' which is weird but I match it
    };
    return subs[key] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isDel = widget.keyVal == 'del';

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPress,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 56,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: _pressed ? AppColors.surface2 : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: isDel
            ? const Icon(Icons.backspace_outlined, size: 18, color: AppColors.text)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.keyVal,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                      height: 1,
                    ),
                  ),
                  if (_getSubText(widget.keyVal).isNotEmpty) ...[
                    const SizedBox(height: 1),
                    Text(
                      _getSubText(widget.keyVal),
                      style: const TextStyle(
                        fontSize: 8,
                        color: AppColors.text30,
                        letterSpacing: 0.8, // 0.1em
                      ),
                    ),
                  ]
                ],
              ),
      ),
    );
  }
}
