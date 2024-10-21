import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:idatt2506_project/services/test_data_service.dart';
import 'package:idatt2506_project/services/route_service.dart';
import 'package:idatt2506_project/view/theme/themes.dart';

import 'services/list_service.dart';

Future<void> main() async {
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo-app',
      debugShowCheckedModeBanner: false,
      theme: TodoAppTheme.getAppTheme(),
      darkTheme: TodoAppTheme.getAppTheme(dark: true),
      home: RouteService.home.component(context),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeTestData();
  }

  Future<void> initializeTestData() async {
    final AssetBundle rootBundle = DefaultAssetBundle.of(context);
    try {
      await ListService.deleteAllLists();
      await TestDataService.addTestData(rootBundle);
    } catch (e) {
      log("Could not add testdata $e");
    }
  }


}
