import 'package:flutter/material.dart';

/// Centralized border radius scale for the UIKit design system.
abstract final class AppRadius {
  /// 4px — extra small
  static const double xs = 4;

  /// 8px — small
  static const double sm = 8;

  /// 12px — medium
  static const double md = 12;

  /// 16px — large
  static const double lg = 16;

  /// 20px — extra large
  static const double xl = 20;

  /// 24px — double extra large
  static const double xxl = 24;

  /// 32px — triple extra large
  static const double xxxl = 32;

  /// 999px — fully rounded / pill shape
  static const double full = 999;

  // ──────────────────────────────────────────────
  // BorderRadius presets
  // ──────────────────────────────────────────────

  static const BorderRadius borderRadiusXs =
      BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderRadiusXxl =
      BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius borderRadiusFull =
      BorderRadius.all(Radius.circular(full));
}
