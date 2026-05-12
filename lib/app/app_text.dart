import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const _sangBleuEmpire = "SangBleuEmpire";
  static const _optima = "Optima";
  static const _roboto = "Roboto";

  static TextStyle get display {
    return const TextStyle(
      height: 1.2,
      fontFamily: _sangBleuEmpire,
      fontWeight: FontWeight.w400,
      fontSize: 40,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get h1 {
    return const TextStyle(
      height: 1.28,
      fontFamily: _sangBleuEmpire,
      fontWeight: FontWeight.w400,
      fontSize: 32,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get h2 {
    return const TextStyle(
      height: 1.39,
      fontFamily: _sangBleuEmpire,
      fontWeight: FontWeight.w400,
      fontSize: 23,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get h3 {
    return const TextStyle(
      height: 1.3,
      fontFamily: _sangBleuEmpire,
      fontWeight: FontWeight.w400,
      fontSize: 24,
      color: AppColors.textSecondary,
    );
  }

  static TextStyle get h4 {
    return const TextStyle(
      height: 1.52,
      fontFamily: _sangBleuEmpire,
      fontWeight: FontWeight.w400,
      fontSize: 17,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get t1 {
    return const TextStyle(
      height: 1.5,
      fontFamily: _optima,
      fontWeight: FontWeight.w500,
      fontSize: 18,
      color: AppColors.secondaryColor,
    );
  }

  // Shrink app bar title
  static TextStyle get t2 {
    return const TextStyle(
      height: 1.5,
      fontFamily: _optima,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get t3 {
    return const TextStyle(
      height: 1.5,
      fontFamily: _optima,
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get cta {
    return const TextStyle(
      height: 1.2,
      fontFamily: _roboto,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get b1 {
    return const TextStyle(
      height: 1.5,
      fontFamily: _roboto,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: AppColors.textPrimary,
      letterSpacing: 0.2,
    );
  }

  static TextStyle get b2 {
    return const TextStyle(
      height: 1.4,
      fontFamily: _roboto,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: AppColors.textPrimary,
      letterSpacing: 0.2,
    );
  }

  static TextStyle get b3 {
    return const TextStyle(
      height: 1.3,
      fontFamily: _roboto,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: AppColors.textPrimary,
      letterSpacing: 0.2,
    );
  }
}

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w500);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  double get lineHeight {
    return (height ?? 0) * (fontSize ?? 0);
  }
}
