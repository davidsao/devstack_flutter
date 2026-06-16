import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

class AlertInfoAnimated extends StatelessWidget {
  final AlertHelper alertHelper;
  final double finalWidth;
  final double finalHeight;
  final double textWidth;
  final double textHeight;
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<double> topPosition;
  final VoidCallback onDismissed;

  static const sequence1 = 30.0;
  static const sequence23 = 70.0;
  static const sequence2 = 65.0;
  static const sequence3 = 5.0;
  AlertInfoAnimated({
    super.key,
    required this.controller,
    required this.alertHelper,
    required this.finalWidth,
    required this.finalHeight,
    required this.textWidth,
    required this.textHeight,
    required this.onDismissed,
  })  : opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.200, curve: Curves.ease),
          ),
        ),
        topPosition = TweenSequence(<TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween(
              begin: alertHelper.isTop
                  ? -(finalHeight + 10)
                  : alertHelper.maxHeight + finalHeight,
              end: alertHelper.isTop
                  ? alertHelper.padding
                  : alertHelper.maxHeight - alertHelper.padding - finalHeight,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: sequence1,
          ),
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(
              alertHelper.isTop
                  ? alertHelper.padding
                  : alertHelper.maxHeight - alertHelper.padding - finalHeight,
            ),
            weight: sequence23,
          ),
        ]).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0),
          ),
        ),
        height = TweenSequence(<TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween(
              begin: 55.0,
              end: 45.0,
            ).chain(CurveTween(curve: Curves.linear)),
            weight: 20,
          ),
          TweenSequenceItem<double>(
            tween: Tween(
              begin: 45.0,
              end: finalHeight,
            ).chain(CurveTween(curve: Curves.linear)),
            weight: 10,
          ),
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(finalHeight),
            weight: 70,
          ),
          //
        ]).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0),
          ),
        ),
        width = TweenSequence(<TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(44.0),
            weight: sequence1,
          ),
          TweenSequenceItem<double>(
            tween: Tween(
              begin: 44.0,
              end: finalWidth - 40,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: sequence2 / 2,
          ),
          TweenSequenceItem<double>(
            tween: Tween(
              begin: finalWidth - 40,
              end: finalWidth,
            ).chain(CurveTween(curve: Curves.elasticOut)),
            weight: sequence2 / 2,
          ),
        ]).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Positioned(
          left: (alertHelper.maxWidth - width.value) / 2,
          top: topPosition.value,
          child: Material(
            color: Colors.transparent,
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                onDismissed.call();
              },
              child: Opacity(
                opacity: opacity.value,
                child: Container(
                  width: width.value,
                  height: height.value,
                  decoration: BoxDecoration(
                    color: alertHelper.backgroundColor,
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: [
                      BoxShadow(
                        color: alertHelper.backgroundColor.withValues(
                          alpha: 0.3,
                        ),
                        blurRadius: 20.0,
                        offset: alertHelper.isThemeDark
                            ? const Offset(0, 1)
                            : const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    // clipBehavior: Clip.antiAlias,
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Positioned(
                        left: 10,
                        child: Icon(
                          alertHelper.icon,
                          size: 25.0,
                          color: alertHelper.iconColor,
                        ),
                      ),
                      Positioned(
                        left: 45,
                        child: SizedBox(
                          width: textWidth,
                          height: textHeight,
                          child: Text(
                            alertHelper.text,
                            style: TextStyle(color: alertHelper.textColor),
                            maxLines: 10,
                          ),
                        ),
                      ),
                      if (alertHelper.action != null)
                        Positioned(
                          left: textWidth + 48,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 120,
                              maxHeight: 45,
                            ),
                            child: Theme(
                              data: ThemeData(
                                brightness: alertHelper.isThemeDark
                                    ? Brightness.light
                                    : Brightness.dark,
                                colorScheme: alertHelper.scheme,
                              ),
                              child: TextButton(
                                onPressed: () =>
                                    alertHelper.actionCallback != null
                                        ? alertHelper.actionCallback!()
                                        : null,
                                child: Text(
                                  alertHelper.action!,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
