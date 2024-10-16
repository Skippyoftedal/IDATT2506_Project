import 'package:idatt2506_project/navigation/app_bar.dart';
import 'package:idatt2506_project/navigation/app_drawer.dart';
import 'package:flutter/material.dart';

class StandardScaffold extends StatelessWidget {
  StandardScaffold({super.key, required this.body});
  Widget body;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TodoAppBar(),
      body: body,
      drawer: AppDrawer(),
    );
    
  }
}
