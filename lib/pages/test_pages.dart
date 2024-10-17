import 'package:flutter/material.dart';
import 'package:idatt2506_project/view/navigation/standard_scaffold.dart';

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

          ],
        ),
      ),
    );
  }
}
