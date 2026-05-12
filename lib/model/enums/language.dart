import 'dart:ui';

enum Language {
  english,
  traditionalChinese,
  simplifiedChinese,
  japanese,
  korean,
  spanish,
  french,
}

extension LanguagesExtension on Language {
  Locale get locale {
    switch (this) {
      case Language.english:
        return const Locale("en");
      case Language.traditionalChinese:
        return const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
        );
      case Language.simplifiedChinese:
        return const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hans',
        );
      case Language.japanese:
        return const Locale("ja");
      case Language.korean:
        return const Locale("ko");
      case Language.spanish:
        return const Locale("es");
      case Language.french:
        return const Locale("fr");
    }
  }

  String get display {
    switch (this) {
      case Language.english:
        return 'English';
      case Language.traditionalChinese:
        return '繁體中文';
      case Language.simplifiedChinese:
        return '簡体中文';
      case Language.japanese:
        return '日本語';
      case Language.korean:
        return '한국어';
      case Language.spanish:
        return 'Español';
      case Language.french:
        return 'Français';
    }
  }
}
