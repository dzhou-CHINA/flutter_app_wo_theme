import 'package:flutter/material.dart';
import 'package:flutter_demo_app/common/color.dart';
import 'package:flutter_demo_app/pages/base.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePage<HomePage> {
  @override
  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Expanded(
        child: ElevatedButton(
          onPressed: () {
            showSnackBar();
          },
          child: const Text('Show SnackBar'),
        ),
      ),
    );
  }

  showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Awesome SnackBar!',
        style: TextStyle(color: MyColors.getThemeColor(context)),
      ),
      duration: const Duration(milliseconds: 1500),
      width: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.all(8.0),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ));
  }

  @override
  String getTitle() {
    return '首页';
  }
}
