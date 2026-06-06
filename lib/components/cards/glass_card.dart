import 'dart:ui';

import 'package:flutter/material.dart';

/// A frosted glass card with configurable backdrop blur.
///
/// Creates a premium translucent surface effect suitable for
/// overlaying on images or gradient backgrounds. Fully standalone.
///
/// Example:
/// ```dart
/// GlassCard(
///   blur: 20,
///   borderRadius: 20,
///   child: Padding(
///     padding: EdgeInsets.all(24),
///     child: Text('Hello World'),
///   ),
/// )
/// ```
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    super.key,
    this.blur = 16,
    this.opacity = 0.1,
    this.borderRadius = 20,
    this.borderColor,
    this.borderWidth = 0.5,
    this.padding,
    this.width,
    this.height,
    this.margin,
  });

  /// Content of the card.
  final Widget child;

  /// Blur intensity for the frosted glass effect.
  final double blur;

  /// Background opacity of the glass surface.
  final double opacity;

  /// Corner radius.
  final double borderRadius;

  /// Border color override. Defaults to white with low opacity.
  final Color? borderColor;

  /// Border width.
  final double borderWidth;

  /// Content padding.
  final EdgeInsets? padding;

  /// Card width.
  final double? width;

  /// Card height.
  final double? height;

  /// Outer margin.
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBorder = borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.6));

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.white)
                  .withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: resolvedBorder,
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
