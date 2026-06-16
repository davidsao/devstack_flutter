import 'package:devstack/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseBottomSheetView<T extends BaseController<S>,
    S extends ViewState> extends BaseWidget<T, S> {
  BaseBottomSheetView({super.key, super.viewTag, super.bindingCreator});
  double? heightFactor;
  bool swipeToDismiss = true;
  bool dismissible = true;
  Color backgroundColor = Colors.white;

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    createBinding();
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        view(
          context,
        ).marginOnly(top: swipeToDismiss ? AppDimens.marginText : 0),
        if (swipeToDismiss)
          Container(
            width: 48,
            height: AppDimens.radiusSmall / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
            ).copyWith(color: AppColors.disable),
          ).marginOnly(top: AppDimens.paddingSmaller),
      ],
    );
  }
}
