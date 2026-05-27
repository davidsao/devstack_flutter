import 'dart:ui';

import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final double opacity;
  final Widget? child;
  final double blur;
  final double shadowStrength;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final Color? color;
  final bool matchPrimaryColor;
  final BoxBorder? border;
  final BoxShape shape;

  const GlassContainer({
    super.key,
    this.opacity = 0.05,
    this.child,
    this.blur = 5,
    this.border,
    this.height,
    this.width,
    this.borderRadius,
    this.shadowStrength = 5,
    this.color,
    this.matchPrimaryColor = false,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius geometryRadius = borderRadius ?? BorderRadius.circular(24);
    bool enableBlur = blur > 0;

    BoxBorder activeBorder = border ??
        GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              AppColors.white.withAlpha(80),
              AppColors.black.shade800.withAlpha(20),
              AppColors.white.withAlpha(80),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          width: 2.0,
        );

    final int safeAlpha = (opacity * 255).clamp(0, 255).toInt();

    Widget containerChild = DecoratedBox(
      decoration: BoxDecoration(
        shape: shape,
        color: color ?? Colors.grey.shade100.withAlpha(safeAlpha),
        borderRadius: shape == BoxShape.circle ? null : geometryRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color?.withAlpha(200) ?? AppColors.primary.withAlpha(200),
            color ?? AppColors.primary,
          ],
        ),
      ),
      child: child,
    );

    if (enableBlur) {
      containerChild = ClipRRect(
        borderRadius: geometryRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: containerChild,
        ),
      );
    }

    return CustomPaint(
      painter: HollowShadowPainter(
        shape: shape,
        shadowStrength: shadowStrength,
        shadowColor: Colors.transparent,
        borderRadius: geometryRadius,
      ),
      child: Container(
        width: width,
        height: height,
        foregroundDecoration: BoxDecoration(
          borderRadius: geometryRadius,
          border: activeBorder,
        ),
        child: containerChild,
      ),
    );
  }
}
