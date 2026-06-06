

/// Core constants for the LiquidGlassButton to ensure consistency
/// and avoid magic numbers in the implementation.
abstract class LiquidGlassConstants {
  // Blur Values
  /// The standard blur sigma for the glass effect.
  static const double blurSigma = 18.0;

  // Base Opacities
  /// The base opacity for the surface tint in light mode.
  static const double tintOpacityLight = 0.25;

  /// The base opacity for the surface tint in dark mode.
  static const double tintOpacityDark = 0.15;

  /// The opacity added when the button is hovered.
  static const double hoverOpacityIncrement = 0.08;

  /// The opacity added when the button is pressed (increases density).
  static const double pressedOpacityIncrement = 0.15;

  /// The opacity multiplier when the button is disabled.
  static const double disabledOpacityMultiplier = 0.5;

  // Reflection Opacities
  /// The maximum opacity of the top edge reflection.
  static const double reflectionMaxOpacity = 0.4;

  /// The specular gloss overlay opacity.
  static const double glossOpacity = 0.08;

  // Shadow Opacities
  /// The ambient depth shadow opacity.
  static const double shadowOpacity = 0.12;

  // Animation Durations
  /// Duration for quick interactive state changes (hover, focus).
  static const Duration interactionDuration = Duration(milliseconds: 150);

  /// Duration for pressed state (usually faster for responsiveness).
  static const Duration pressDuration = Duration(milliseconds: 100);

  /// Duration for release or reset states.
  static const Duration releaseDuration = Duration(milliseconds: 300);

  /// Duration for the loading indicator crossfade.
  static const Duration crossfadeDuration = Duration(milliseconds: 250);

  // Scales
  /// The scale down factor when the button is pressed.
  static const double pressScale = 0.96;
}
