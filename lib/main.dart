import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_app/common/color.dart';
import 'package:flutter_demo_app/pages/login.dart';
import 'package:flutter_demo_app/provider/app_provider.dart';
import 'package:flutter_demo_app/route/index.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color themeColor = MyColors.getThemeColor(context);
    Color secondaryColor = themeColor.withOpacity(0.5);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppInfoProvider()),
      ],
      child: Consumer<AppInfoProvider>(
        builder: (context, appInfo, _) {
          // 获取主体颜色Key
          String colorKey = appInfo.themeColor;
          bool themeWithSystem = MyColors.getThemeWithSystem();

          if (themeColors.containsKey(colorKey)) {
            var colorList = themeColors[colorKey]!;
            themeColor = colorList[0];
            secondaryColor = colorList[1];
          }

          return MaterialApp(
            title: '沃·主题',
            theme: ThemeData(
              colorScheme: ColorScheme(
                brightness: Brightness.light,
                primary: themeColor,
                onPrimary: Colors.white,
                secondary: secondaryColor,
                onSecondary: Colors.white,
                error: MyColors.dangerColor,
                onError: Colors.white,
                surface: Colors.white,
                onSurface: Colors.white,
              ),
              textTheme: const TextTheme(
                displayLarge: TextStyle(color: Colors.white),
                displayMedium: TextStyle(color: Colors.white),
                displaySmall: TextStyle(color: Colors.white),
                headlineLarge: TextStyle(color: Colors.white),
                headlineMedium: TextStyle(color: Colors.white),
                headlineSmall: TextStyle(color: Colors.white),
                titleLarge: TextStyle(color: Colors.white),
                titleMedium: TextStyle(color: Colors.white),
                titleSmall: TextStyle(color: Colors.white),
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white),
                labelLarge: TextStyle(color: Colors.white),
                labelMedium: TextStyle(color: Colors.white),
                labelSmall: TextStyle(color: Colors.white),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                // 设置输入框的样式
                hintStyle: TextStyle(
                  color: MyColors.placeholderColor,
                ), // 设置 placeholder 的颜色
              ),
            ),
            themeMode: themeWithSystem ? ThemeMode.system : ThemeMode.light,
            darkTheme: ThemeData.dark(),
            home: const LoginPage(),
            routes: routes,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
