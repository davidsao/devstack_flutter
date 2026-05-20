import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Colors.white;

  static const Color _black50 = Color(0xfffafafa);
  static const Color _black100 = Color(0xfff8f8f8);
  static const Color _black200 = Color(0xfff3f3f3);
  static const Color _black300 = Color(0xffeeeeee);
  static const Color _black400 = Color(0xffcdcdcd);
  static const Color _black500 = Color(0xffafafaf);
  static const Color _black600 = Color(0xff858585);
  static const Color _black700 = Color(0xff707070);
  static const Color _black800 = Color(0xff505050);
  static const Color _black900 = Color(0xff2e2e2e);
  static const Color _black = Color(0xff000000);
  static MaterialColor black = MaterialColor(_black.toInt32, const <int, Color>{
    50: _black50,
    100: _black100,
    200: _black200,
    300: _black300,
    400: _black400,
    500: _black500,
    600: _black600,
    700: _black700,
    800: _black800,
    900: _black900,
  });

  static const Color _grey200 = Color(0xffEFEFEF);
  static const Color _grey300 = Color(0xffD3D3D3);
  static const Color _grey400 = Color(0xffAFAFAD);
  static const Color _grey500 = Color(0xff8F8F8F);
  static const Color _grey700 = Color(0xff545454);
  static const Color _grey900 = Color(0xff262626);
  static MaterialColor grey =
      MaterialColor(_grey500.toInt32, const <int, Color>{
    50: Color(0xffF5F5F5),
    100: Color(0xffE8E8E8),
    200: _grey200,
    300: _grey300,
    400: _grey400,
    500: _grey500,
    600: Color(0xff7C7C7C),
    700: _grey700,
    800: Color(0xff505050),
    900: _grey900,
  });

  static const Color _primary100 = Color(0xffd1c4e9);
  static const Color _primary200 = Color(0xffb39ddb);
  static const Color _primary300 = Color(0xff9575cd);
  static const Color _primary400 = Color(0xff7e57c2);
  static const Color _primary500 = Color(0xFF673ab7);
  static const Color _primary600 = Color(0xff5e35b1);
  static const Color _primary700 = Color(0xff512da8);
  static const Color _primary800 = Color(0xff4527a0);
  static const Color _primary900 = Color(0xff311b92);
  static MaterialColor primary =
      MaterialColor(_primary500.toInt32, const <int, Color>{
    100: _primary100,
    200: _primary200,
    300: _primary300,
    400: _primary400,
    500: _primary500,
    600: _primary600,
    700: _primary700,
    800: _primary800,
    900: _primary900,
  });

  // NEW: Secondary Teal/Mint color palette to beautifully complement the deep purple
  static const Color _secondary100 = Color(0xffe0f7fa);
  static const Color _secondary200 = Color(0xffb2ebf2);
  static const Color _secondary300 = Color(0xff80deea);
  static const Color _secondary400 = Color(0xff4dd0e1);
  static const Color _secondary500 = Color(0xff26c6da);
  static const Color _secondary600 = Color(0xff00bcd4);
  static const Color _secondary700 = Color(0xff00acc1);
  static const Color _secondary800 = Color(0xff0097a7);
  static const Color _secondary900 = Color(0xff006064);
  static MaterialColor secondary =
      MaterialColor(_secondary600.toInt32, const <int, Color>{
    100: _secondary100,
    200: _secondary200,
    300: _secondary300,
    400: _secondary400,
    500: _secondary500,
    600: _secondary600,
    700: _secondary700,
    800: _secondary800,
    900: _secondary900,
  });

  static const Color primaryColor = Color(0xFF673ab7);
  static const Color secondaryColor =
      Color(0xff00bcd4); // Updated to vibrant Teal
  static const Color background = Color(0xFFF8F8FA);
  static const Color buttonDisabled = Color(
      0xFFE0E0E0); // Updated from peach to a neutral grey to fit the new theme
  static const Color textPrimary = Color(0xFF3C3C3C);
  static const Color textSecondary = Color(0xFF8E8E8F);
  static const Color error = Color(0xFFD75932);
  static const Color errorMask = Color(0x20D75932);
  static const Color divider = Color(0xFFDCDCDC);
  static const Color disable = Color(0xFFB3B3B4);
  static const Color success = Color(
      0xFF2E7D32); // Updated from the old forest green to standard success green
  static const Color hover = Color(0xffe0f7fa); // Updated to match teal palette
  static const Color chatbotBackground = Color(0xFFF0EBE1);
  static const Color shimmerBaseColor = Color(0xFFDCDCDC);
  static const Color shimmerHighlightColor = Color(0xFFEBEBEB);
  static const Color primaryGold = Color(0xFFDCC39B);
  static const Color sponsoredBackground = Color(0xFFE1D8D2);

  static List<BoxShadow> cardShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shadowColor =
        isDark ? Colors.black.withAlpha(48) : const Color(0x10000000);

    return [
      BoxShadow(color: shadowColor, blurRadius: 8, offset: const Offset(0, 4)),
      BoxShadow(color: shadowColor, blurRadius: 24, offset: const Offset(0, 8)),
    ];
  }

  static List<BoxShadow> toolbarShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shadowColor =
        isDark ? Colors.black.withAlpha(40) : const Color(0x10000000);

    return [
      BoxShadow(color: shadowColor, blurRadius: 2, offset: const Offset(0, 1)),
      BoxShadow(color: shadowColor, blurRadius: 4, offset: const Offset(0, 2)),
    ];
  }

  static List<BoxShadow> textfieldShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Stronger base shadow for dark mode
    final shadowColor =
        isDark ? Colors.black.withAlpha(72) : const Color(0x10000000);

    return [
      BoxShadow(
        color: shadowColor,
      ),
      BoxShadow(
        // By passing context, this surface color will dynamically update!
        color: Theme.of(context).colorScheme.surface,
        blurRadius: 3,
        spreadRadius: -3,
      ),
    ];
  }
}
