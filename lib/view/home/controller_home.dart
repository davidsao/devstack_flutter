import 'dart:async';

import 'package:devtoys_flutter/index.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class HomeController extends BaseController<HomeState> {
  final IAppManager _appManager;
  HomeController(this._appManager);
  bool? _wasMobile;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  HomeState initState() {
    return HomeState();
  }

  void onSearchChanged(String query) {
    state.searchQuery.value = query.toLowerCase();
  }

  void toggleCategory(String categoryKey) {
    if (state.collapsedCategories.contains(categoryKey)) {
      state.collapsedCategories.remove(categoryKey);
    } else {
      state.collapsedCategories.add(categoryKey);
    }
  }

  void updateResponsiveState(double width) {
    // 800px is a standard breakpoint for Desktop/Tablet vs Mobile
    bool isMobile = width < 800;

    // Only auto-toggle if the screen TYPE actually changed
    if (_wasMobile != isMobile) {
      _wasMobile = isMobile;
      // Auto-expand on desktop, auto-collapse on mobile
      app.state.isMenuExpanded.value = !isMobile;
    }
  }
}

class HomeState extends ViewState {
  RxString searchQuery = ''.obs;
  RxSet<String> collapsedCategories = <String>{}.obs;
}

class HomeBinding extends AppBindings<HomeController> {
  HomeBinding({required super.tag});

  @override
  get controller {
    final get = GetIt.instance;
    return HomeController(get());
  }
}
