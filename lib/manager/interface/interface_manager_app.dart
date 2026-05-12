abstract class IAppManager {
  Future<void> init();

  String get versionNumber;

  int get buildNumber;

  void clear();
}
