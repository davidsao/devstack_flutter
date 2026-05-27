import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

abstract class BaseView<T extends BaseController<S>, S extends ViewState>
    extends GetView<T> {
  const BaseView({super.key, this.viewTag});
  final String? viewTag;

  AppController get app => GetInstance().find<AppController>();

  @override
  T get controller {
    try {
      return GetInstance().find<T>(tag: viewTag);
    } on Error {
      return GetInstance().find<T>(tag: null);
    }
  }

  S get state => controller.state;

  BuildContext get context => Get.context!;

  TextTheme get textTheme => Get.textTheme;

  void unfocusAll() {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void init() {}

  Widget view(BuildContext context);

  @override
  Widget build(BuildContext context) {
    init();
    return view(context);
  }
}
