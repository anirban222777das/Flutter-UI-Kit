import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// Reusable animation utilities and presets for the UIKit design system.
///
/// Provides declarative animation chain presets built on `flutter_animate`
/// to ensure consistent motion language across all components.
extension AnimatePresets on Widget {
  /// Fade-in with upward slide — standard entrance animation.
  Widget fadeSlideIn({
    Duration? duration,
    Duration? delay,
    double offsetY = 20,
    Curve curve = Curves.easeOutCubic,
  }) {
    return animate(delay: delay).fadeIn(
      duration: duration ?? AppDurations.normal,
      curve: curve,
    ).slideY(
      begin: offsetY / 100,
      end: 0,
      duration: duration ?? AppDurations.normal,
      curve: curve,
    );
  }

  /// Scale-in entrance animation.
  Widget scaleIn({
    Duration? duration,
    Duration? delay,
    double begin = 0.9,
    Curve curve = Curves.easeOutCubic,
  }) {
    return animate(delay: delay).fadeIn(
      duration: duration ?? AppDurations.normal,
      curve: curve,
    ).scale(
      begin: Offset(begin, begin),
      end: const Offset(1, 1),
      duration: duration ?? AppDurations.normal,
      curve: curve,
    );
  }

  /// Staggered entrance animation for list items.
  ///
  /// Use [index] to calculate delay automatically.
  Widget staggeredEntrance({
    required int index,
    Duration? itemDuration,
    Duration? staggerDelay,
    double offsetY = 24,
  }) {
    final delay = (staggerDelay ?? AppDurations.staggerDelay) * index;
    return fadeSlideIn(
      duration: itemDuration ?? AppDurations.medium,
      delay: delay,
      offsetY: offsetY,
    );
  }
}

/// Utility class for creating common animation configurations.
abstract final class AnimationUtils {
  /// Creates a smooth scale animation for tap interactions.
  ///
  /// Returns a [Matrix4] transform suitable for use in
  /// `AnimatedContainer` or `Transform` widgets.
  static Matrix4 tapScale(bool isPressed, {double scale = 0.97}) {
    final s = isPressed ? scale : 1.0;
    return Matrix4.diagonal3Values(s, s, 1);
  }

  /// Calculates stagger delay for a given index in a list.
  static Duration staggerDelay(
    int index, {
    Duration base = const Duration(milliseconds: 50),
  }) {
    return base * index;
  }
}
