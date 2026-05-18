import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Use Inter for standard UI elements
  static TextStyle _baseStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.figtree(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Use JetBrains Mono for code/editors
  static TextStyle monoStyle({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle get display => _baseStyle(
        height: 1.2,
        fontWeight: FontWeight.w800,
        fontSize: 40,
        color: AppColors.textPrimary,
      );

  static TextStyle get h1 => _baseStyle(
        height: 1.28,
        fontWeight: FontWeight.w800,
        fontSize: 32,
        color: AppColors.textPrimary,
      );

  static TextStyle get h2 => _baseStyle(
        height: 1.39,
        fontWeight: FontWeight.w800,
        fontSize: 23,
        color: AppColors.textPrimary,
      );

  static TextStyle get h3 => _baseStyle(
        height: 1.3,
        fontWeight: FontWeight.w800,
        fontSize: 24,
        color: AppColors.textSecondary,
      );

  static TextStyle get h4 => _baseStyle(
        height: 1.52,
        fontWeight: FontWeight.w700,
        fontSize: 17,
        color: AppColors.textPrimary,
      );

  static TextStyle get t1 => _baseStyle(
        height: 1.5,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: AppColors.secondaryColor,
      );

  static TextStyle get t2 => _baseStyle(
        height: 1.5,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColors.textPrimary,
      );

  static TextStyle get t3 => _baseStyle(
        height: 1.5,
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: AppColors.textPrimary,
      );

  static TextStyle get cta => _baseStyle(
        height: 1.2,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColors.textPrimary,
      );

  static TextStyle get b1 => _baseStyle(
        height: 1.5,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      );

  static TextStyle get b2 => _baseStyle(
        height: 1.4,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      );

  static TextStyle get b3 => _baseStyle(
        height: 1.3,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      );
}

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.w800);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w500);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  double get lineHeight {
    return (height ?? 0) * (fontSize ?? 0);
  }
}
