import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sqflite/sqlite_api.dart';

class AppConfigProvider with ChangeNotifier {
  Database? _dbInstance;
  final ThemeMode _systemTheme = SchedulerBinding.instance!.window.platformBrightness == Brightness.light ? (
    ThemeMode.light
  ) : (
    ThemeMode.dark
  );
  String _theme = "system";
  bool _isModalBottomSheetOpen = false;
  String _appVersion = "";


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

  bool get modalBottomSheetOpen {
    return _isModalBottomSheetOpen;
  }

  String get appVersion {
    return _appVersion;
  }

  void setDbInstance(Database db) {
    _dbInstance = db;
  }

  void setTheme(String selected) async {
    _theme = selected;

    await _dbInstance!.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE settings SET value = ? WHERE config = "theme"', [_theme],
      );
    });

    notifyListeners();
  }

  void setModalBottomSheetStatus(bool isOpen) {
    _isModalBottomSheetOpen = isOpen;
    notifyListeners();
  }

  void setConfig(List<Map<String, Object?>> config) {
    for (var configItem in config) {
      if (configItem['config'] == 'theme') {
        _theme = configItem['value'].toString();
      }
    }
  }

  void setAppVersion(String version) {
    _appVersion = version;
  }
}