import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static bool _isDark = true;
  static bool get isDark => _isDark;
  static void setDark(bool value) => _isDark = value;

  static const Color primary = Color(0xFF0F172A);
  static const Color accent = Color(0xFF10B981);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const double radiusSmall = 8.0;
  static const double radiusMain = 12.0;

  static const double spaceXS = 8.0;
  static const double spaceS = 12.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;

  static Color get bgDark =>
      _isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC);
  static Color get bgSidebar =>
      _isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
  static Color get bgCard =>
      _isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
  static Color get bgSurface =>
      _isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
  static Color get bgHover =>
      _isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
  static Color get bgSelected =>
      _isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

  static Color get textPrimary =>
      _isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  static Color get textSecondary =>
      _isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
  static Color get textMuted =>
      _isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

  static Color get borderColor =>
      _isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

  static TextStyle get pageTitle => GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );
  static TextStyle get sectionTitle => GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  static TextStyle get cardTitle => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  static TextStyle get bodyText => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );
  static TextStyle get smallText => GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: Colors.white,
        error: error,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMain),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMain),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: TextStyle(color: const Color(0xFF94A3B8), fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceL,
            vertical: spaceS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFF020617),
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: accent,
        surface: Color(0xFF0F172A),
        error: error,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
      cardTheme: CardThemeData(
        color: const Color(0xFF0F172A),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMain),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMain),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: Color(0xFF1E293B)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: Color(0xFF1E293B)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        hintStyle: TextStyle(color: const Color(0xFF64748B), fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0F172A),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceL,
            vertical: spaceS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
