import 'package:devtoys_flutter/index.dart';

class NumberBaseController extends BaseController<NumberBaseState> {
  NumberBaseController();

  @override
  NumberBaseState initState() => NumberBaseState();

  @override
  void onClose() {
    super.onClose();
  }
}

class NumberBaseState extends ViewState {}

class NumberBaseBinding extends AppBindings<NumberBaseController> {
  NumberBaseBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return NumberBaseController();
  }
}
