import 'dart:async';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo_app/provider/app_provider.dart';
import 'package:flutter_demo_app/mixin/widget_visibility_state_mixin.dart';

abstract class BasePage<T extends StatefulWidget> extends State<T>
    with WidgetVisibilityStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  @override
  void dispose() {
    super.dispose();
    destroy();
  }

  @override
  void deactivate() {
    super.deactivate();
    var bool = ModalRoute.of(context)!.isCurrent;
    if (bool) {
      initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(getTitle()),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        actions: getActions(),
      ),
      body: buildBody(),
    );
  }

  @override
  void onShow() {
    super.onShow();
    String? currentRouteName = ModalRoute.of(context)?.settings.name;

    if (["/", "/login"].contains(currentRouteName)) {
      Timer(const Duration(milliseconds: 30), () {
        onShowBehavior();
      });
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
        ),
      );
    }
  }

  // 初始化方法
  void init() {}

  void onShowBehavior() {}

  Future<void> _initAsync() async {
    await SpUtil.getInstance();
    var colorKey = SpUtil.getString('key_theme_color') ?? 'dark';
    // 设置初始化主题颜色
    // ignore: use_build_context_synchronously
    await Provider.of<AppInfoProvider>(context, listen: false)
        .setTheme(colorKey);

    init();
  }

  // 清理资源方法
  void destroy() {}

  // 构建主体内容
  Widget buildBody() {
    return Container();
  }

  // 获取标题
  String getTitle() {
    return '';
  }

  List<Widget> getActions() {
    return [];
  }
}
