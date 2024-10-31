import 'package:flag/flag_enum.dart';
import 'dart:developer';


/// Includes all supported languages of the application
enum SupportedLanguage {
  norwegian(languageCode: "nb", flagsCode: FlagsCode.NO),
  english(languageCode: "en", flagsCode: FlagsCode.GB);

  const SupportedLanguage({
    required this.languageCode,
    required this.flagsCode,
  });

  final String languageCode;
  final FlagsCode flagsCode;

  /// Gets the next language in the list of supported languages.
  ///
  /// Index out of bounds returns the 1st language.
  static SupportedLanguage getNext(SupportedLanguage currentLanguage){
    int index = SupportedLanguage.values.indexOf(currentLanguage);
    return SupportedLanguage.values[(index + 1) % SupportedLanguage.values.length];
  }

  /// Gets a supported language based on the language code.
  ///
  /// E.g 'nb' or 'en'
  ///
  /// Defaults to 'en' (english) if the given code is not supported.
  static SupportedLanguage getFromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'nb':
        return SupportedLanguage.norwegian;
      case "en":
        return SupportedLanguage.english;
      default:
        log("Error trying to get language from language code: $languageCode");
        return SupportedLanguage.english;
    }
  }
}