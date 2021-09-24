import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppConfigProvider with ChangeNotifier {
  final ThemeMode _systemTheme = SchedulerBinding.instance!.window.platformBrightness == Brightness.light ? (
    ThemeMode.light
  ) : (
    ThemeMode.dark
  );
  String _theme = "system";

  ThemeMode get systemTheme {
    return _systemTheme;
  }

  String get themeValue {
    return _theme;
  }

  ThemeMode get themeMode {
    switch (_theme) {
      case 'system':
        return _systemTheme;

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