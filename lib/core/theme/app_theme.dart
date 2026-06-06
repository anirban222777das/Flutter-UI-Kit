import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uikit/core/theme/app_colors.dart';
import 'package:uikit/core/theme/app_typography.dart';

/// Application theme configuration.
///
/// Provides fully configured [ThemeData] for light and dark modes
/// with Material 3 design tokens derived from the UIKit color system.
abstract final class AppTheme {
  // ──────────────────────────────────────────────
  // Light Theme
  // ──────────────────────────────────────────────

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primarySubtle,
          onPrimaryContainer: AppColors.primaryDark,
          secondary: AppColors.lightOnSurfaceVariant,
          onSecondary: Colors.white,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightOnSurface,
          onSurfaceVariant: AppColors.lightOnSurfaceVariant,
          outline: AppColors.lightBorder,
          outlineVariant: AppColors.lightBorderSubtle,
          error: AppColors.error,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        cardColor: AppColors.lightSurface,
        dividerColor: AppColors.lightBorder,
        splashFactory: InkSparkle.splashFactory,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0.5,
          backgroundColor: AppColors.lightBackground,
          foregroundColor: AppColors.lightOnBackground,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.lightOnBackground,
            letterSpacing: -0.2,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.lightBorder, width: 0.5),
          ),
        ),
        textTheme: _buildTextTheme(Brightness.light),
        iconTheme: const IconThemeData(
          color: AppColors.lightOnSurfaceVariant,
          size: 22,
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.lightOnBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTypography.labelSm.copyWith(color: Colors.white),
        ),
      );

  // ──────────────────────────────────────────────
  // Dark Theme
  // ──────────────────────────────────────────────

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryLight,
          onPrimary: Colors.black,
          primaryContainer: AppColors.primarySubtleDark,
          onPrimaryContainer: AppColors.primaryLight,
          secondary: AppColors.darkOnSurfaceVariant,
          onSecondary: Colors.black,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkOnSurface,
          onSurfaceVariant: AppColors.darkOnSurfaceVariant,
          outline: AppColors.darkBorder,
          outlineVariant: AppColors.darkBorderSubtle,
          error: AppColors.error,
          onError: Colors.black,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.darkSurface,
        dividerColor: AppColors.darkBorder,
        splashFactory: InkSparkle.splashFactory,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0.5,
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.darkOnBackground,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.darkOnBackground,
            letterSpacing: -0.2,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.darkBorder, width: 0.5),
          ),
        ),
        textTheme: _buildTextTheme(Brightness.dark),
        iconTheme: const IconThemeData(
          color: AppColors.darkOnSurfaceVariant,
          size: 22,
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.darkOnBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTypography.labelSm.copyWith(color: Colors.black),
        ),
      );

  // ──────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────

  static TextTheme _buildTextTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final onSurface =
        isLight ? AppColors.lightOnSurface : AppColors.darkOnSurface;
    final onSurfaceVariant = isLight
        ? AppColors.lightOnSurfaceVariant
        : AppColors.darkOnSurfaceVariant;

    return TextTheme(
      displayLarge: AppTypography.displayLg.copyWith(color: onSurface),
      displayMedium: AppTypography.displayMd.copyWith(color: onSurface),
      displaySmall: AppTypography.displaySm.copyWith(color: onSurface),
      headlineLarge: AppTypography.headlineLg.copyWith(color: onSurface),
      headlineMedium: AppTypography.headlineMd.copyWith(color: onSurface),
      headlineSmall: AppTypography.headlineSm.copyWith(color: onSurface),
      titleLarge: AppTypography.titleLg.copyWith(color: onSurface),
      titleMedium: AppTypography.titleMd.copyWith(color: onSurface),
      titleSmall: AppTypography.titleSm.copyWith(color: onSurfaceVariant),
      bodyLarge: AppTypography.bodyLg.copyWith(color: onSurface),
      bodyMedium: AppTypography.bodyMd.copyWith(color: onSurface),
      bodySmall: AppTypography.bodySm.copyWith(color: onSurfaceVariant),
      labelLarge: AppTypography.labelLg.copyWith(color: onSurface),
      labelMedium: AppTypography.labelMd.copyWith(color: onSurfaceVariant),
      labelSmall: AppTypography.labelSm.copyWith(color: onSurfaceVariant),
    );
  }
}
