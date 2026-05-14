import 'package:flutter/material.dart';

class AppTheme {
  // Common Colors
  static const Color primaryLight = Color.fromRGBO(24, 24, 27, 1); // Zinc 900
  static const Color primaryDark = Color(
    0xFF000000,
  ); // Or #111827 depending on screen
  static const Color accentBlueLight = Color.fromARGB(255, 45, 77, 138);
  static const Color accentBlueDark = Color.fromARGB(255, 86, 140, 241);

  // Backgrounds
  static const Color bgLight = Color.fromARGB(
    255,
    239,
    241,
    238,
  ); // iOS system gray light or F2F2F4
  static const Color bgDark = Color.fromARGB(255, 0, 0, 0); // Pitch black

  // Cards
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1C1C1E);

  // Text
  static const Color textMainLight = Color(0xFF111827);
  static const Color textMainDark = Color(0xFFF9FAFB);
  static const Color textSubLight = Color(0xFF6B7280);
  static const Color textSubDark = Color(0xFF9CA3AF);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: bgLight,
      colorScheme: ColorScheme.light(
        primary: primaryLight,
        secondary: accentBlueLight,
        tertiary: Colors.black,
        surface: cardLight,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'DMSans',
          color: textMainLight,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: 'DMSans',
          color: textMainLight,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: 'DMSans',
          color: textMainLight,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'DMSans',
          color: textMainLight,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'DMSans',
          color: textMainLight,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'DMSans',
          color: textMainLight,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontFamily: 'DMSans',
          color: textMainLight,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontFamily: 'DMSans',
          color: textMainLight,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          fontFamily: 'DMSans',
          color: textMainLight,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(fontFamily: 'GSansFlex', color: textMainLight),
        bodyMedium: TextStyle(fontFamily: 'GSansFlex', color: textMainLight),
        bodySmall: TextStyle(fontFamily: 'GSansFlex', color: textSubLight),
        labelLarge: TextStyle(
          fontFamily: 'GSansFlex',
          color: textMainLight,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          fontFamily: 'GSansFlex',
          color: textMainLight,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          fontFamily: 'GSansFlex',
          color: textSubLight,
          fontWeight: FontWeight.w500,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: bgDark,
        selectionColor: bgDark.withValues(alpha: 0.3),
        selectionHandleColor: bgDark,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryDark,
      scaffoldBackgroundColor: bgDark,
      colorScheme: ColorScheme.dark(
        primary: primaryDark,
        secondary: accentBlueDark,
        tertiary: Colors.white,
        surface: cardDark,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'DMSans',
          color: textMainDark,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: 'DMSans',
          color: textMainDark,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: 'DMSans',
          color: textMainDark,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'DMSans',
          color: textMainDark,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'DMSans',
          color: textMainDark,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'DMSans',
          color: textMainDark,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontFamily: 'DMSans',
          color: textMainDark,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontFamily: 'DMSans',
          color: textMainDark,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          fontFamily: 'DMSans',
          color: textMainDark,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(fontFamily: 'GSansFlex', color: textMainDark),
        bodyMedium: TextStyle(fontFamily: 'GSansFlex', color: textMainDark),
        bodySmall: TextStyle(fontFamily: 'GSansFlex', color: textSubDark),
        labelLarge: TextStyle(
          fontFamily: 'GSansFlex',
          color: textMainDark,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          fontFamily: 'GSansFlex',
          color: textMainDark,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          fontFamily: 'GSansFlex',
          color: textSubDark,
          fontWeight: FontWeight.w500,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: bgLight,
        selectionColor: bgLight.withValues(alpha: 0.3),
        selectionHandleColor: bgLight,
      ),
      useMaterial3: true,
    );
  }

  static const Map<String, Color> formatColors = {
    'URL': Colors.pink,
    'Wi-Fi': Colors.deepPurple,
    'Text': Colors.deepOrange,
    'vCard': Colors.red,
    'UPI': Colors.purple,
  };
}
