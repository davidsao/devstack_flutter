import 'dart:async';

import 'package:devtoys_flutter/index.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../generated/locale_keys.g.dart';

class HomeController extends BaseController<HomeState> {
  final IAppManager _appManager;
  HomeController(this._appManager);
  bool? _wasMobile;

  @override
  Future<void> onInit() async {
    super.onInit();
    state.bottomNavigation.value = {
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
      ],
      LocaleKeys.lbl_menu_generator.localize(): [
        Nav.generatorHash,
        Nav.generatorLoremIpsum,
        Nav.generatorUuid,
      ],
    };
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
      state.isMenuExpanded.value = !isMobile;
    }
  }
}

class HomeState extends ViewState {
  RxMap<String, List<Nav>> bottomNavigation = <String, List<Nav>>{}.obs;
  Rx<Nav> currentBottomNavigation = Nav.converterDate.obs;
  RxBool isMenuExpanded = true.obs;

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
