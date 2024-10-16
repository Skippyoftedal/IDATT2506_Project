import 'package:idatt2506_project/navigation/app_drawer.dart';
import 'package:idatt2506_project/navigation/standard_scaffold.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final String pageTitle;

  const TestPage({super.key, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return StandardScaffold(
      body: Center(
        child: ListView(
          children: [
            Text(pageTitle),
            Builder(
              builder: (context) {
                return MaterialButton(
                  child: const Text("Press"),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
