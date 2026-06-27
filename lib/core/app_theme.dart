import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryDark,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.primaryMid,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.border,
        onSecondaryContainer: AppColors.primaryDark,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.errorDark,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.ibmPlexSansThai(
          fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.ibmPlexSansThai(
          fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.ibmPlexSansThai(
          fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.ibmPlexSansThai(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.ibmPlexSansThai(
          fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.ibmPlexSansThai(
          fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.ibmPlexSansThai(
          fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
        ),
        bodySmall: GoogleFonts.ibmPlexSansThai(
          fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted,
        ),
        labelLarge: GoogleFonts.ibmPlexSansThai(
          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryDark,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.ibmPlexSansThai(
          fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size.fromHeight(52),
          textStyle: GoogleFonts.ibmPlexSansThai(
            fontSize: 15, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
    );
  }
}
