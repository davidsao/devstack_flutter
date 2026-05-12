import 'package:devtoys_flutter/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
abstract class BaseDialogView<Controller extends BaseController<State>,
    State extends ViewState> extends BaseView<Controller, State> {
  @override
  final String? viewTag;
  final BindingCreator<Bindings>? bindingCreator;

  Color backgroundColor = Colors.white;

  BaseDialogView({
    super.key,
    this.viewTag,
    this.bindingCreator,
  }) : super(viewTag: viewTag);

  @override
  @nonVirtual
  Widget view(BuildContext context) {
    _createBinding();
    return view(context);
  }

  void _createBinding() {
    if (bindingCreator == null) {
      return;
    }
    Bindings? binding = bindingCreator?.call();
    binding?.dependencies();
  }
}
