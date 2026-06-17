import 'package:flutter/material.dart';

enum DevicePlatform {
  none,
  android,
  ios,
  ipados,
  macos,
  windows,
  web,
}

extension DevicePlatformExtension on DevicePlatform {
  /// The additional top offset required for OS-specific floating window controls
  /// (e.g., the macOS red/yellow/green traffic lights when the native title bar is hidden).
  double get windowControlOffset {
    switch (this) {
      case DevicePlatform.macos:
        return 36.0;
      case DevicePlatform.windows:
      case DevicePlatform.android:
        return 8.0;
      default:
        return 0.0;
    }
  }

  /// Calculates the total safe top padding by combining the hardware notch/status bar
  /// with any required OS-specific window control offsets.
  double fullSafeTopPadding(BuildContext context) {
    if (this == DevicePlatform.web) return 12.0;
    return MediaQuery.paddingOf(context).top + windowControlOffset;
  }

  /// Calculates the extra left margin required for the top-left toggle button.
  /// iPadOS requires an offset in compact (mobile) mode to dodge the slide-over handle.
  double toggleButtonLeftOffset({required bool isMobile}) {
    if (this == DevicePlatform.ipados && isMobile) {
      return 64.0;
    }
    return 0.0;
  }
}
