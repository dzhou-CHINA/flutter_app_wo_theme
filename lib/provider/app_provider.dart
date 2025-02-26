import 'package:flutter/material.dart';

class AppInfoProvider extends ChangeNotifier {
  String _themeColor = '';
  bool _themeWithSystem = false;

  String get themeColor => _themeColor;
  bool get themeWithSystem => _themeWithSystem;

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }

  setThemeWithSystem(bool themeWithSystem) {
    _themeWithSystem = themeWithSystem;
    notifyListeners();
  }
}
