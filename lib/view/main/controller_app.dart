import 'dart:async';

import 'package:devtoys_flutter/index.dart';
import 'package:get_it/get_it.dart';

class AppController extends BaseController<AppState> {
  AppController(
    this._appManager,
  );

  final IAppManager _appManager;

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
  }
}

class AppState extends ViewState {}

class AppBinding extends AppBindings<AppController> {
  AppBinding({required super.tag});

  @override
  AppController get controller {
    final getIt = GetIt.instance;
    return AppController(
      getIt(),
    );
  }
}
