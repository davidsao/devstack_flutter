import 'package:devtoys_flutter/index.dart';

class JsonYamlController extends BaseController<JsonYamlState> {
  JsonYamlController();

  @override
  JsonYamlState initState() => JsonYamlState();

  @override
  void onClose() {
    super.onClose();
  }
}

class JsonYamlState extends ViewState {}

class JsonYamlBinding extends AppBindings<JsonYamlController> {
  JsonYamlBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return JsonYamlController();
  }
}
