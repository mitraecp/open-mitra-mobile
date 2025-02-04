// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';

enum AppThemeTextStyleType {
  //
  /// w400
  regular,
  //
  /// w500
  medium,
  //
  /// w600
  semibold,
  //
  /// w700
  bold,
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        indicatorColor: Colors.black,
        fontFamily: 'Inter',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: _textTheme(),
      );

  static ThemeData get darkTheme => ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        indicatorColor: Colors.white,
        fontFamily: 'Inter',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: _textTheme(),
      );

  static TextTheme _textTheme() {
    return const TextTheme(
      // Display XS
      displayLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.normal,
        color: GlobalColors.grey_900,
      ),
      displayMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: GlobalColors.grey_900,
      ),
      headlineMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        color: GlobalColors.grey_900,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: GlobalColors.grey_900,
      ),
      bodyLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: GlobalColors.grey_900,
      ),
      bodySmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: GlobalColors.grey_900,
      ),
    );
  }

  //
  /// font: 30
  /// Color: grey_900
  static TextStyle display_sm(AppThemeTextStyleType styleType) {
    switch (styleType) {
      case AppThemeTextStyleType.regular:
        return const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.medium:
        return const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w500,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.semibold:
        return const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w600,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.bold:
        return const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w700,
          color: GlobalColors.grey_900,
        );
      default:
        return const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
    }
  }

  //
  /// font: 24
  /// Color: grey_900
  static TextStyle display_xs(AppThemeTextStyleType styleType) {
    switch (styleType) {
      case AppThemeTextStyleType.regular:
        return const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.medium:
        return const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.semibold:
        return const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.bold:
        return const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          color: GlobalColors.grey_900,
        );
      default:
        return const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
    }
  }

  //
  /// font: 20
  /// Color: grey_900
  static TextStyle text_xl(AppThemeTextStyleType styleType) {
    switch (styleType) {
      case AppThemeTextStyleType.regular:
        return const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.medium:
        return const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.semibold:
        return const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.bold:
        return const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: GlobalColors.grey_900,
        );
      default:
        return const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
    }
  }

  //
  /// font: 18
  /// Color: grey_900
  static TextStyle text_lg(AppThemeTextStyleType styleType) {
    switch (styleType) {
      case AppThemeTextStyleType.regular:
        return const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.medium:
        return const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.semibold:
        return const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.bold:
        return const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: GlobalColors.grey_900,
        );
      default:
        return const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
    }
  }

  //
  /// font: 16
  /// Color: grey_900
  static TextStyle text_md(AppThemeTextStyleType styleType) {
    switch (styleType) {
      case AppThemeTextStyleType.regular:
        return const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.medium:
        return const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.semibold:
        return const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.bold:
        return const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          color: GlobalColors.grey_900,
        );
      default:
        return const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
    }
  }

  //
  /// font: 14
  /// Color: grey_900
  static TextStyle text_sm(AppThemeTextStyleType styleType) {
    switch (styleType) {
      case AppThemeTextStyleType.regular:
        return const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.medium:
        return const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.semibold:
        return const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.bold:
        return const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: GlobalColors.grey_900,
        );
      default:
        return const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
    }
  }

  //
  /// font: 12
  /// Color: grey_900
  static TextStyle text_xs(AppThemeTextStyleType styleType) {
    switch (styleType) {
      case AppThemeTextStyleType.regular:
        return const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.medium:
        return const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.semibold:
        return const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: GlobalColors.grey_900,
        );
      case AppThemeTextStyleType.bold:
        return const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w700,
          color: GlobalColors.grey_900,
        );
      default:
        return const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: GlobalColors.grey_900,
        );
    }
  }
}