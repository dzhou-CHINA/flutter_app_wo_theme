import 'package:flutter/material.dart';
import 'package:flutter_demo_app/common/color.dart';

class MyDialog {
  // 获取颜色
  static Color getColor(String type) {
    const Map<String, Color> colorMapper = ({
      'info': MyColors.infoColor,
      'error': MyColors.dangerColor,
      'success': MyColors.successColor,
      'warning': MyColors.warningColor,
    });

    return colorMapper[type] ?? MyColors.warningColor;
  }

  // 弹框显示
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
    required String type,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info,
                color: getColor(type),
                size: 22,
              ),
              Container(
                margin: const EdgeInsets.only(left: 4),
                child: Text(
                  title.isEmpty ? '提示' : title,
                  style: const TextStyle(
                    color: MyColors.primaryTextColor,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          titleTextStyle: const TextStyle(
            color: MyColors.primaryTextColor,
            fontSize: 18,
          ),
          content: Text(
            content.isEmpty ? '提示内容' : content,
            textAlign: TextAlign.center,
          ),
          contentTextStyle: const TextStyle(
            color: MyColors.primaryTextColor,
            fontSize: 15,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 10),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "确认",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.secondaryColor,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
