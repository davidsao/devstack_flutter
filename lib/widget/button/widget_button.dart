import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppButton extends StatelessWidget {
  const AppButton(
    this.onTap, {
    required this.child,
    required this.style,
    super.key,
    this.loading = false,
    this.enabled = true,
    this.leading,
    this.trailing,
  });
  final Widget child;
  final bool loading;
  final bool enabled;
  final Widget? leading;
  final Widget? trailing;
  final ButtonStyle style;
  final Function() onTap;

  static double get minHeight =>
      AppDimens.paddingSmall * 2 +
      (Get.textTheme.labelLarge?.fontSize ?? 0) *
          (Get.textTheme.labelLarge?.height ?? 0);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (!loading && enabled) ? () => onTap.call() : null,
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) leading!,
          kGapText,
          child,
          kGapText,
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

enum AppButtonStyleSize { large, medium, small, shrink }

class AppButtonStyle {
  static ButtonStyle primary({
    AppButtonStyleSize size = AppButtonStyleSize.large,
    Color? backgroundColor,
    Color? textColor = AppColors.white,
    EdgeInsets? customPadding,
  }) {
    EdgeInsets padding;

    if (customPadding != null) {
      padding = customPadding;
    } else {
      switch (size) {
        case AppButtonStyleSize.large:
          padding = const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: AppDimens.paddingSmall,
          );
        case AppButtonStyleSize.medium:
          padding = const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: AppDimens.paddingSmall,
          );
        case AppButtonStyleSize.small:
          padding = const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: AppDimens.paddingSmall,
          );
        case AppButtonStyleSize.shrink:
          padding = const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: AppDimens.paddingExtraLarge,
          );
      }
    }
    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.disabled) ? AppColors.white : textColor,
      ),
      textStyle: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? AppTextStyles.cta.copyWith(color: AppColors.white)
            : AppTextStyles.cta.copyWith(color: textColor),
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? AppColors.buttonDisabled
            : backgroundColor ?? AppColors.primary,
      ),
      padding: WidgetStateProperty.all(padding),
      minimumSize: WidgetStateProperty.all(
        (size != AppButtonStyleSize.shrink)
            ? Size(
                0, // FIX: Changed from double.infinity to 0 so width wraps content
                padding.top +
                    padding.bottom +
                    (AppTextStyles.cta.fontSize ?? 0) *
                        (AppTextStyles.cta.height ?? 0) +
                    3,
              )
            : Size.zero,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLarger),
        ),
      ),
    );
  }

  static ButtonStyle outline(
      {TextStyle? textStyle,
      AppButtonStyleSize size = AppButtonStyleSize.large,
      Color borderColor = AppColors.primaryColor,
      Color backgroundColor = Colors.transparent,
      Color textColor = AppColors.primaryColor,
      EdgeInsets? customPadding,
      double borderRadius = AppDimens.radiusLarger}) {
    EdgeInsets padding;

    if (customPadding != null) {
      padding = customPadding;
    } else {
      switch (size) {
        case AppButtonStyleSize.large:
          padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 16);
        case AppButtonStyleSize.medium:
          padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16);
        case AppButtonStyleSize.small:
          padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16);
        case AppButtonStyleSize.shrink:
          padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 48);
      }
    }
    final TextStyle _textStyle = textStyle ?? AppTextStyles.cta;

    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? textColor.withAlpha(77)
            : textColor,
      ),
      textStyle: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? _textStyle.copyWith(color: textColor.withAlpha(77))
            : _textStyle.copyWith(color: textColor),
      ),
      backgroundColor: WidgetStateProperty.all(backgroundColor),
      padding: WidgetStateProperty.all(padding),
      minimumSize: WidgetStateProperty.all(
        (size != AppButtonStyleSize.shrink)
            ? Size(
                0, // FIX: Changed from double.infinity to 0 so width wraps content
                padding.top +
                    padding.bottom +
                    (AppTextStyles.cta.fontSize ?? 0) *
                        (AppTextStyles.cta.height ?? 0) +
                    3,
              )
            : Size.zero,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  static ButtonStyle text({
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.black,
    Color borderColor = Colors.transparent,
    TextStyle? textStyle,
  }) {
    return TextButton.styleFrom(
      foregroundColor: textColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      backgroundColor: Colors.transparent,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: textStyle ?? AppTextStyles.cta,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
    );
  }

  static ButtonStyle iconText(
      {Color backgroundColor = Colors.transparent,
      Color textColor = Colors.black,
      TextStyle? textStyle,
      EdgeInsets? customPadding}) {
    return TextButton.styleFrom(
      padding: customPadding ??
          const EdgeInsets.only(left: 12, right: 5, top: 5, bottom: 5),
      foregroundColor: textColor,
      backgroundColor: Colors.transparent,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: textStyle ?? AppTextStyles.cta,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: backgroundColor),
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
    );
  }

  static ButtonStyle icon(
      {Color backgroundColor = Colors.transparent,
      Color iconColor = Colors.black,
      double size = 24.0,
      EdgeInsets? customPadding}) {
    return TextButton.styleFrom(
      padding: customPadding ?? const EdgeInsets.all(8.0),
      foregroundColor: iconColor,
      backgroundColor: backgroundColor,
      minimumSize: Size(size, size),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
    );
  }
}
