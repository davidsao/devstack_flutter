import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

import '../model/enums/language.dart';
import 'interface/interface_manager_locale.dart';

class LocaleManager implements ILocaleManager {
  final List<Language> _supportedLanguage;

  LocaleManager(this._supportedLanguage) {
    Intl.defaultLocale = supportedLanguages.first.locale.toLanguageTag();
  }

  @override
  List<Language> get supportedLanguages => _supportedLanguage;

  @override
  Language get language {
    Locale? currentLocale;
    if (Get.context != null) {
      currentLocale = EasyLocalization.of(Get.context!)?.locale;
    }

    currentLocale ??= Get.locale;

    if (currentLocale != null) {
      return Language.values.firstWhereOrNull((element) =>
              element.locale.toLanguageTag() ==
              currentLocale!.toLanguageTag()) ??
          Language.english;
    }

    return Language.english;
  }

  @override
  set language(Language lang) {
    Get.updateLocale(lang.locale);
    if (Get.context != null) {
      EasyLocalization.of(Get.context!)?.setLocale(lang.locale);
    }
    Intl.systemLocale = lang.locale.languageCode;
  }
}
