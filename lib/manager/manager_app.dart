import 'package:shared_preferences/shared_preferences.dart';

import 'interface/interface_manager_app.dart';

class AppManager implements IAppManager {
  late SharedPreferences _prefs;
  // ignore: constant_identifier_names
  final int number;
  final String version;

  static const String _pinnedToolsKey = 'pinned_tools';
  static const String _themeModeKey = 'theme_mode';

  AppManager(this.number, this.version);

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  int get buildNumber => number;

  @override
  void clear() {}

  @override
  String get versionNumber => version;

  @override
  List<String> getPinnedTools() {
    return _prefs.getStringList(_pinnedToolsKey) ?? [];
  }

  @override
  Future<void> togglePinnedTool(String toolName) async {
    final tools = getPinnedTools();
    if (tools.contains(toolName)) {
      tools.remove(toolName);
    } else {
      tools.add(toolName);
    }
    await _prefs.setStringList(_pinnedToolsKey, tools);
  }

  @override
  String getThemeMode() {
    return _prefs.getString(_themeModeKey) ?? 'system';
  }

  @override
  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeModeKey, mode);
  }
}
