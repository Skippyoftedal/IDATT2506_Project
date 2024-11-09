

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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


  factory CriticalError.generic(BuildContext context){
    return CriticalError(errorMessage: AppLocalizations.of(context)?.genericError ?? "");
  }

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
