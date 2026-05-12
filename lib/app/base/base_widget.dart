import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseWidget<T extends BaseController<S>, S extends ViewState>
    extends BaseView<T, S> {
  const BaseWidget({super.key, super.viewTag, this.bindingCreator});
  final BindingCreator<Bindings>? bindingCreator;

  Widget view(BuildContext context);

  @override
  Widget build(BuildContext context) {
    createBinding();
    return view(context);
  }

  void createBinding() {
    final Bindings? binding = bindingCreator?.call();
    binding?.dependencies();
  }
}
