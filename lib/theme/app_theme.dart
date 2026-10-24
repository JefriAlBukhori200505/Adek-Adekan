
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Global colors
  static const Color backgroundColor = Color(0xFF0B0F0D);
  static const Color surfaceColor = Color(0xFF151C18);
  static const Color primaryColor = Color(0xFF16804A);
  static const Color primaryLightColor = Color(0xFF35A66A);

  static const Color textColor = Color(0xFFF3F5F3);
  static const Color secondaryTextColor = Color(0xFF8B9690);
  static const Color borderColor = Color(0xFF303832);
  static const Color errorColor = Color(0xFFE45D5D);
  static const Color warningColor = Color(0xFFFFC857);

  /// Latar hijau gelap untuk ikon, banner, dan chip.
  static const Color tintColor = Color(0xFF244A35);
  static const Color tintSurfaceColor = Color(0xFF14291D);

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: primaryColor,
      onPrimary: textColor,
      secondary: primaryLightColor,
      onSecondary: backgroundColor,
      surface: surfaceColor,
      onSurface: textColor,
      error: errorColor,
      onError: backgroundColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      canvasColor: backgroundColor,
      dividerColor: borderColor,

      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borderColor),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        hintStyle: const TextStyle(
          color: secondaryTextColor,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(color: secondaryTextColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: primaryLightColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
          disabledBackgroundColor: borderColor,
          disabledForegroundColor: secondaryTextColor,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLightColor,
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: surfaceColor,
        indicatorColor: Color(0xFF244A35),
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceColor,
        contentTextStyle: const TextStyle(color: textColor),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      iconTheme: const IconThemeData(color: textColor),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryLightColor,
      ),
    );
  }
}
