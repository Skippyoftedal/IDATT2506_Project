import 'package:flutter/material.dart';

class TodoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TodoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Todo'),
      backgroundColor: Colors.blue,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
