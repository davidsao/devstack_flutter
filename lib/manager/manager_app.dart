import 'package:shared_preferences/shared_preferences.dart';

import 'interface/interface_manager_app.dart';

class AppManager implements IAppManager {
  late SharedPreferences _prefs;
  // ignore: constant_identifier_names
  final int number;
  final String version;

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
  // TODO: implement versionNumber
  String get versionNumber => version;
}
