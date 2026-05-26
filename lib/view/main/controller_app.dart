import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:devtoys_flutter/index.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../generated/locale_keys.g.dart';

class AppController extends BaseController<AppState> {
  AppController(
    this._appManager,
    this._localeManager,
  );

  final IAppManager _appManager;
  final ILocaleManager _localeManager;
  final Map<String, List<Nav>> _baseCategories = {};

  @override
  AppState initState() {
    final state = AppState();
    return state;
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    state.isIpad.value = await isIpad();
    state.currentLanguage.value = _localeManager.language;

    state.currentLanguage.listen((e) {
      _localeManager.language = e;
      Future.delayed(const Duration(milliseconds: 200), () {
        _initTools();
      });
    });

    _initTools();

    final pinnedNames = _appManager.getPinnedTools();

    final allTools = _baseCategories.values.expand((e) => e).toList();

    for (final name in pinnedNames) {
      final nav = allTools.firstWhereOrNull((n) => n.getName == name);
      if (nav != null) {
        state.pinnedTools.add(nav);
      }
    }

    _updateNavigationMap();
  }

  void _initTools() {
    _baseCategories.clear();

    _baseCategories.addAll({
      LocaleKeys.lbl_menu_converter.localize(): [
        Nav.converterJsonYaml,
        Nav.converterNumberBase,
        Nav.converterDate,
      ],
      LocaleKeys.lbl_menu_encoder.localize(): [
        Nav.encoderHtml,
        Nav.encoderUrl,
        Nav.encoderBase64,
        Nav.encoderJwt,
      ],
      LocaleKeys.lbl_menu_formatter.localize(): [
        Nav.formatterJson,
        Nav.formatterXml,
        Nav.formatterSql,
        Nav.minifier,
      ],
      LocaleKeys.lbl_menu_generator.localize(): [
        Nav.generatorHash,
        Nav.generatorLoremIpsum,
        Nav.generatorUuid,
        Nav.generatorChecksum,
        Nav.generatorQr,
      ],
    });

    _updateNavigationMap();
  }

  void _updateNavigationMap() {
    final newMap = <String, List<Nav>>{};

    if (state.pinnedTools.isNotEmpty) {
      newMap['Favorites'] = state.pinnedTools.toList();
    }

    newMap.addAll(_baseCategories);
    state.tools.value = newMap;
  }

  void togglePin(Nav nav) {
    final name = nav.getName;
    if (name == null) return;

    if (state.pinnedTools.contains(nav)) {
      state.pinnedTools.remove(nav);
    } else {
      state.pinnedTools.add(nav);
    }

    _appManager.togglePinnedTool(name);
    _updateNavigationMap();
  }

  Future<bool> isIpad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // Ensure we are on iOS before checking iOS-specific info
    if (GetPlatform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      return info.model.toLowerCase().contains('ipad');
    }
    return false;
  }
}

class AppState extends ViewState {
  Rx<Language> currentLanguage = Language.english.obs;
  RxBool isMenuExpanded = true.obs;
  RxList<Nav> pinnedTools = <Nav>[].obs;
  RxMap<String, List<Nav>> tools = <String, List<Nav>>{}.obs;
  Rx<Nav> currentTools = Nav.allTools.obs;
  RxBool isIpad = false.obs;
}

class AppBinding extends AppBindings<AppController> {
  AppBinding({required super.tag});

  @override
  AppController get controller {
    final getIt = GetIt.instance;
    return AppController(
      getIt(),
      getIt(),
    );
  }
}
