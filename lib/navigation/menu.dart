import 'package:idatt2506_project/navigation/app_bar.dart';
import 'package:flutter/material.dart';
import 'menu_item.dart';

class Menu extends StatefulWidget {
  final menuItems = [
    MenuItem("New list"),
    MenuItem("test")
  ];

  Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TodoAppBar(),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.purpleAccent,
              child: ListView(
                children: widget.menuItems
                    .map((item) => MenuItemWidget(item: item))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
