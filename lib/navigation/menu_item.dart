import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuItem {
  final String displayValue;

  MenuItem(this.displayValue);
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;

  const MenuItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.displayValue),
          ],
        ),

    );
  }
}
