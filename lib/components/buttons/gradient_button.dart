import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A button with an animated gradient sweep effect.
///
/// The gradient rotates/shifts smoothly on hover or press,
/// creating a dynamic shimmering surface. Fully standalone.
///
/// Example:
/// ```dart
/// GradientButton(
///   text: 'Get Started',
///   onPressed: () {},
///   gradient: LinearGradient(
///     colors: [Colors.blue, Colors.purple],
///   ),
/// )
/// ```
class GradientButton extends StatefulWidget {
  const GradientButton({
    required this.text,
    super.key,
    this.onPressed,
    this.gradient,
    this.height = 52,
    this.width,
    this.borderRadius = 14,
    this.textStyle,
    this.elevation = 4,
    this.icon,
    this.animationDuration,
  });

  /// Button label text.
  final String text;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Gradient override. Defaults to an indigo-cyan gradient.
  final LinearGradient? gradient;

  /// Button height.
  final double height;

  /// Button width. Null for intrinsic width.
  final double? width;

  /// Corner radius.
  final double borderRadius;

  /// Text style override.
  final TextStyle? textStyle;

  /// Shadow elevation intensity.
  final double elevation;

  /// Optional leading icon.
  final IconData? icon;

  /// Duration of the gradient sweep animation.
  final Duration? animationDuration;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(seconds: 3),
    )..repeat();
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
    final defaultColors = const [
      Color(0xFF6366F1),
      Color(0xFF06B6D4),
      Color(0xFF8B5CF6),
    ];

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              height: widget.height,
              width: widget.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                gradient: widget.gradient ??
                    LinearGradient(
                      begin: Alignment(
                        -1.0 + 2.0 * _controller.value,
                        -0.5,
                      ),
                      end: Alignment(
                        1.0 + 2.0 * _controller.value,
                        0.5,
                      ),
                      colors: defaultColors,
                      tileMode: TileMode.mirror,
                    ),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: defaultColors.first
                        .withValues(alpha: _isPressed ? 0.4 : 0.25),
                    blurRadius: widget.elevation * (_isPressed ? 3 : 2),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: child,
            );
          },
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
