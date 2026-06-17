import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:devstack/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    state.isMenuExpanded.value = MediaQuery.sizeOf(Get.context!).width < 800;
    state.platform.value = await _checkPlatform();
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
        Nav.encoderBase64Image,
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
        Nav.generatorQr,
      ],
      LocaleKeys.lbl_menu_other_tool.localize(): [
        Nav.textRegex,
        Nav.colorPicker,
        Nav.markdown,
        Nav.textInspector,
        Nav.codeToImage,
      ],
    });

    _updateNavigationMap();
  }

  void _updateNavigationMap() {
    final newMap = <String, List<Nav>>{};

    if (state.pinnedTools.isNotEmpty) {
      newMap[LocaleKeys.lbl_favorites.localize()] = state.pinnedTools.toList();
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

  Future<DevicePlatform> _checkPlatform() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // Ensure we are on iOS before checking iOS-specific info
    if (kIsWeb) {
      return DevicePlatform.web;
    } else if (GetPlatform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      if (info.model.toLowerCase().contains('ipad')) {
        return DevicePlatform.ipados;
      } else {
        return DevicePlatform.ios;
      }
    } else if (GetPlatform.isAndroid) {
      return DevicePlatform.android;
    } else if (GetPlatform.isMacOS) {
      return DevicePlatform.macos;
    } else if (GetPlatform.isWindows) {
      return DevicePlatform.windows;
    }
    return DevicePlatform.none;
  }

  void toggleSplitScreen() {
    state.isSplitScreen.toggle();
    if (state.isSplitScreen.value) {
      state.activePane.value = 'right';
      if (state.openTabsRight.isEmpty) state.openTabsRight.add(Nav.allTools);
    } else {
      state.activePane.value = 'left';
    }
  }

  void openTool(Nav tool, {String? targetPane}) {
    final pane = targetPane ?? state.activePane.value;

    if (pane == 'left') {
      if (!state.openTabs.contains(tool)) state.openTabs.add(tool);
      state.currentTools.value = tool;
    } else {
      if (!state.openTabsRight.contains(tool)) state.openTabsRight.add(tool);
      state.currentToolsRight.value = tool;
    }
  }

  void closeTool(Nav tool, {required String pane}) {
    if (pane == 'left') {
      state.openTabs.remove(tool);
      if (state.currentTools.value == tool) {
        state.currentTools.value =
            state.openTabs.isNotEmpty ? state.openTabs.last : Nav.allTools;
        if (state.openTabs.isEmpty) state.openTabs.add(Nav.allTools);
      }
    } else {
      state.openTabsRight.remove(tool);
      if (state.currentToolsRight.value == tool) {
        state.currentToolsRight.value = state.openTabsRight.isNotEmpty
            ? state.openTabsRight.last
            : Nav.allTools;
        if (state.openTabsRight.isEmpty) state.openTabsRight.add(Nav.allTools);
      }
    }
  }

  // --- SINGLETON PROTECTION ---
  bool canOpenTool(Nav tool, {String? targetPane}) {
    if (tool == Nav.allTools) return true;
    final pane = targetPane ?? state.activePane.value;

    if (pane == 'left') {
      return !state.openTabsRight.contains(tool);
    } else {
      return !state.openTabs.contains(tool);
    }
  }
}

class AppState extends ViewState {
  Rx<Language> currentLanguage = Language.english.obs;
  RxBool isMenuExpanded = false.obs;
  RxList<Nav> pinnedTools = <Nav>[].obs;
  RxMap<String, List<Nav>> tools = <String, List<Nav>>{}.obs;

  Rx<DevicePlatform> platform = DevicePlatform.none.obs;

  // LEFT / MAIN PANE
  Rx<Nav> currentTools = Nav.allTools.obs;
  RxList<Nav> openTabs = <Nav>[Nav.allTools].obs;

  // RIGHT PANE
  Rx<Nav> currentToolsRight = Nav.allTools.obs;
  RxList<Nav> openTabsRight = <Nav>[Nav.allTools].obs;

  // SPLIT SCREEN METADATA
  RxBool isSplitScreen = false.obs;
  RxString activePane = 'left'.obs;
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

class ActivePaneProvider extends InheritedWidget {
  final String pane;

  const ActivePaneProvider({
    super.key,
    required this.pane,
    required super.child,
  });

  static String? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ActivePaneProvider>()
        ?.pane;
  }

  @override
  bool updateShouldNotify(ActivePaneProvider oldWidget) {
    return pane != oldWidget.pane;
  }
}
