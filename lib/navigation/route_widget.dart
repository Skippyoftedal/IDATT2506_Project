import 'package:flutter/material.dart';
import 'package:idatt2506_project/navigation/routes.dart';

class RouteWidget extends StatelessWidget {
  final TodoRoute route;

  const RouteWidget({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(route.prettyName)],
    );
  }
}