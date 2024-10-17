import 'package:flutter/material.dart';

class TodoRoute {
  final String prettyName;

  final Widget Function(BuildContext) component;
  IconData icon;

  TodoRoute(this.prettyName, this.component, [IconData? icon])
      : icon = icon ?? Icons.accessibility;
}