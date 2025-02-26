import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/common/color.dart';
import 'package:flutter_demo_app/pages/base.dart';
import 'package:flutter_demo_app/provider/app_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends BasePage<SettingPage> {
  var colorKey = SpUtil.getString('key_theme_color') ?? 'blue';
  var themeWithSystem = SpUtil.getBool('key_theme_with_system') ?? false;

  @override
  Widget buildBody() {
    Color themeColor = MyColors.getThemeColor(context);
    Color secondaryColor = themeColor.withOpacity(0.5);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("跟随系统",
                      style: TextStyle(fontSize: 18.0, color: themeColor)),
                  Text(
                    "开启后，将根据系统打开或关闭深色模式",
                    style: TextStyle(fontSize: 12.0, color: secondaryColor),
                  )
                ],
              ),
              Switch(
                value: themeWithSystem,
                activeColor: Colors.green,
                activeTrackColor: Colors.green.withOpacity(0.5),
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: const Color(0xFFDDDDDD),
                onChanged: (bool value) async {
                  setState(() {
                    themeWithSystem = value;
                  });
                  SpUtil.putBool('key_theme_with_system', themeWithSystem);
                  await Provider.of<AppInfoProvider>(context, listen: false)
                      .setTheme(colorKey);
                },
              )
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: themeColors.keys.map(
              (key) {
                var colorList = themeColors[key]!;
                Color primaryColor = colorList[0];
                return InkWell(
                  onTap: () async {
                    // 如果跟随系统，则不能切换主题
                    if (themeWithSystem) {
                      return;
                    }
                    setState(() {
                      colorKey = key;
                    });
                    SpUtil.putString('key_theme_color', key);
                    await Provider.of<AppInfoProvider>(context, listen: false)
                        .setTheme(colorKey);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    color: primaryColor,
                    child: themeWithSystem
                        ? Icon(
                            Icons.lock_outline,
                            size: 20.0,
                            color: Colors.white.withOpacity(.5),
                          )
                        : (key == colorKey
                            ? const Icon(Icons.done, color: Colors.white)
                            : null),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  @override
  String getTitle() {
    return '主题设置';
  }
}
