import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class SettingsController extends BaseController<SettingsState> {
  final IAppManager _appManager;
  final ILocaleManager _localeManager;

  SettingsController(this._appManager, this._localeManager);

  @override
  SettingsState initState() => SettingsState();

  @override
  void onInit() {
    super.onInit();
    // Load App Info
    state.appVersion.value = _appManager.versionNumber;
    state.buildNumber.value = _appManager.buildNumber.toString();

    // Load saved theme
    final savedTheme = _appManager.getThemeMode();
    if (savedTheme == 'light') {
      state.themeMode.value = ThemeMode.light;
    } else if (savedTheme == 'dark') {
      state.themeMode.value = ThemeMode.dark;
    } else {
      state.themeMode.value = ThemeMode.system;
    }
  }

  void changeTheme(String modeStr) {
    ThemeMode mode;
    if (modeStr == 'light') {
      mode = ThemeMode.light;
    } else if (modeStr == 'dark') {
      mode = ThemeMode.dark;
    } else {
      mode = ThemeMode.system;
    }

    state.themeMode.value = mode;
    Get.changeThemeMode(mode); // Actually changes the app theme
    _appManager.setThemeMode(modeStr); // Save preference
  }

  void setLocale(Language language) {
    app.state.currentLanguage.value = language;
  }
}

class SettingsState extends ViewState {
  final themeMode = ThemeMode.system.obs;
  final appVersion = ''.obs;
  final buildNumber = ''.obs;
}

class SettingsBinding extends AppBindings<SettingsController> {
  SettingsBinding({required super.tag});

  final getIt = GetIt.instance;

  @override
  get controller => SettingsController(getIt(), getIt());
}
