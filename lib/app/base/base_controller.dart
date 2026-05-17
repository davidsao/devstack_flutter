import 'dart:io';

import 'package:devtoys_flutter/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

abstract class BaseController<S extends ViewState>
    extends FullLifeCycleController with FullLifeCycleMixin {
  BaseController() {
    state = initState();
    $configureLifeCycle();
  }
  S initState();

  late S state;

  BuildContext? get context {
    return Get.context;
  }

  AppController get app => GetInstance().find<AppController>();

  final numberFormat = NumberFormat("###,###,###.#", "en_US");
  final dateFormat = DateFormat("dd/MM/yyyy", "en_US");
  final dateTimeFormat = DateFormat("dd/MM/yyyy, HH:mm", "en_US");
  final serverTimeFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ", "en_US");

  Map<String, dynamic>? get args {
    return Get.arguments as Map<String, dynamic>?;
  }

  void restart() {
    final getIt = GetIt.instance;
    Get
      ..deleteAll()
      ..offAll(
        HomePage(),
        popGesture: false,
        routeName: "splash",
        fullscreenDialog: true,
        transition: (GetPlatform.isMobile && Platform.isAndroid)
            ? Transition.downToUp
            : null,
      )
      ..lazyPut(
        () => AppController(
          getIt(),
          getIt(),
        ),
        fenix: true,
      );
  }

  Future<void> back({Nav? to, Object? result}) async {
    if (to == null) {
      // back to previous page
      return Get.back(result: result);
    } else {
      // back to specific page
      return Get.until((route) {
        if (route is GetPageRoute) {
          return route.routeName == "/${to.screenName}";
        } else {
          return false;
        }
      });
    }
  }

  /// Navigate to new page as a new session to user
  Future<dynamic> navigate(
    Nav nav, {
    String? tag,
    Map<String, dynamic>? args,
    Nav? popUtil,
    Object? itemId,
    bool newInstance = false,
  }) async {
    final widget = nav.getWidget(tag);
    if (widget is BaseBottomSheetView) {
      return _pushBottomSheet(
        nav: nav,
        heightFactor: widget.heightFactor,
        swipeToDismiss: widget.swipeToDismiss,
        dismissible: widget.dismissible,
        backgroundColor: widget.backgroundColor,
        tag: tag,
      );
    }
    if (widget is BaseDialogView) {
      return _pushDialog(nav, tag: tag, args: args);
    }

    if (popUtil == nav) {
      return await Get.off(
        () => nav.getWidget(tag),
        routeName: tag ?? nav.screenName,
        preventDuplicates: false,
        binding: nav.getBindings(newInstance ? tag : null),
        fullscreenDialog: true,
        transition: (GetPlatform.isMobile && Platform.isAndroid)
            ? Transition.downToUp
            : null,
        duration: const Duration(milliseconds: 400),
      );
    }
    if (popUtil != null) {
      return await Get.offUntil(
        GetPageRoute(
          routeName: "/${tag ?? nav.screenName}",
          page: () => nav.getWidget(tag),
          binding: nav.getBindings(newInstance ? tag : null),
          settings: RouteSettings(arguments: null),
          fullscreenDialog: true,
          transition: (GetPlatform.isMobile && Platform.isAndroid)
              ? Transition.downToUp
              : null,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        (route) {
          if (route is GetPageRoute) {
            return route.routeName == "/${popUtil.screenName}";
          } else {
            return false;
          }
        },
      );
    }
    return await Get.to(
      () => widget,
      routeName: tag ?? nav.screenName,
      preventDuplicates: false,
      fullscreenDialog: true,
      binding: nav.getBindings(newInstance ? tag : null),
      transition: (GetPlatform.isMobile && Platform.isAndroid)
          ? Transition.downToUp
          : null,
      duration: const Duration(milliseconds: 400),
    );
  }

  /*
   * direct to the next page as a sub-page
   * [nav]:     targeted page
   * [popUtil]: direct to the next page and pop several page in the stack
   * [args]:    arguments pass to the next page
   */
  Future<dynamic> next(
    Nav nav, {
    String? tag,
    Nav? popUtil,
    Map<String, dynamic>? args,
    Object? itemId,
    bool newInstance = false,
  }) async {
    final widget = nav.getWidget(tag);

    if (widget is BaseBottomSheetView) {
      return _pushBottomSheet(
        nav: nav,
        heightFactor: widget.heightFactor,
        swipeToDismiss: widget.swipeToDismiss,
        dismissible: widget.dismissible,
        backgroundColor: widget.backgroundColor,
        tag: tag,
      );
    }

    final pageRoute = GetPageRoute(
      routeName: "/${tag ?? nav.screenName}",
      page: () => widget,
      binding: nav.getBindings(newInstance ? tag : null),
      settings: RouteSettings(name: tag ?? nav.screenName, arguments: null),
      customTransition: (GetPlatform.isMobile && Platform.isAndroid)
          ? CustomSlideTransition()
          : null,
      transitionDuration: const Duration(milliseconds: 400),
    );

    if (popUtil == null) {
      return Get.key.currentState?.push(pageRoute);
    } else if (popUtil == nav) {
      return Get.key.currentState?.pushReplacement(pageRoute);
    } else {
      return Get.offUntil(pageRoute, (route) {
        if (route is GetPageRoute) {
          return route.routeName == "/${popUtil.screenName}";
        } else {
          return false;
        }
      });
    }
  }

  /// Push a bottom sheet page almost cover the screen
  Future<void> _pushBottomSheet({
    required Nav nav,
    String? tag,
    double? heightFactor,
    bool? swipeToDismiss,
    bool? dismissible,
    Color? backgroundColor,
    Map<String, dynamic>? args,
    Object? itemId,
  }) async {
    return Get.bottomSheet(
      PopScope(
        canPop: dismissible == true,
        child: (heightFactor != null)
            ? SizedBox(
                height: Get.height * heightFactor,
                child: nav.getWidget(tag),
              )
            : Container(
                constraints: BoxConstraints(
                  maxWidth: Get.width,
                  maxHeight: Get.height * 0.90,
                  minHeight: 0,
                ),
                child: Wrap(children: [nav.getWidget(tag)]),
              ),
      ),
      persistent: false,
      elevation: 0,
      isScrollControlled: true,
      enableDrag: swipeToDismiss == true,
      isDismissible: dismissible == true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radiusExtraLarge),
          topRight: Radius.circular(AppDimens.radiusExtraLarge),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      settings: RouteSettings(name: nav.screenName, arguments: null),
    );
  }

  /// Push a bottom sheet page almost cover the screen
  void _pushDialog(Nav nav, {String? tag, Map<String, dynamic>? args}) {
    Get.dialog(
      nav.getWidget(tag),
      barrierDismissible: false,
      routeSettings: RouteSettings(name: "dialog", arguments: args),
    );
  }

  void unfocusAll() {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void toggleLoading(bool loading) {
    if (loading) {
      _showLoading();
    } else {
      _hideLoading();
    }
  }

  Future<void> _showLoading() async {
    if (Get.isDialogOpen == true) {
      return;
    }
    await Get.dialog(
      PopScope(
        canPop: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(),
            ).animate().scale(duration: 300.ms, curve: Curves.easeInOutCubic),
          ],
        ),
      ),
      barrierDismissible: false,
      transitionDuration: 500.ms,
    );
  }

  Future<void> _hideLoading() async {
    if (Get.isDialogOpen == true) {
      await back();
    }
  }

  @override
  void onResumed() {}

  @override
  void onPaused() {}

  @override
  void onInactive() {}

  @override
  void onDetached() {}

  @override
  void onHidden() {}
}

abstract class ViewState {
  RxBool loading = false.obs;
}

class CustomSlideTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final slideInTween = Tween(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutQuad));
    final slideInAnimation = animation.drive(slideInTween);

    final slideOutTween = Tween(
      begin: Offset.zero,
      end: const Offset(-0.4, 0.0),
    ).chain(CurveTween(curve: Curves.easeInQuad));
    final slideOutAnimation = secondaryAnimation.drive(slideOutTween);

    return SlideTransition(
      position: slideInAnimation,
      child: SlideTransition(
        position: slideOutAnimation,
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: AppColors.black.withAlpha(50), blurRadius: 100),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
