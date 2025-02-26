import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo_app/common/color.dart';

class MyToast {
  static void show(BuildContext context, {required String message, bool needPop = true}) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          content: Text(
            message.isEmpty ? '提示内容' : message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyColors.isDarkMode(context) ? Colors.black : Colors.white,
            ),
          ),
          contentPadding: const EdgeInsets.all(10.0),
          backgroundColor: MyColors.isDarkMode(context) ? Colors.white : Colors.black,
        );
      },
    );

    if (needPop) {
      Timer(const Duration(seconds: 1, milliseconds: 500), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }
  }
}
