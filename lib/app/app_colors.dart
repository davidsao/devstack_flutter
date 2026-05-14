import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  static const Color _primary100 = Color(0xfff7ded6);
  static const Color _primary200 = Color(0xffefbdad);
  static const Color _primary300 = Color(0xffe79b84);
  static const Color _primary400 = Color(0xffdf7a5b);
  static const Color _primary500 = Color(0xFFD75932);
  static const Color _primary600 = Color(0xffac4728);
  static const Color _primary700 = Color(0xff81351e);
  static const Color _primary800 = Color(0xff562414);
  static const Color _primary900 = Color(0xff2b120a);
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

  static const Color _secondary100 = Color(0xffa1b1a5);
  static const Color _secondary200 = Color(0xff8a9e8f);
  static const Color _secondary300 = Color(0xff728a78);
  static const Color _secondary400 = Color(0xff5b7762);
  static const Color _secondary500 = Color(0xff43634b);
  static const Color _secondary600 = Color(0xff2c5035);
  static const Color _secondary700 = Color(0xff143C1E);
  static const Color _secondary800 = Color(0xff0F2B14);
  static const Color _secondary900 = Color(0xff0A1A0B);
  static MaterialColor secondary =
      MaterialColor(_secondary700.toInt32, const <int, Color>{
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

  static const Color primaryColor = Color(0xFFD75932);
  static const Color secondaryColor = Color(0xFF143C1E);
  static const Color background = Color(0xFFF8F8FA);
  static const Color buttonDisabled = Color(0xFFF0D7CE);
  static const Color textPrimary = Color(0xFF3C3C3C);
  static const Color textSecondary = Color(0xFF8E8E8F);
  static const Color error = Color(0xFFD75932);
  static const Color errorMask = Color(0x20D75932);
  static const Color divider = Color(0xFFDCDCDC);
  static const Color disable = Color(0xFFB3B3B4);
  static const Color success = Color(0xFF143C1E);
  static const Color hover = Color(0xFFDCE5D8);
  static const Color chatbotBackground = Color(0xFFF0EBE1);
  static const Color shimmerBaseColor = Color(0xFFDCDCDC);
  static const Color shimmerHighlightColor = Color(0xFFEBEBEB);
  static const Color primaryGold = Color(0xFFDCC39B);
  static const Color sponsoredBackground = Color(0xFFE1D8D2);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x10000000), blurRadius: 8, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x10000000), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> toolbarShadow = [
    BoxShadow(color: Color(0x10000000), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x10000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static final List<BoxShadow> textfieldShadow = [
    const BoxShadow(
      color: Color(0x10000000),
    ),
    BoxShadow(
      color: Theme.of(Get.context!).colorScheme.surface,
      blurRadius: 3,
      spreadRadius: -3,
    ),
  ];
}
