import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A premium glass-morphism button with frosted backdrop blur.
///
/// Features translucent surface with configurable blur, border glow,
/// and smooth tap-scale animation. Fully standalone and copy-paste ready.
///
/// Example:
/// ```dart
/// GlassButton(
///   text: 'Continue',
///   onPressed: () {},
///   blur: 20,
///   borderRadius: 24,
/// )
/// ```
class GlassButton extends StatefulWidget {
  const GlassButton({
    required this.text,
    super.key,
    this.onPressed,
    this.blur = 16,
    this.opacity = 0.12,
    this.borderRadius = 16,
    this.borderColor,
    this.textStyle,
    this.textColor,
    this.height = 52,
    this.width,
    this.icon,
    this.padding,
  });

  /// Button label text.
  final String text;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Blur intensity for the frosted glass effect.
  final double blur;

  /// Background opacity of the glass surface.
  final double opacity;

  /// Corner radius.
  final double borderRadius;

  /// Border color override. Defaults to white with low opacity.
  final Color? borderColor;

  /// Text style override.
  final TextStyle? textStyle;

  /// Text color override.
  final Color? textColor;

  /// Button height.
  final double height;

  /// Button width. Null for intrinsic width.
  final double? width;

  /// Optional leading icon.
  final IconData? icon;

  /// Content padding override.
  final EdgeInsets? padding;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBorderColor = widget.borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.5));
    final resolvedTextColor = widget.textColor ??
        (isDark ? Colors.white : Colors.white);

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.blur,
              sigmaY: widget.blur,
            ),
            child: AnimatedContainer(
              duration: AppDurations.fast,
              height: widget.height,
              width: widget.width,
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: widget.opacity),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: resolvedBorderColor,
                  width: 0.5,
                ),
                boxShadow: [
                  if (_isPressed)
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.05),
                      blurRadius: 16,
                    ),
                ],
              ),
              child: Row(
                mainAxisSize:
                    widget.width != null ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: resolvedTextColor, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: widget.textStyle ??
                        TextStyle(
                          fontFamily: 'Inter',
                          color: resolvedTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.1,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
