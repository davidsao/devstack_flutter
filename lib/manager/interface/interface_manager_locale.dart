import 'package:devstack/index.dart';

abstract class ILocaleManager {
  List<Language> get supportedLanguages;

  Language get language;
  set language(Language lang);
}
