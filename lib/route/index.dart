import 'package:flutter/material.dart';
import 'package:flutter_demo_app/pages/home.dart';
import 'package:flutter_demo_app/pages/login.dart';
import 'package:flutter_demo_app/pages/login_instruction.dart';
import 'package:flutter_demo_app/pages/setting.dart';

var routes = <String, WidgetBuilder>{
  '/login': (context) => const LoginPage(),
  '/home': (context) => const HomePage(),
  '/login-instruction': (context) => const LoginInstructionPage(),
  '/setting': (context) => const SettingPage(),
};
