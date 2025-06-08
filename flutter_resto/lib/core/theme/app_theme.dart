import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define your custom primary, secondary, and error colors
  // These are example colors, replace them with your desired palette
  static const Color _lightPrimaryColor = Color(0xFFFFA000); // Example: Amber
  static const Color _lightSecondaryColor = Color(
    0xFFFFC107,
  ); // Example: Light Amber
  static const Color _lightBackgroundColor = Color(
    0xFFFFF8E1,
  ); // Example: Light Cream
  static const Color _lightSurfaceColor = Colors.white;
  static const Color _lightErrorColor = Color(0xFFD32F2F); // Example: Red

  static const Color _darkPrimaryColor = Color(0xFF7B1FA2); // Example: Purple
  static const Color _darkSecondaryColor = Color(
    0xFF9C27B0,
  ); // Example: Light Purple
  static const Color _darkBackgroundColor = Color(0xFF121212);
  static const Color _darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color _darkErrorColor = Color(0xFFEF9A9A); // Example: Light Red

  static final String? _poppinsFontFamily = GoogleFonts.poppins().fontFamily;

  static final CardThemeData _commonCardTheme = CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  );

  static final ElevatedButtonThemeData _commonElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      );

  static ThemeData get lightTheme {
    final baseLightTextTheme = ThemeData.light().textTheme;
    final textTheme = GoogleFonts.poppinsTextTheme(baseLightTextTheme).copyWith(
      displayLarge: GoogleFonts.poppins(
        textStyle: baseLightTextTheme.displayLarge,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        textStyle: baseLightTextTheme.displayMedium,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.poppins(
        textStyle: baseLightTextTheme.displaySmall,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.poppins(
        textStyle: baseLightTextTheme.headlineLarge,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.poppins(
        textStyle: baseLightTextTheme.headlineMedium,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.poppins(
        textStyle: baseLightTextTheme.headlineSmall,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.poppins(
        textStyle: baseLightTextTheme.titleLarge,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.poppins(
        textStyle: baseLightTextTheme.titleMedium,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.poppins(
        textStyle: baseLightTextTheme.titleSmall,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.poppins(textStyle: baseLightTextTheme.bodyLarge),
      bodyMedium: GoogleFonts.poppins(textStyle: baseLightTextTheme.bodyMedium),
      bodySmall: GoogleFonts.poppins(textStyle: baseLightTextTheme.bodySmall),
      labelLarge: GoogleFonts.poppins(
        textStyle: baseLightTextTheme.labelLarge,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.poppins(
        textStyle: baseLightTextTheme.labelMedium,
      ),
      labelSmall: GoogleFonts.poppins(textStyle: baseLightTextTheme.labelSmall),
    );

    final colorScheme = const ColorScheme.light().copyWith(
      primary: _lightPrimaryColor,
      secondary: _lightSecondaryColor,
      background: _lightBackgroundColor,
      surface: _lightSurfaceColor,
      error: _lightErrorColor,
      onPrimary: Colors.white, // Text on primary color
      onSecondary: Colors.black, // Text on secondary color
      onBackground: Colors.black87, // Text on background
      onSurface: Colors.black87, // Text on surface
      onError: Colors.white, // Text on error color
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: _lightBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightSurfaceColor,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle:
            textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ) ??
            TextStyle(
              fontFamily: _poppinsFontFamily,
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
      ),
      cardTheme: _commonCardTheme.copyWith(
        color: _lightSurfaceColor,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimaryColor,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _lightSurfaceColor,
        selectedItemColor: _lightPrimaryColor,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: _lightSurfaceColor,
        selectedIconTheme: const IconThemeData(color: _lightPrimaryColor),
        unselectedIconTheme: IconThemeData(color: Colors.grey[600]!),
        selectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          color: _lightPrimaryColor,
        ),
        unselectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          color: Colors.grey[600],
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _lightPrimaryColor, width: 2),
        ),
        labelStyle: textTheme.bodyMedium,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _lightPrimaryColor.withOpacity(0.1),
        labelStyle: textTheme.bodySmall?.copyWith(color: _lightPrimaryColor),
        selectedColor: _lightPrimaryColor,
        checkmarkColor: colorScheme.onPrimary,
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseDarkTextTheme = ThemeData.dark().textTheme;
    final textTheme = GoogleFonts.poppinsTextTheme(baseDarkTextTheme).copyWith(
      displayLarge: GoogleFonts.poppins(
        textStyle: baseDarkTextTheme.displayLarge,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        textStyle: baseDarkTextTheme.displayMedium,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.poppins(
        textStyle: baseDarkTextTheme.displaySmall,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.poppins(
        textStyle: baseDarkTextTheme.headlineLarge,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.poppins(
        textStyle: baseDarkTextTheme.headlineMedium,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.poppins(
        textStyle: baseDarkTextTheme.headlineSmall,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.poppins(
        textStyle: baseDarkTextTheme.titleLarge,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.poppins(
        textStyle: baseDarkTextTheme.titleMedium,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.poppins(
        textStyle: baseDarkTextTheme.titleSmall,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.poppins(textStyle: baseDarkTextTheme.bodyLarge),
      bodyMedium: GoogleFonts.poppins(textStyle: baseDarkTextTheme.bodyMedium),
      bodySmall: GoogleFonts.poppins(textStyle: baseDarkTextTheme.bodySmall),
      labelLarge: GoogleFonts.poppins(
        textStyle: baseDarkTextTheme.labelLarge,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.poppins(
        textStyle: baseDarkTextTheme.labelMedium,
      ),
      labelSmall: GoogleFonts.poppins(textStyle: baseDarkTextTheme.labelSmall),
    );

    final colorScheme = const ColorScheme.dark().copyWith(
      primary: _darkPrimaryColor,
      secondary: _darkSecondaryColor,
      background: _darkBackgroundColor,
      surface: _darkSurfaceColor,
      error: _darkErrorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white70,
      onSurface: Colors.white70,
      onError: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: _darkBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurfaceColor,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle:
            textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ) ??
            TextStyle(
              fontFamily: _poppinsFontFamily,
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
      ),
      cardTheme: _commonCardTheme.copyWith(
        color: _darkSurfaceColor,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _commonElevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStateProperty.all(_darkPrimaryColor),
          foregroundColor: MaterialStateProperty.all(colorScheme.onPrimary),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkSurfaceColor,
        selectedItemColor: _darkPrimaryColor,
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: _darkSurfaceColor,
        selectedIconTheme: const IconThemeData(color: _darkPrimaryColor),
        unselectedIconTheme: IconThemeData(color: Colors.grey[400]!),
        selectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          color: _darkPrimaryColor,
        ),
        unselectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          color: Colors.grey[400],
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _darkPrimaryColor, width: 2),
        ),
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _darkPrimaryColor.withOpacity(0.2),
        labelStyle: textTheme.bodySmall?.copyWith(color: _darkPrimaryColor),
        selectedColor: _darkPrimaryColor,
        checkmarkColor: colorScheme.onPrimary,
      ),
    );
  }
}
