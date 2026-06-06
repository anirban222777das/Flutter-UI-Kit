import 'package:flutter/material.dart';

/// Centralized spacing scale for the UIKit design system.
///
/// Based on a 4px base unit with harmonious increments.
/// Use these constants instead of hardcoded numeric values.
abstract final class AppSpacing {
  /// 2px — micro spacing
  static const double xxs = 2;

  /// 4px — extra small
  static const double xs = 4;

  /// 8px — small
  static const double sm = 8;

  /// 12px — medium
  static const double md = 12;

  /// 16px — large (default)
  static const double lg = 16;

  /// 20px — between lg and xl
  static const double lgx = 20;

  /// 24px — extra large
  static const double xl = 24;

  /// 32px — double extra large
  static const double xxl = 32;

  /// 48px — triple extra large
  static const double xxxl = 48;

  /// 64px — section spacing
  static const double section = 64;

  /// 96px — hero spacing
  static const double hero = 96;

  // ──────────────────────────────────────────────
  // Edge insets presets
  // ──────────────────────────────────────────────

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl =
      EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets paddingVerticalSm =
      EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: md);
}
