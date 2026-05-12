import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app/app_config.dart';
import 'app/app_flavor_values.dart';
import 'model/enums/flavors.dart';
import 'model/enums/language.dart';

void main() async {
  final appConfig = AppConfig(
    Flavor.fromString("qa"),
    FlavorValues(
      supportLanguages: [Language.traditionalChinese, Language.english],
    ),
  );

  await appConfig.init();
  await GetIt.instance.allReady();
  runApp(appConfig);
}
