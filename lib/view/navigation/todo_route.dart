import 'package:flutter/material.dart';

//TODO move this file
class TodoRoute {
  static final int defaultCodePoint = Icons.error_outline_sharp.codePoint;

  final String prettyName;
  final Widget Function(BuildContext) component;
  final int iconCodePoint;

  TodoRoute(this.prettyName, this.component, int? iconCodePoint)
      : iconCodePoint = iconCodePoint ?? defaultCodePoint;
}