import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class ToolTipIconButton extends StatelessWidget {
  const ToolTipIconButton(
      {required this.icon,
      required this.onTap,
      required this.tooltip,
      super.key});

  final String tooltip;
  final String icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: AppImage(
          icon,
          size: AppDimens.iconSmaller,
        ).marginAll(AppDimens.marginTiny),
      ),
    );
  }
}
