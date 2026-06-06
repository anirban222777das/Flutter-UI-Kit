import 'package:flutter/material.dart';

/// Convenience extensions on [BuildContext] for quick access to
/// theme, colors, typography, and media query properties.
extension ContextExtensions on BuildContext {
  // ──────────────────────────────────────────────
  // Theme
  // ──────────────────────────────────────────────

  /// Current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Current [ColorScheme].
  ColorScheme get colors => theme.colorScheme;

  /// Current [TextTheme].
  TextTheme get textTheme => theme.textTheme;

  /// Whether the current theme is dark mode.
  bool get isDark => theme.brightness == Brightness.dark;

  // ──────────────────────────────────────────────
  // Media Query
  // ──────────────────────────────────────────────

  /// Screen size.
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Screen width.
  double get screenWidth => screenSize.width;

  /// Screen height.
  double get screenHeight => screenSize.height;

  /// Bottom padding (e.g., safe area).
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  /// Top padding (e.g., status bar).
  double get topPadding => MediaQuery.paddingOf(this).top;

  // ──────────────────────────────────────────────
  // Responsive breakpoints
  // ──────────────────────────────────────────────

  /// Whether the screen is compact (phone portrait).
  bool get isCompact => screenWidth < 600;

  /// Whether the screen is medium (tablet / phone landscape).
  bool get isMedium => screenWidth >= 600 && screenWidth < 1024;

  /// Whether the screen is expanded (large tablet / desktop).
  bool get isExpanded => screenWidth >= 1024;

  /// Responsive column count based on screen width.
  int get responsiveColumns {
    if (isCompact) return 2;
    if (isMedium) return 3;
    return 4;
  }
}
