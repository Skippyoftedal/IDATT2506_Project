

import 'package:flutter/material.dart';


class CriticalError extends StatelessWidget {
  show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  final String errorMessage;
  final String? errorDescription;
  const CriticalError({super.key, required this.errorMessage, this.errorDescription});

  @override
  Widget build(BuildContext context) {

    Widget ok = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(errorMessage),
      content: errorDescription != null ? Text(errorDescription!) : null,
      actions: [
        ok,
      ],
    );

    return alert;
  }
}
