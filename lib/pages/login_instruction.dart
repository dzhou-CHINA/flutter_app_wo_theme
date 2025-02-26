// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_demo_app/common/color.dart';
import 'package:flutter_demo_app/pages/base.dart';

class LoginInstructionPage extends StatefulWidget {
  const LoginInstructionPage({super.key});

  @override
  _LoginInstructionPageState createState() => _LoginInstructionPageState();
}

class _LoginInstructionPageState extends BasePage<LoginInstructionPage> {
  @override
  Widget buildBody() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          InstructionChild(
            title: "使用目的：",
            content: [
              '该小程序旨在对园区范围内交通道路的相关工单进行运维管理。实现交警中队或大队发布工单->实施单位在移动端接受->实施单位完成后在移动端反馈竣工->交警部门及市政单位验收同意后审批通过的闭环式工单业务流转。'
            ],
          ),
          InstructionChild(
            title: "使用用户：",
            content: [
              '交通中队：作为该系统使用方使用方，负责工单事件的上报以及对工单流程进行跟踪管理。 各中队仅设置一个账户登录，具体使用人员使用该账号登录该中队管理界面。',
              '道路施工单位：道路交通施工单位作为该系统使用方，负责上报施工前预算信息、反馈施工完成后的决算信息及施工结束后的现场情况。由于施工人员的变动较大，且交警只需要管理到该项目及其负责人层面，因此每个施工单位仅需一个登陆账号即可。'
            ],
            withIndex: true,
          )
        ],
      ),
    );
  }

  @override
  String getTitle() {
    return '登录须知';
  }
}

class InstructionChild extends StatefulWidget {
  // 成员变量
  final String title;
  final bool withIndex;
  final List<String> content;

  const InstructionChild({
    super.key,
    this.title = "title",
    this.content = const [],
    this.withIndex = false,
  });

  @override
  State<InstructionChild> createState() =>
      _InstructionChildState(title, content, withIndex);
}

class _InstructionChildState extends State<InstructionChild> {
  // 成员变量
  String title;
  bool widthIndex;
  List<String> content;

  // 构造函数
  _InstructionChildState(this.title, this.content, this.widthIndex);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: MyColors.getDisplayTextColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: content.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  widthIndex
                      ? '${index + 1}、 ${content[index]}'
                      : content[index],
                  style: const TextStyle(
                    color: MyColors.infoColor,
                    fontSize: 15,
                    height: 1.25,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
