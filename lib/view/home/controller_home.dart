import 'dart:async';

import 'package:devtoys_flutter/index.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../generated/locale_keys.g.dart';
// import 'package:ndef/ndef.dart' as ndef;

class HomeController extends BaseController<HomeState> {
  final IAppManager _appManager;

  HomeController(
    this._appManager,
  );

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
  void onReady() {
    super.onReady();
  }

  @override
  HomeState initState() {
    final state = HomeState();
    return state;
  }

  @override
  void onResumed() {
    super.onResumed();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class HomeState extends ViewState {
  RxMap<String, List<Nav>> bottomNavigation = <String, List<Nav>>{}.obs;
  Rx<Nav> currentBottomNavigation = Nav.converterDate.obs;

  RxBool isMenuExpanded = true.obs;
}

class HomeBinding extends AppBindings<HomeController> {
  HomeBinding({required super.tag});

  @override
  get controller {
    final get = GetIt.instance;
    return HomeController(
      get(),
    );
  }
}
