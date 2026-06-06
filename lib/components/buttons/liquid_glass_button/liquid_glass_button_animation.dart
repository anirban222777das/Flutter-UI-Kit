import 'package:flutter/material.dart';

/// Provides refined easing curves and physics for the LiquidGlassButton
/// to ensure physical believability and an expensive feel.
abstract class LiquidGlassAnimation {
  /// The curve used when the button is pressed down.
  /// Needs to feel tactile and immediate but not harsh.
  static const Curve pressCurve = Curves.easeOutCubic;

  /// The curve used when the button is released.
  /// Uses an elastic/spring-like easing to simulate physical material rebounding.
  static const Curve releaseCurve = ElasticOutCurve(0.85);

  /// Standard smooth curve for opacity and color transitions.
  static const Curve smoothCurve = Curves.easeInOutSine;
}
