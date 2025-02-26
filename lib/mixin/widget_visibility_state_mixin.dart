import 'package:flutter/material.dart';

///页面状态 显示\隐藏
enum VisibilityState { hide, show }

mixin WidgetVisibilityStateMixin<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
  late FocusNode _ownFocusNode, _oldFocusNode, _newFocusNode;
  VisibilityState visibilityState = VisibilityState.hide;

  ///忽略的焦点列表
  List<FocusNode> _ignoreFocusList = [];

  List<FocusNode> get ignoreFocusList => _ignoreFocusList;

  set ignoreFocusList(List<FocusNode> list) => _ignoreFocusList = list;

  ///显示
  void onShow() {
    visibilityState = VisibilityState.show;
  }

  ///不显示
  void onHide() {
    visibilityState = VisibilityState.hide;
  }

  _addFocusNodeChangeCb() {
    _ownFocusNode =
        _oldFocusNode = _newFocusNode = FocusManager.instance.primaryFocus!;
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPersistentFrameCallback(focusNodeChangeCb);
    onShow();
  }

  ///焦点判断
  void focusNodeChangeCb(_) {
    _newFocusNode = FocusManager.instance.primaryFocus!;
    if (_newFocusNode == _oldFocusNode) return;
    _oldFocusNode = _newFocusNode;

    if (_judgeNeedIgnore(_newFocusNode)) return;
    if (_newFocusNode == _ownFocusNode) {
      if (visibilityState != VisibilityState.show) {
        onShow();
      }
    } else {
      if (visibilityState != VisibilityState.hide) {
        onHide();
      }
    }
  }

  ///忽略焦点值
  bool _judgeNeedIgnore(focusNode) {
    return _ignoreFocusList.contains(focusNode);
  }

  @override
  void initState() {
    super.initState();
    Future(_addFocusNodeChangeCb);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
