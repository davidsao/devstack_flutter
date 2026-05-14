abstract class IAppManager {
  Future<void> init();

  String get versionNumber;

  int get buildNumber;

  void clear();

  List<String> getPinnedTools();
  Future<void> togglePinnedTool(String toolName);

  String getThemeMode();
  Future<void> setThemeMode(String mode);
}
