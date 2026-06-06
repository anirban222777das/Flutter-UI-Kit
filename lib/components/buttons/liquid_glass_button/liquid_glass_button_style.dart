
/// Defines the size variant of the LiquidGlassButton.
enum LiquidGlassButtonSize {
  /// Small size, suitable for tight spaces or secondary actions.
  small,

  /// Standard medium size, default for most actions.
  medium,

  /// Large size, ideal for primary call-to-actions.
  large;

  /// Returns the height for the specific size variant.
  double get height => switch (this) {
        LiquidGlassButtonSize.small => 36.0,
        LiquidGlassButtonSize.medium => 48.0,
        LiquidGlassButtonSize.large => 56.0,
      };

  /// Returns the horizontal padding for the specific size variant.
  double get horizontalPadding => switch (this) {
        LiquidGlassButtonSize.small => 16.0,
        LiquidGlassButtonSize.medium => 24.0,
        LiquidGlassButtonSize.large => 32.0,
      };

  /// Returns the icon size for the specific size variant.
  double get iconSize => switch (this) {
        LiquidGlassButtonSize.small => 16.0,
        LiquidGlassButtonSize.medium => 20.0,
        LiquidGlassButtonSize.large => 24.0,
      };
}

/// Defines the visual variant/intent of the LiquidGlassButton.
enum LiquidGlassButtonVariant {
  /// The primary action (e.g., Submit, Continue).
  primary,

  /// A secondary action.
  secondary,

  /// A destructive or dangerous action (e.g., Delete, Remove).
  destructive,

  /// A subtle, low-emphasis action.
  subtle;
}
