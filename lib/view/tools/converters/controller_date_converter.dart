import 'package:devtoys_flutter/index.dart';

class DateConverterController extends BaseController<DateConverterState> {
  DateConverterController();

  @override
  DateConverterState initState() => DateConverterState();

  @override
  void onClose() {
    super.onClose();
  }
}

class DateConverterState extends ViewState {}

class DateConverterBinding extends AppBindings<DateConverterController> {
  DateConverterBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return DateConverterController();
  }
}
