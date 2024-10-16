import 'package:flutter/cupertino.dart';

import '../model/todo_item.dart';
import '../model/user_info.dart';
import '../navigation/menu.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final UserInfo userInfo = UserInfo("Tobias oftedal");

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var items = [TodoItem("item1"), TodoItem("item 2")];

  @override
  Widget build(BuildContext context) {
    return Menu();
  }
}