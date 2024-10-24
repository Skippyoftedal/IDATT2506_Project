import'package:flutter_gen/gen_l10n/app_localizations.dart';


class InputValidator{

  static void validListName(String listName, context){
    if (listName.isEmpty) throw ArgumentError(AppLocalizations.of(context)!.emptyTitleError);
    if (listName.trim().isEmpty) throw ArgumentError(AppLocalizations.of(context)!.whitespaceTitleError);
  }








}