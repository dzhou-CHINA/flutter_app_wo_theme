import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class MyColors {
  // 基础颜色
  static const Color primaryColor = Color(0xff265AD2);
  static const Color secondaryColor = Color(0xff4695F9);
  static const Color successColor = Color(0xff67C23A);
  static const Color warningColor = Color(0xffE6A23C);
  static const Color dangerColor = Color(0xffF56C6C);
  static const Color infoColor = Color(0xff909399);
  static const Color primaryTextColor = Color(0xff303133);
  static const Color normalTextColor = Color(0xff606266);
  static const Color placeholderColor = Color(0xffCCCCCC);
  static const Color dividerColor = Color(0xffEBEEF5);
  static const Color bgColor = Color.fromRGBO(0, 0, 0, 0.7);

  // 获取文字颜色
  static Color getDisplayTextColor(BuildContext context) {
    return isDarkMode(context) ? Colors.white : Colors.black;
  }

  // 获取背景颜色
  static Color getBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? Colors.white : Colors.black;
  }

  // 判断是否是暗黑模式
  static bool isDarkMode(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.brightness == Brightness.dark;
  }

  //  获取主题颜色
  static Color getThemeColor(BuildContext context) {
    var colorKey = SpUtil.getString('key_theme_color') ?? "dark";
    var themeWithSystem = getThemeWithSystem();
    Color themeColor = themeColors[colorKey]?[0] ?? primaryColor;
    return isDarkMode(context) && themeWithSystem ? Theme.of(context).primaryColor : themeColor;
  }

  // theme with system
  static bool getThemeWithSystem() {
    var themeWithSystem = SpUtil.getBool('key_theme_with_system') ?? false;
    return themeWithSystem;
  }
}

// 主题颜色集合
const Map<String, List<Color>> themeColors = {
  "blue": [Color(0xff265AD2), Color(0xFF5E94DB)],
  "green": [Color(0xff087F5B), Color(0xFF71C6AC)],
  "purple": [Color(0xff5F3DC4), Color(0xFF947ED8)],
  "dark": [Colors.black, Color(0xFF999999)]
};
