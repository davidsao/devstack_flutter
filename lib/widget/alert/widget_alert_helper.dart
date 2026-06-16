import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

class AlertHelper {
  final String text;
  final MessagePosition position;
  final double padding;
  final int duration;
  final String? action;
  final Function? actionCallback;
  final TypeInfo typeInfo;
  late IconData icon;
  late ColorScheme scheme;

  late Color _backgroundColor;
  late Color _textColor;
  late Color _iconColor;
  late Color _actionColor;
  late double maxWidth;
  late bool isThemeDark;
  late double maxHeight;

  AlertHelper({
    required BuildContext context,
    required this.text,
    required this.position,
    required this.padding,
    required this.duration,
    required this.action,
    required this.actionCallback,
    required this.typeInfo,
    IconData? icon,
    required Color? backgroundColor,
    required Color? textColor,
    required Color? iconColor,
    required Color? actionColor,
  }) {
    final size = MediaQuery.of(context).size;
    maxWidth = size.width;
    maxHeight = size.height;
    final ThemeData theme = Theme.of(context);
    isThemeDark = theme.brightness == Brightness.dark;
    scheme = ColorScheme.fromSeed(
      seedColor: theme.colorScheme.primary,
      brightness: isThemeDark ? Brightness.light : Brightness.dark,
    );
    _backgroundColor = backgroundColor ?? scheme.surface;
    _textColor = textColor ?? scheme.onSurface;
    _iconColor = iconColor ?? _getIconColor();
    _actionColor = actionColor ?? scheme.primaryFixed;
    this.icon = icon ?? _getIcon();
  }

  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;
  Color get iconColor => _iconColor;
  Color get actionColor => _actionColor;

  IconData _getIcon() {
    switch (typeInfo) {
      case TypeInfo.info:
        return Icons.error_outline;
      case TypeInfo.warning:
        return Icons.warning_amber_rounded;
      case TypeInfo.success:
        return Icons.check_circle_outline;
      case TypeInfo.error:
        return Icons.help_outline;
    }
  }

  Color _getIconColor() {
    switch (typeInfo) {
      case TypeInfo.info:
        return (isThemeDark ? Colors.green : Colors.greenAccent);
      case TypeInfo.warning:
        return (isThemeDark ? Colors.orange : Colors.orangeAccent);
      case TypeInfo.success:
        return (isThemeDark ? Colors.green : Colors.greenAccent);
      case TypeInfo.error:
        return (isThemeDark ? Colors.red : Colors.redAccent);
    }
  }

  bool get isTop => position == MessagePosition.top;
}
