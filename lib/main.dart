import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:idatt2506_project/view/navigation/routes.dart';

import 'services/list_service.dart';

Future<void> main() async {
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _State();
}

class _State extends State<TodoApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo-app',
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(),
      home: RouteManager.home.component(context),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeTestData();
  }

  Future<void> initializeTestData() async {
    try {
      await ListService.removeAllLists();
      await ListService.addTestData(context);
    } catch (e) {
      log("Could not add testdata $e");
    }
  }

  ThemeData getAppTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, brightness: Brightness.light),
      useMaterial3: true,
      textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 20)),
    );
  }
}
