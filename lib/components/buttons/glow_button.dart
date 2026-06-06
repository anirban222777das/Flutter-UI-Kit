import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A vibrant button that pulsates with a glowing shadow.
///
/// Features an animated drop shadow that breathes, giving the
/// button a neon or luminous feel.
///
/// Example:
/// ```dart
/// GlowButton(
///   text: 'Live Now',
///   onPressed: () {},
///   color: Colors.redAccent,
/// )
/// ```
class GlowButton extends StatefulWidget {
  const GlowButton({
    required this.text,
    super.key,
    this.onPressed,
    this.color,
    this.height = 52,
    this.width,
    this.borderRadius = 14,
    this.textStyle,
    this.icon,
  });

  /// Button label text.
  final String text;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Primary color for background and glow.
  final Color? color;

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
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final primary = widget.color ?? const Color(0xFFEC4899); // Vibrant Pink

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Pulse glow between 0.4 and 0.8 opacity, and 12 to 24 blur radius
            final pulseValue = Curves.easeInOut.transform(_controller.value);
            final glowOpacity = _isPressed ? 0.9 : 0.4 + (pulseValue * 0.4);
            final blurRadius = _isPressed ? 28.0 : 12.0 + (pulseValue * 12.0);

            return Container(
              height: widget.height,
              width: widget.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: glowOpacity),
                    blurRadius: blurRadius,
                    spreadRadius: _isPressed ? 4 : 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Row(
            mainAxisSize: widget.width != null ? MainAxisSize.max : MainAxisSize.min,
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
                      letterSpacing: 0.2,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
