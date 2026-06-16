import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

enum MessagePosition { top, bottom }

enum TypeInfo { warning, error, success, info }

OverlayEntry? _previousEntry;
OverlayState? overlayState;

class SlidingAlert {
  final BuildContext context;
  final String text;
  final MessagePosition position;
  final double padding;
  final int duration;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? actionColor;
  final String? action;
  final Function? actionCallback;
  final IconData? icon;
  final TypeInfo typeInfo;

  SlidingAlert.show({
    required this.context,
    required this.text,
    this.position = MessagePosition.top,
    this.padding = 30.0,
    this.duration = 3,
    this.typeInfo = TypeInfo.info,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.actionColor,
    this.action,
    this.actionCallback,
    this.icon,
  }) {
    _buildAlertInfo();
  }

  void _buildAlertInfo() {
    AlertHelper alertHelper = AlertHelper(
      context: context,
      text: text,
      position: position,
      padding: padding,
      duration: duration,
      action: action,
      actionCallback: actionCallback,
      backgroundColor: backgroundColor,
      textColor: textColor,
      iconColor: iconColor,
      actionColor: actionColor,
      typeInfo: typeInfo,
      icon: icon,
    );

    overlayState ??= Overlay.of(context);
    if (!overlayState!.mounted) {
      overlayState = Overlay.of(context);
    }
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return AlertInfoWidget(
          alertHelper: alertHelper,
          onDismissed: () {
            if (overlayEntry.mounted && _previousEntry == overlayEntry) {
              overlayEntry.remove();
              _previousEntry = null;
            }
          },
        );
      },
    );
    if (_previousEntry != null && _previousEntry!.mounted) {
      _previousEntry?.remove();
    }
    if (overlayState != null) {
      overlayState!.insert(overlayEntry);
      _previousEntry = overlayEntry;
    }
  }
}
