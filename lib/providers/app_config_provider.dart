import 'package:flutter/material.dart';

class AppConfigProvider with ChangeNotifier {
  String _theme = "system";

  String get themeValue {
    return _theme;
  }

  ThemeMode get themeMode {
    switch (_theme) {
      case 'system':
        return ThemeMode.light;

      case 'light':
        return ThemeMode.light;

      case 'dark':
        return ThemeMode.dark;

      default:
        return ThemeMode.light;
    }
  }

  void setTheme(String selected) {
    _theme = selected;
    notifyListeners();
  }
}