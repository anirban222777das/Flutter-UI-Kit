import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A button with fluid morphing shape and gradient color transitions.
///
/// The button smoothly shifts its border radius and gradient colors
/// on press, creating a liquid-like feel. Fully standalone.
///
/// Example:
/// ```dart
/// LiquidButton(
///   text: 'Submit',
///   onPressed: () {},
///   colors: [Colors.purple, Colors.blue],
/// )
/// ```
class LiquidButton extends StatefulWidget {
  const LiquidButton({
    required this.text,
    super.key,
    this.onPressed,
    this.colors,
    this.height = 52,
    this.width,
    this.borderRadius = 16,
    this.pressedBorderRadius = 28,
    this.textStyle,
    this.icon,
  });

  /// Button label text.
  final String text;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Gradient colors. Defaults to indigo-purple gradient.
  final List<Color>? colors;

  /// Button height.
  final double height;

  /// Button width. Null for intrinsic width.
  final double? width;

  /// Corner radius in default state.
  final double borderRadius;

  /// Corner radius when pressed (morphing effect).
  final double pressedBorderRadius;

  /// Text style override.
  final TextStyle? textStyle;

  /// Optional leading icon.
  final IconData? icon;

  @override
  State<LiquidButton> createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors ??
        const [Color(0xFF6366F1), Color(0xFF8B5CF6)];
    final shiftedColors = _isPressed ? colors.reversed.toList() : colors;

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppDurations.quick,
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: AppDurations.medium,
          curve: Curves.easeOutBack,
          height: widget.height,
          width: widget.width,
          padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: shiftedColors,
            ),
            borderRadius: BorderRadius.circular(
              _isPressed ? widget.pressedBorderRadius : widget.borderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: _isPressed ? 0.4 : 0.25),
                blurRadius: _isPressed ? 20 : 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize:
                widget.width != null ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: widget.textStyle ??
                    const TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.1,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
