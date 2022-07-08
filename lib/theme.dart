import 'package:flutter/material.dart';

import 'lib_color_schemes.g.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    colorScheme: lightColorScheme,
    brightness: Brightness.light,
  );

  static ThemeData dark = ThemeData(
    colorScheme: darkColorScheme,
    brightness: Brightness.dark,
  );

  static ThemeData getThemeData() {
    return AppTheme.light;
  }
}
