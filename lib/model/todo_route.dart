import 'package:flutter/material.dart';

class TodoRoute {
  /// Fallback codepoint
  static final int defaultCodePoint = Icons.error_outline_sharp.codePoint;

  /// The name shown in the drawer
  String prettyName;

  /// The widget being loaded when clicked
  final Widget Function(BuildContext) component;

  /// The icon shown besides the name
  final int iconCodePoint;

  TodoRoute(this.prettyName, this.component, int? iconCodePoint)
      : iconCodePoint = iconCodePoint ?? defaultCodePoint;
}