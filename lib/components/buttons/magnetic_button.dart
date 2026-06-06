import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A button that subtly follows the user's finger/cursor position,
/// creating a magnetic attraction effect.
///
/// On press, the button shifts slightly toward the press position.
/// On release, it springs back to center. Fully standalone.
///
/// Example:
/// ```dart
/// MagneticButton(
///   text: 'Explore',
///   onPressed: () {},
///   magneticStrength: 0.3,
/// )
/// ```
class MagneticButton extends StatefulWidget {
  const MagneticButton({
    required this.text,
    super.key,
    this.onPressed,
    this.magneticStrength = 0.25,
    this.height = 52,
    this.width,
    this.borderRadius = 14,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.icon,
  });

  /// Button label text.
  final String text;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Strength of the magnetic pull effect (0.0 to 1.0).
  final double magneticStrength;

  /// Button height.
  final double height;

  /// Button width. Null for intrinsic width.
  final double? width;

  /// Corner radius.
  final double borderRadius;

  /// Background color override.
  final Color? backgroundColor;

  /// Text color override.
  final Color? textColor;

  /// Text style override.
  final TextStyle? textStyle;

  /// Optional leading icon.
  final IconData? icon;

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> {
  Offset _offset = Offset.zero;
  bool _isPressed = false;
  final GlobalKey _buttonKey = GlobalKey();

  void _onPanUpdate(DragUpdateDetails details) {
    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    // Calculate offset from center, clamped
    final dx = (localPosition.dx - size.width / 2) * widget.magneticStrength;
    final dy = (localPosition.dy - size.height / 2) * widget.magneticStrength;

    setState(() {
      _offset = Offset(
        dx.clamp(-12.0, 12.0),
        dy.clamp(-8.0, 8.0),
      );
    });
  }

  void _onPanEnd(DragEndDetails _) {
    setState(() {
      _offset = Offset.zero;
      _isPressed = false;
    });
  }

  void _onTapDown(TapDownDetails details) {
    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final dx = (localPosition.dx - size.width / 2) * widget.magneticStrength;
    final dy = (localPosition.dy - size.height / 2) * widget.magneticStrength;

    setState(() {
      _isPressed = true;
      _offset = Offset(dx.clamp(-10.0, 10.0), dy.clamp(-6.0, 6.0));
    });
  }

  void _onTapUp(TapUpDetails _) {
    setState(() {
      _isPressed = false;
      _offset = Offset.zero;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
      _offset = Offset.zero;
    });
  }

  Matrix4 _buildTransform() {
    final s = _isPressed ? 0.97 : 1.0;
    // Build transform without deprecated methods
    return Matrix4.diagonal3Values(s, s, 1)
      ..setTranslationRaw(_offset.dx, _offset.dy, 0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ??
        (isDark ? const Color(0xFF1E1E26) : const Color(0xFF0F172A));
    final fgColor = widget.textColor ?? Colors.white;

    return GestureDetector(
      key: _buttonKey,
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedContainer(
        duration: _isPressed ? AppDurations.fast : AppDurations.medium,
        curve: _isPressed ? Curves.easeOut : Curves.easeOutBack,
        transform: _buildTransform(),
        transformAlignment: Alignment.center,
        height: widget.height,
        width: widget.width,
        padding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: bgColor.withValues(alpha: 0.3),
              blurRadius: _isPressed ? 16 : 8,
              offset: Offset(
                _offset.dx * 0.3,
                4 + _offset.dy * 0.3,
              ),
            ),
          ],
        ),
        child: Row(
          mainAxisSize:
              widget.width != null ? MainAxisSize.max : MainAxisSize.min,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
