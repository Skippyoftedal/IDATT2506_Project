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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: Icon(
                  IconData(route.iconCodePoint,
                      fontFamily: 'MaterialIcons'),
                color: Theme.of(context).colorScheme.primary,
                size: 40.0,
              ),
              title: Text(route.prettyName),
              trailing: trailing,
            ),
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
