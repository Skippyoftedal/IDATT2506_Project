
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:idatt2506_project/model/supported_language.dart';

import 'package:shared_preferences/shared_preferences.dart';


/// Based partly on code from https://flutterjunction.com/how-to-change-app-language-in-flutter
class LanguageService extends ChangeNotifier {

  static const languagePreferenceKey = "locale";

  static final LanguageService _singleton = LanguageService._internal();
  LanguageService._internal();

  factory LanguageService() {
    return _singleton;
  }

  static final Locale _defaultLocale = Locale(SupportedLanguage.norwegian.languageCode);
  Locale _locale = _defaultLocale;

  Future<void> fetchLocale() async {
    var preferences = await SharedPreferences.getInstance();
    String? storedLocale = preferences.getString(languagePreferenceKey);
    if (storedLocale == null) {
      _locale = _defaultLocale;
    } else {
      _locale = Locale(storedLocale);
      notifyListeners();
    }
  }

  void setLocale(SupportedLanguage language) async {
    var preferences = await SharedPreferences.getInstance();
    if (_locale.languageCode == language.languageCode) {
      return;
    }
    _locale = Locale(language.languageCode);
    await preferences.setString(languagePreferenceKey, language.languageCode);

    notifyListeners();
  }

  get _locales {
    return SupportedLanguage.values.map((it) => Locale(it.languageCode));
  }

  static const _localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  get supportedLocales {
    return _locales;
  }

  get localizationsDelegates {
    return _localizationsDelegates;
  }

  get locale {
    return _locale;
  }
}

