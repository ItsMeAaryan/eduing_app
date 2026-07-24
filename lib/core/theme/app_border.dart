import 'package:flutter/material.dart';

class AppBorder {
  static const double thin = 1.0;
  static const double medium = 2.0;
  static const double thick = 3.0;

  static BorderSide side(Color color, [double width = thin]) {
    return BorderSide(color: color, width: width);
  }
}
