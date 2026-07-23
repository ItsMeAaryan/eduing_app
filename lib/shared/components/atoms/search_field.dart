import 'package:flutter/material.dart';
import 'app_text_field.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    this.hintText = "Search...",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hintText: hintText,
      prefixIcon: Icons.search,
      onChanged: onChanged,
    );
  }
}
