import 'dart:developer';

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:idatt2506_project/model/supported_language.dart';
import 'package:idatt2506_project/services/language_service.dart';

class TodoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TodoAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    SupportedLanguage language =SupportedLanguage.getFromLanguageCode( AppLocalizations.of(context)!.localeName);

    return AppBar(
      centerTitle: true,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      title: Padding(
        padding: const EdgeInsets.only(),
          child: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            textAlign: TextAlign.center,
          ),
      ),
      actions: [
        SizedBox(
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {



              final nextLanguage = SupportedLanguage.getNext(language);

              log("Swapping language from $language to $nextLanguage");

              language = nextLanguage;

              LanguageService().setLocale(language);
            },
            icon: Flag.fromCode(
              language.flagsCode
            ),
          ),
        )
      ],
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
