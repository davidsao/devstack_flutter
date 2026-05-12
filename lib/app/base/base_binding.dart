import 'package:devtoys_flutter/index.dart';
import 'package:get/get.dart';

abstract class AppBindings<T extends BaseController> extends Bindings {
  AppBindings({required this.tag});
  String? tag;

  T get controller;

  @override
  void dependencies() {
    Get.put(controller, tag: tag);
  }
}
