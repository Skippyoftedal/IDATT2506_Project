import 'package:flutter/material.dart';
import 'package:idatt2506_project/view/navigation/app_bar.dart';

import 'app_drawer.dart';

class StandardScaffold extends StatelessWidget {
  const StandardScaffold({super.key, required this.body});
  final Widget body;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TodoAppBar(),
      body: body,
      drawer: const AppDrawer(),
    );
    
  }
}
