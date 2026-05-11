import 'package:flutter/material.dart';

/// Global singleton that holds the current theme mode.
/// Any widget can read or write it via ThemeNotifier.instance.
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier._() : super(ThemeMode.dark);
  static final ThemeNotifier instance = ThemeNotifier._();

  bool get isDark => value == ThemeMode.dark;

  void setDark(bool dark) {
    value = dark ? ThemeMode.dark : ThemeMode.light;
  }
}
