import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class AppThemeData {
  AppThemeData._();

  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );
    return _buildTheme(
      scheme,
      background: AppColors.lightBg,
      text: AppColors.lightText,
      textSecondary: AppColors.lightTextSecondary,
      fillColor: AppColors.white,
    );
  }

  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    );
    return _buildTheme(
      scheme,
      background: AppColors.darkBg,
      text: AppColors.darkText,
      textSecondary: AppColors.darkTextSecondary,
      fillColor: AppColors.darkBorder,
    );
  }
}

ThemeData _buildTheme(
  ColorScheme scheme, {
  required Color background,
  required Color text,
  required Color textSecondary,
  required Color fillColor,
}) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    appBarTheme: _buildAppBarTheme(scheme),
    elevatedButtonTheme: _buildElevatedButtonTheme(scheme),
    cardTheme: _buildCardTheme() != null 
        ? CardThemeData(elevation: _buildCardTheme()!.elevation)
        : null,
    inputDecorationTheme: _buildInputDecorationTheme(scheme, fillColor),
    textTheme: _buildTextTheme(text, textSecondary),
  );
}

AppBarTheme _buildAppBarTheme(ColorScheme scheme) {
  return AppBarTheme(
    backgroundColor: scheme.primary,
    foregroundColor: AppColors.white,
    elevation: 4,
    centerTitle: true,
    titleTextStyle: AppTextStyle.appBarTitle.copyWith(color: AppColors.white),
  );
}

ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme scheme) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: scheme.primary,
      foregroundColor: AppColors.white,
      elevation: 4,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyle.button,
    ),
  );
}

CardTheme? _buildCardTheme() {
  return CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

InputDecorationTheme _buildInputDecorationTheme(
  ColorScheme scheme,
  Color fillColor,
) {
  return InputDecorationTheme(
    filled: true,
    fillColor: fillColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.primary, width: 2),
    ),
  );
}

TextTheme _buildTextTheme(Color text, Color textSecondary) {
  return TextTheme(
    headlineMedium: AppTextStyle.headline.copyWith(color: text),
    bodyLarge: AppTextStyle.bodyLarge.copyWith(color: text),
    bodyMedium: AppTextStyle.body.copyWith(color: textSecondary),
  );
}

