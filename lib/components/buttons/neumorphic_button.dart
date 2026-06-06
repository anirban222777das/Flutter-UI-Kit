import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A button that utilizes neuromorphic (soft UI) design.
///
/// Looks extruded from the background using double shadows (light top-left, dark bottom-right).
/// On press, the shadows shift to make it look inset.
/// Note: Works best when the button color matches the parent background color exactly.
///
/// Example:
/// ```dart
/// NeumorphicButton(
///   text: 'Settings',
///   onPressed: () {},
///   backgroundColor: const Color(0xFFE0E5EC), // Should match parent background
/// )
/// ```
class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton({
    required this.text,
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height = 56,
    this.width,
    this.borderRadius = 16,
    this.textStyle,
    this.icon,
  });

  /// Button label text.
  final String text;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Background color. Essential for the effect that it matches the parent widget's color.
  final Color? backgroundColor;

  /// Text and icon color.
  final Color? textColor;

  /// Button height.
  final double height;

  /// Button width. Null for intrinsic width.
  final double? width;

  /// Corner radius.
  final double borderRadius;

  /// Text style override.
  final TextStyle? textStyle;

  /// Optional leading icon.
  final IconData? icon;

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // For neuromorphism to work, you typically want a neutral slightly off-white or off-black.
    final bgColor = widget.backgroundColor ?? (isDark ? const Color(0xFF292D32) : const Color(0xFFE0E5EC));
    final fgColor = widget.textColor ?? (isDark ? Colors.white70 : Colors.black54);

    final lightShadowColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;
    final darkShadowColor = isDark ? Colors.black.withValues(alpha: 0.5) : const Color(0xFFA3B1C6);

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        height: widget.height,
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isPressed
              ? [
                  // When pressed, shadows become much smaller and tighter to simulate being pushed in
                  BoxShadow(
                    color: darkShadowColor,
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: lightShadowColor,
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ]
              : [
                  // Extruded state
                  BoxShadow(
                    color: darkShadowColor,
                    offset: const Offset(6, 6),
                    blurRadius: 12,
                  ),
                  BoxShadow(
                    color: lightShadowColor,
                    offset: const Offset(-6, -6),
                    blurRadius: 12,
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: widget.width != null ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: fgColor, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              widget.text,
              style: widget.textStyle ??
                  TextStyle(
                    fontFamily: 'Inter',
                    color: fgColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
