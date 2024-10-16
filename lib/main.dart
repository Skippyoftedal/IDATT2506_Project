import 'dart:convert';
import 'dart:io';

import 'package:idatt2506_project/navigation/routes.dart';

import 'package:flutter/material.dart';


Future<void> main() async {

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: getMainPage(),
      routes: getRoutesForRouter(),
    );
  }

}

