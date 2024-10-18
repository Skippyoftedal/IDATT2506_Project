import 'package:flutter/material.dart';
import 'package:idatt2506_project/view/navigation/app_bar.dart';

import 'app_drawer.dart';

class StandardScaffold extends StatelessWidget {
  const StandardScaffold({super.key, required this.body, this.title});
  final Widget body;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  TodoAppBar(
        title: title ?? "Todo",
      ),
      body: body,
      drawer: const AppDrawer(),
    );
  }
}
