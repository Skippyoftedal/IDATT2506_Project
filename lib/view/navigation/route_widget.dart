import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:idatt2506_project/view/navigation/todo_route.dart';

class RouteWidget extends StatelessWidget {
  final TodoRoute route;
  final Widget? trailing;
  const RouteWidget({super.key, required this.route, this.trailing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigate(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: ListTile(
          leading: Icon(
            route.icon,
            color: Theme.of(context).colorScheme.primary,
            size: 40.0,
          ),
          title: Text(route.prettyName),
          trailing: trailing,
        ),
      ),
    );
  }

  void navigate(context) {
    log("Navigating to ${route.prettyName}");
    Navigator.of(context).push(
      MaterialPageRoute(builder: route.component),
    );
  }
}
