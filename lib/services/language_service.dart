import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:idatt2506_project/model/supported_language.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Handles the storage and changing of language in the app
///
/// Note: based partly on code from https://flutterjunction.com/how-to-change-app-language-in-flutter
class LanguageService extends ChangeNotifier {
  /// Key used to store the language preference
  static const _languagePreferenceKey = "locale";

  static final LanguageService _singleton = LanguageService._internal();

  /// The default starting locale
  static final Locale _defaultLocale =
      Locale(SupportedLanguage.norwegian.languageCode);

  /// Returns the singleton instance of the language service
  factory LanguageService() {
    return _singleton;
  }

  LanguageService._internal();

  Locale _locale = _defaultLocale;

  /// Gets the current local, and updates the listener in main
  Future<void> fetchLocale() async {
    var preferences = await SharedPreferences.getInstance();
    String? storedLocale = preferences.getString(_languagePreferenceKey);
    if (storedLocale == null) {
      _locale = _defaultLocale;
    } else {
      _locale = Locale(storedLocale);
      notifyListeners();
    }
  }

  /// Sets the current local, and updates the listener in main
  void setLocale(SupportedLanguage language) async {
    var preferences = await SharedPreferences.getInstance();
    if (_locale.languageCode == language.languageCode) {
      return;
    }
    _locale = Locale(language.languageCode);
    await preferences.setString(_languagePreferenceKey, language.languageCode);

    notifyListeners();
  }

  /// Gets all supported languages as an iterable of [Locale]
  Iterable<Locale> get supportedLocales {
    return SupportedLanguage.values.map((it) => Locale(it.languageCode));
  }

  static const _localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  List<LocalizationsDelegate<Object>> get localizationsDelegates {
    return _localizationsDelegates;
  }

  Locale get locale {
    return _locale;
  }
}
