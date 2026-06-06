import 'package:flutter/material.dart';

/// Centralized color system for the UIKit design system.
///
/// Provides semantic color tokens for both light and dark themes.
/// Colors are inspired by Linear, Arc Browser, and Apple design systems
/// with a curated slate/indigo palette.
abstract final class AppColors {
  // ──────────────────────────────────────────────
  // Brand / Accent
  // ──────────────────────────────────────────────

  /// Primary accent — indigo
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primarySubtle = Color(0xFFEEF2FF);
  static const Color primarySubtleDark = Color(0xFF1E1B4B);

  // ──────────────────────────────────────────────
  // Semantic
  // ──────────────────────────────────────────────

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ──────────────────────────────────────────────
  // Light Theme
  // ──────────────────────────────────────────────

  static const Color lightBackground = Color(0xFFFAFAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF4F4F8);
  static const Color lightOnBackground = Color(0xFF0F172A);
  static const Color lightOnSurface = Color(0xFF1E293B);
  static const Color lightOnSurfaceVariant = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderSubtle = Color(0xFFF1F5F9);
  static const Color lightMuted = Color(0xFF94A3B8);
  static const Color lightScrim = Color(0x33000000);

  // ──────────────────────────────────────────────
  // Dark Theme
  // ──────────────────────────────────────────────

  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color darkSurface = Color(0xFF141419);
  static const Color darkSurfaceVariant = Color(0xFF1E1E26);
  static const Color darkOnBackground = Color(0xFFF8FAFC);
  static const Color darkOnSurface = Color(0xFFE2E8F0);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF2D2D3A);
  static const Color darkBorderSubtle = Color(0xFF1E1E26);
  static const Color darkMuted = Color(0xFF64748B);
  static const Color darkScrim = Color(0x80000000);

  // ──────────────────────────────────────────────
  // Category accent colors (for catalog tiles)
  // ──────────────────────────────────────────────

  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentRose = Color(0xFFF43F5E);
  static const Color accentAmber = Color(0xFFF59E0B);

  /// Gradient presets for component accents.
  static const List<Color> gradientIndigo = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
  ];

  static const List<Color> gradientBlue = [
    Color(0xFF3B82F6),
    Color(0xFF06B6D4),
  ];

  static const List<Color> gradientSunset = [
    Color(0xFFF97316),
    Color(0xFFEC4899),
  ];

  static const List<Color> gradientNeon = [
    Color(0xFF22D3EE),
    Color(0xFF818CF8),
  ];
}
