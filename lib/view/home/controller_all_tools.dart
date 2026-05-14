import 'package:devtoys_flutter/index.dart';

class AllToolsState extends ViewState {}

class AllToolsController extends BaseController<AllToolsState> {
  @override
  AllToolsState initState() => AllToolsState();
}

class AllToolsBinding extends AppBindings<AllToolsController> {
  AllToolsBinding({required super.tag});

  @override
  get controller => AllToolsController();
}
