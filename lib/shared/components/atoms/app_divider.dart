import 'package:flutter/material.dart';
import '../../../core/theme/colors/app_colors.dart';

class AppDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  const AppDivider({
    super.key,
    this.height = 1.0,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = color ?? (isDark ? AppColors.darkBorder : AppColors.border);
    
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: dividerColor,
    );
  }
}
