import 'package:devstack/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig extends StatefulWidget {
  final Flavor flavor;
  final FlavorValues values;

  static const String emailValidator = "email_validator";

  GetIt get _get => GetIt.instance;

  const AppConfig(this.flavor, this.values, {super.key});

  Future<void> init() async {
    await _initFlavor();
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    await provideApiModules();
    provideAppModules();
  }

  @override
  State<StatefulWidget> createState() {
    return _AppConfigState();
  }

  static const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  Future<void> _initFlavor() async {
    switch (flavor) {
      case Flavor.dev:
        await dotenv.load(fileName: "env/.env.dev");
        break;
      case Flavor.qa:
        await dotenv.load(fileName: "env/.env.qa");
        break;
      case Flavor.uat:
        await dotenv.load(fileName: "env/.env.uat");
        break;
      case Flavor.prod:
        await dotenv.load(fileName: "env/.env.prod");
        break;
    }
  }

  Future<void> provideApiModules() async {
    final appInfo = await PackageInfo.fromPlatform();
    final appManager = AppManager(
      int.parse(appInfo.buildNumber),
      appInfo.version,
    );
    await appManager.init();
    _get.registerSingleton<ILocaleManager>(
      LocaleManager(values.supportLanguages),
    );
    _get.registerSingleton<IAppManager>(appManager);
  }

  void provideAppModules() {
    Get.lazyPut(() => AppController(_get(), _get()), fenix: true);
    Get.lazyPut(() => HomeController(_get()), fenix: true);
    Get.lazyPut(() => AllToolsController(), fenix: true);
    Get.lazyPut(() => SettingsController(_get(), _get()), fenix: true);
    Get.lazyPut(() => UrlEncoderController(), fenix: true);
    Get.lazyPut(() => HtmlEncoderController(), fenix: true);
    Get.lazyPut(() => Base64EncoderController(), fenix: true);
    Get.lazyPut(() => Base64ImageController(), fenix: true);
    Get.lazyPut(() => JwtEncoderController(), fenix: true);
    Get.lazyPut(() => DateConverterController(), fenix: true);
    Get.lazyPut(() => JsonYamlController(), fenix: true);
    Get.lazyPut(() => NumberBaseController(), fenix: true);
    Get.lazyPut(() => JsonFormatterController(), fenix: true);
    Get.lazyPut(() => SqlFormatterController(), fenix: true);
    Get.lazyPut(() => XmlFormatterController(), fenix: true);
    Get.lazyPut(() => MinifierController(), fenix: true);
    Get.lazyPut(() => HashGeneratorController(), fenix: true);
    Get.lazyPut(() => UuidGeneratorController(), fenix: true);
    Get.lazyPut(() => LoremIpsumGeneratorController(), fenix: true);
    Get.lazyPut(() => QrGeneratorController(), fenix: true);
    Get.lazyPut(() => RegexTesterController(), fenix: true);
    Get.lazyPut(() => ColorPickerController(), fenix: true);
    Get.lazyPut(() => MarkdownPreviewController(), fenix: true);
  }
}

class _AppConfigState extends State<AppConfig> {
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales:
          widget.values.supportLanguages.map((it) => it.locale).toList(),
      path: "assets/strings",
      child: MainApp(widget.flavor, widget.values),
    );
  }
}
