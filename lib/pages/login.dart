// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_app/common/color.dart';
import 'package:flutter_demo_app/common/constant.dart';
import 'package:flutter_demo_app/components/toast.dart';
import 'package:flutter_demo_app/pages/base.dart';
import 'package:flutter_demo_app/service/api_constant.dart';
import 'package:flutter_demo_app/service/request.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

const xIcon = '''
<svg width="31" height="25" viewBox="0 0 31 25" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_4062_37936)">
<path d="M30.2342 2.93315C29.1446 3.41511 27.9734 3.74071 26.7444 3.88719C27.9989 3.13736 28.9625 1.95003 29.416 0.535147C28.2419 1.22959 26.9415 1.7337 25.5574 2.0054C24.4491 0.827807 22.8699 0.0921631 21.1222 0.0921631C17.7666 0.0921631 15.0458 2.80483 15.0458 6.15082C15.0458 6.6257 15.0996 7.08817 15.2033 7.5316C10.1532 7.27895 5.67603 4.86676 2.67908 1.20109C2.15604 2.09591 1.85632 3.13663 1.85632 4.24704C1.85632 6.34913 2.92905 8.2036 4.55946 9.29008C3.56344 9.25863 2.62651 8.98605 1.8073 8.53229C1.80661 8.55754 1.80661 8.58294 1.80661 8.60848C1.80661 11.544 3.90113 13.9926 6.68084 14.5496C6.17098 14.6881 5.63417 14.7621 5.08003 14.7621C4.6885 14.7621 4.30792 14.724 3.93682 14.6534C4.71012 17.0604 6.95406 18.8121 9.61308 18.8608C7.53351 20.486 4.91359 21.4546 2.06665 21.4546C1.57619 21.4546 1.09254 21.4259 0.617188 21.3699C3.30627 23.0891 6.50017 24.0922 9.93161 24.0922C21.1081 24.0922 27.22 14.86 27.22 6.85324C27.22 6.59055 27.2141 6.32934 27.2024 6.06931C28.3894 5.21524 29.4195 4.14825 30.2341 2.93315H30.2342Z" fill="black"/>
</g>
<defs>
<clipPath id="clip0_4062_37936">
<rect width="29.617" height="24" fill="white" transform="translate(0.617188 0.0921631)"/>
</clipPath>
</defs>
</svg>
''';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BasePage<LoginPage> {
  @override
  Widget buildBody() {
    Color themeColor = MyColors.getThemeColor(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [themeColor, themeColor]),
      ),
      padding: const EdgeInsets.only(
        left: 50,
        right: 50,
        top: 25,
        bottom: 25,
      ),
      child: const Column(
        children: [
          LoginLogo(),
          LoginForm(),
        ],
      ),
    );
  }

  @override
  String getTitle() {
    return '登 录';
  }

  @override
  void onShowBehavior() {
    setNavigationBarColor();
  }

  @override
  List<Widget> getActions() {
    return [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.pushNamed(context, '/setting');
        },
      ),
    ];
  }

  void setNavigationBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: MyColors.getThemeColor(context),
      ),
    );
  }
}

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: Column(
        children: [
          const SizedBox(height: 40.0),
          // Image.asset(MyContants.appLogo, width: 200, height: 200),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.175,
            child: AspectRatio(
                aspectRatio: 1,
                child: SvgPicture.string(xIcon,
                    color: Colors.white, fit: BoxFit.contain)),
          ),
          const SizedBox(height: 60.0),
          const Text(
            MyContants.appName,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}

// 登录表单
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  var _isReadLicense = false;
  var _remeberPassword = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveLoginInfo(String token, String username, String password,
      bool rememberPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 清除登录信息
    await prefs.remove('token');
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('rememberPassword');

    await prefs.setString('token', token);
    if (rememberPassword) {
      await prefs.setBool('rememberPassword', rememberPassword);
      await prefs.setString('username', username);
      await prefs.setString('password', password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Listener(
            onPointerDown: (event) => {
              FocusScope.of(context).requestFocus(_usernameFocusNode),
            },
            child: TextFormField(
              autofocus: false,
              focusNode: _usernameFocusNode,
              controller: _usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                label: Text("用户名", style: TextStyle(color: Colors.white)),
                hintText: "请输入用户名",
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 20,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "请输入用户名";
                } else {
                  return null;
                }
              },
            ),
          ),
          Listener(
            onPointerDown: (event) => {
              FocusScope.of(context).requestFocus(_passwordFocusNode),
            },
            child: TextFormField(
              autofocus: false,
              focusNode: _passwordFocusNode,
              controller: _passwordController,
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: const InputDecoration(
                label: Text("密码", style: TextStyle(color: Colors.white)),
                hintText: "请输入密码",
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.white,
                  size: 20,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "请输入密码";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    RoundCheckBox(
                        size: 16,
                        isChecked: _isReadLicense,
                        borderColor: MyColors.dividerColor,
                        checkedWidget: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                        uncheckedWidget: const Icon(
                          Icons.check,
                          color: MyColors.dividerColor,
                          size: 12,
                        ),
                        uncheckedColor: Colors.transparent,
                        animationDuration: Duration.zero,
                        onTap: (value) {
                          setState(() {
                            _isReadLicense = !_isReadLicense;
                          });
                        }),
                    Container(
                      padding: const EdgeInsets.only(left: 4),
                      child: const Text(
                        "我已阅读",
                        style: TextStyle(
                          fontSize: 13,
                          color: MyColors.dividerColor,
                        ),
                      ),
                    ),
                    Listener(
                        onPointerDown: (event) => {
                              Navigator.pushNamed(
                                context,
                                '/login-instruction',
                                arguments: {},
                              ),
                            },
                        child: const Text(
                          '登录须知',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ))
                  ],
                ),
                Row(
                  children: [
                    RoundCheckBox(
                        size: 16,
                        isChecked: _remeberPassword,
                        borderColor: MyColors.dividerColor,
                        checkedWidget: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                        uncheckedWidget: const Icon(
                          Icons.check,
                          color: MyColors.dividerColor,
                          size: 12,
                        ),
                        uncheckedColor: Colors.transparent,
                        animationDuration: Duration.zero,
                        onTap: (value) {
                          setState(() {
                            _remeberPassword = !_remeberPassword;
                          });
                        }),
                    Container(
                      padding: const EdgeInsets.only(left: 4),
                      child: const Text(
                        "记住密码",
                        style: TextStyle(
                          fontSize: 13,
                          color: MyColors.dividerColor,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "登录",
                        style: TextStyle(
                          fontSize: 18,
                          color: MyColors.getThemeColor(context),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      // 通过_formKey.currentState 获取FormState后，
                      // 调用validate()方法校验用户名密码是否合法，校验
                      // 通过后再提交数据。
                      if ((_formKey.currentState as FormState).validate()) {
                        //验证通过提交数据
                        if (!_isReadLicense) {
                          MyToast.show(context, message: "请先阅读登录须知！");
                        } else {
                          FormData data = FormData.fromMap({
                            "grant_type": "password",
                            "randomStr": DateTime.now().millisecondsSinceEpoch,
                            "username": _usernameController.text,
                            "password": md5
                                .convert(utf8.encode(
                                    "${_passwordController.text}${MyContants.appPublicKey}"))
                                .toString(),
                          });
                          String authStr = base64.encode(utf8.encode(
                              "${MyContants.clientId}:${MyContants.clientSecret}"));
                          dynamic headers = {
                            "Authorization": "Basic $authStr",
                            "TENANT-ID": MyContants.tenantId
                          };
                          SSJRequestManager.post(
                            MyAPI.authLogin,
                            data: data,
                            headers: headers,
                          ).then((res) async {
                            // 登录成功，存储Token
                            if (res.code == 200) {
                              MyToast.show(context,
                                  message: "登录成功！", needPop: false);
                              await _saveLoginInfo(
                                  "Bearer ${res.data.access_token}",
                                  _usernameController.text,
                                  _passwordController.text,
                                  _remeberPassword);
                              Timer(const Duration(microseconds: 800), () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/home', (route) => false);
                              });
                            } else {
                              MyToast.show(context,
                                  message: "登录失败！", needPop: false);
                            }
                          });
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
