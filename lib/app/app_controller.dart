import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  TextDirection _textDirection = TextDirection.ltr;

  ThemeMode get themeMode => _themeMode;
  TextDirection get textDirection => _textDirection;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleDirection(bool isRtl) {
    _textDirection = isRtl ? TextDirection.rtl : TextDirection.ltr;
    notifyListeners();
  }
}
