// theme_notifier.dart
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    
    // Theme o'zgarganda biroz kechikish bilan notify qilish
    // Bu GlobalKey konfliktini oldini oladi
    Future.microtask(() {
      notifyListeners();
    });
  }
}