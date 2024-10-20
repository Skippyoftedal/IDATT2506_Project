import 'package:flutter/material.dart';

class TodoRoute {
  static final int defaultCodePoint = Icons.error_outline_sharp.codePoint;

  final String prettyName;
  final Widget Function(BuildContext) component;
  final int iconCodePoint;

  TodoRoute(this.prettyName, this.component, int? iconCodePoint)
      : iconCodePoint = iconCodePoint ?? defaultCodePoint;
}