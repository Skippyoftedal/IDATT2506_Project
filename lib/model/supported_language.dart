import 'package:flag/flag_enum.dart';
import 'dart:developer';
enum SupportedLanguage {
  norwegian(languageCode: "nb", flagsCode: FlagsCode.NO),
  english(languageCode: "en", flagsCode: FlagsCode.GB);

  const SupportedLanguage({
    required this.languageCode,
    required this.flagsCode,
  });

  final String languageCode;
  final FlagsCode flagsCode;


  static SupportedLanguage getNext(SupportedLanguage currentLanguage){
    if (currentLanguage == SupportedLanguage.norwegian){
      return SupportedLanguage.english;
    } else {
      return SupportedLanguage.norwegian;
    }
  }

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