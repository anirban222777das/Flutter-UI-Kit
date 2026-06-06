import 'package:flutter/material.dart';

import 'liquid_glass_button_style.dart';

/// A theme extension to allow global customization of the [LiquidGlassButton].
///
/// This provides semantic colors and reflection configurations that adapt
/// to light and dark themes or branded design systems.
class LiquidGlassButtonTheme extends ThemeExtension<LiquidGlassButtonTheme> {
  const LiquidGlassButtonTheme({
    this.primaryColor,
    this.secondaryColor,
    this.destructiveColor,
    this.subtleColor,
    this.reflectionColor,
    this.shadowColor,
  });

  /// The base tint hue for the primary variant.
  final Color? primaryColor;

  /// The base tint hue for the secondary variant.
  final Color? secondaryColor;

  /// The base tint hue for the destructive variant.
  final Color? destructiveColor;

  /// The base tint hue for the subtle variant.
  final Color? subtleColor;

  /// The color used for edge highlights and specular gloss (usually white).
  final Color? reflectionColor;

  /// The color used for the ambient depth shadow.
  final Color? shadowColor;

  @override
  ThemeExtension<LiquidGlassButtonTheme> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? destructiveColor,
    Color? subtleColor,
    Color? reflectionColor,
    Color? shadowColor,
  }) {
    return LiquidGlassButtonTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      destructiveColor: destructiveColor ?? this.destructiveColor,
      subtleColor: subtleColor ?? this.subtleColor,
      reflectionColor: reflectionColor ?? this.reflectionColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  ThemeExtension<LiquidGlassButtonTheme> lerp(
    covariant ThemeExtension<LiquidGlassButtonTheme>? other,
    double t,
  ) {
    if (other is! LiquidGlassButtonTheme) return this;
    return LiquidGlassButtonTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t),
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t),
      destructiveColor: Color.lerp(destructiveColor, other.destructiveColor, t),
      subtleColor: Color.lerp(subtleColor, other.subtleColor, t),
      reflectionColor: Color.lerp(reflectionColor, other.reflectionColor, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
    );
  }

  /// Helper to get the base tint color for a specific variant.
  Color getColorForVariant(BuildContext context, LiquidGlassButtonVariant variant) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (variant) {
      case LiquidGlassButtonVariant.primary:
        return primaryColor ?? theme.colorScheme.primary;
      case LiquidGlassButtonVariant.secondary:
        return secondaryColor ?? (isDark ? Colors.grey[700]! : Colors.white);
      case LiquidGlassButtonVariant.destructive:
        return destructiveColor ?? theme.colorScheme.error;
      case LiquidGlassButtonVariant.subtle:
        return subtleColor ?? (isDark ? Colors.white12 : Colors.black12);
    }
  }

  /// Helper to get the default theme configuration.
  static LiquidGlassButtonTheme defaultTheme(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LiquidGlassButtonTheme(
      primaryColor: theme.colorScheme.primary,
      secondaryColor: isDark ? Colors.grey[800]! : Colors.white,
      destructiveColor: theme.colorScheme.error,
      subtleColor: isDark ? Colors.white24 : Colors.black12,
      reflectionColor: Colors.white,
      shadowColor: isDark ? Colors.black : Colors.black87,
    );
  }
}
