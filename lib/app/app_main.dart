import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:devtoys_flutter/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MainApp extends StatefulWidget {
  const MainApp(this.flavor, this.values, {super.key, this.home});
  final Flavor flavor;
  final FlavorValues values;

  final Widget? home;

  static bool get isTest => Platform.environment.containsKey('FLUTTER_TEST');

  static Flavor get env =>
      Get.context!.findAncestorStateOfType<_MainAppState>()!.flavor;

  static FlavorValues get config =>
      Get.context!.findAncestorStateOfType<_MainAppState>()!.values;

  @override
  State<StatefulWidget> createState() {
    return _MainAppState();
  }
}

class _MainAppState extends State<MainApp> {
  Flavor get flavor => widget.flavor;

  FlavorValues get values => widget.values;

  @override
  Widget build(BuildContext context) {
    final localize = context.localizationDelegates;

    final colors = ColorScheme(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.white,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: AppColors.black,
      onSurface: AppColors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    );
    if (math.min(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ) <
        AppDimens.responsiveSize) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return GetMaterialApp(
      home: widget.home ?? HomePage(),
      localizationsDelegates: [...localize],
      navigatorObservers: [routeObserver],
      routingCallback: (routing) {
        routing?.route?.settings.name?.replaceAll("/", "") ?? "";
      },
      supportedLocales: widget.values.supportLanguages.map((e) => e.locale),
      locale: context.locale,
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(colorScheme: colors, useMaterial3: true).copyWith(
        scaffoldBackgroundColor: AppColors.background,
        highlightColor: AppColors.black.shade100.withAlpha(50),
        splashColor: AppColors.black.shade100.withAlpha(50),
        brightness: MediaQuery.platformBrightnessOf(context),
        textTheme: TextTheme(
          headlineLarge: AppTextStyles.h1,
          headlineMedium: AppTextStyles.h2,
          headlineSmall: AppTextStyles.h3,
          titleLarge: AppTextStyles.t1,
          titleMedium: AppTextStyles.t2,
          titleSmall: AppTextStyles.t3,
          bodyLarge: AppTextStyles.b1,
          bodyMedium: AppTextStyles.b2,
          bodySmall: AppTextStyles.b3,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.black,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: AppTextStyles.b1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          modalBarrierColor: Colors.transparent,
          elevation: 0,
        ),
        dividerTheme: DividerTheme.of(
          context,
        ).copyWith(color: AppColors.black.shade200, thickness: 1, space: 0),
        checkboxTheme: CheckboxTheme.of(context).copyWith(
          side: BorderSide(color: AppColors.black.shade400, width: 1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          checkColor: WidgetStateProperty.resolveWith<Color>(
            (states) => Colors.white,
          ),
        ),
        radioTheme: RadioTheme.of(context).copyWith(
          fillColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? AppColors.secondary
                : AppColors.black.shade500;
          }),
        ),
        sliderTheme: SliderTheme.of(context).copyWith(
          activeTrackColor: AppColors.secondary,
          inactiveTrackColor: AppColors.black.shade200,
          thumbColor: AppColors.secondary,
          overlayColor: AppColors.secondary.withAlpha(50),
          trackHeight: 4,
          thumbShape: _RoundSliderThumbShape(
            AppColors.secondary,
            enabledThumbRadius: 6.0,
            strokeRadius: 8.0,
          ),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        ),
      ),
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        // final scale = mediaQueryData.textScaler.clamp(
        //   minScaleFactor: 1.0,
        //   maxScaleFactor: 1.0,
        // );
        return KeyboardDismissOnTap(
          child: MediaQuery(
            data: mediaQueryData.copyWith(textScaler: TextScaler.noScaling),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark.copyWith(
                systemNavigationBarColor: AppColors.black.withAlpha(1),
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
              child: child!,
            ),
          ),
        );
      },
    );
  }
}

class _RoundSliderThumbShape extends SliderComponentShape {
  const _RoundSliderThumbShape(
    this.thumbColor, {
    this.strokeRadius = 14.0,
    this.enabledThumbRadius = 6.0,
    this.disabledThumbRadius,
    this.elevation = 0.0,
    this.pressedElevation = 6.0,
  });
  final Color thumbColor;
  final double strokeRadius;
  final double enabledThumbRadius;
  final double? disabledThumbRadius;
  final double elevation;
  final double pressedElevation;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
      isEnabled ? enabledThumbRadius : _disabledThumbRadius,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required ui.TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: Colors.white,
    );
    final double radius = radiusTween.evaluate(enableAnimation);
    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final Paint strokePaint = Paint()
      ..color = thumbColor
      ..strokeWidth = strokeRadius
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, strokePaint);

    final Color color = colorTween.evaluate(enableAnimation)!;
    final double evaluatedElevation = elevationTween.evaluate(
      activationAnimation,
    );
    final Path shadowPath = Path()
      ..addArc(
        Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius),
        0,
        math.pi * 2,
      );
    canvas
      ..drawShadow(shadowPath, Colors.black, evaluatedElevation, true)
      ..drawCircle(center, radius, Paint()..color = color);
  }
}
