

import 'package:flutter/material.dart';

class TodoAppTheme{


  static ThemeData getAppTheme({dark = false}) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: dark ? Brightness.dark : Brightness.light),
      useMaterial3: true,
      textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 20)),
    );
  }

}
