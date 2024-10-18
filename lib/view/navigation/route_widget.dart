import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:idatt2506_project/view/navigation/todo_route.dart';

class RouteWidget extends StatelessWidget {
  final TodoRoute route;

  const RouteWidget({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigate(context),
      child: Row(
        children: [
          Icon(
            route.icon,
            color: Colors.white,
            size: 40.0,
          ),
          Text(route.prettyName),
        ],
      ),
    );
  }

  void navigate(context){
    log("Navigating to ${route.prettyName}");
    Navigator.of(context).push(
      MaterialPageRoute(builder: route.component),
    );
  }
}
