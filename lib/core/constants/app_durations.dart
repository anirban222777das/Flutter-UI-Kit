import 'package:flutter/animation.dart';

/// Centralized animation duration and curve presets.
///
/// All animation timing should reference these constants
/// to maintain consistent motion across the design system.
abstract final class AppDurations {
  /// 100ms — micro interactions (opacity, color)
  static const Duration fastest = Duration(milliseconds: 100);

  /// 150ms — fast transitions
  static const Duration fast = Duration(milliseconds: 150);

  /// 200ms — quick transitions
  static const Duration quick = Duration(milliseconds: 200);

  /// 300ms — normal/default transitions
  static const Duration normal = Duration(milliseconds: 300);

  /// 400ms — medium transitions
  static const Duration medium = Duration(milliseconds: 400);

  /// 500ms — slow transitions
  static const Duration slow = Duration(milliseconds: 500);

  /// 800ms — very slow / dramatic transitions
  static const Duration verySlow = Duration(milliseconds: 800);

  /// 1200ms — page-level transitions
  static const Duration pageTransition = Duration(milliseconds: 1200);

  /// Stagger delay between items in a list
  static const Duration staggerDelay = Duration(milliseconds: 50);
}

/// Curated animation curves for the UIKit design system.
///
/// Prefer these over raw [Curves] constants for design consistency.
abstract final class AppCurves {
  /// Default easing for most transitions.
  static const Curve defaultCurve = Curves.easeOutCubic;

  /// Snappy spring-like feel for interactive elements.
  static const Curve snappy = Curves.easeOutBack;

  /// Gentle deceleration for large-scale motion.
  static const Curve gentle = Curves.easeOutQuart;

  /// Emphasis curve for entrance animations.
  static const Curve entrance = Curves.easeOutExpo;

  /// Exit curve for leaving animations.
  static const Curve exit = Curves.easeInCubic;

  /// Bounce-style for playful interactions.
  static const Curve bounce = Curves.elasticOut;

  /// Smooth overshoot for scale/transform.
  static const Curve overshoot = Curves.easeOutBack;
}
