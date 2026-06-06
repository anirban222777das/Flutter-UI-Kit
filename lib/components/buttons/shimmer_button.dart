import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A premium button with a continuous shimmering highlight effect.
///
/// Features an animated gradient sweep that passes over the button
/// surface, creating a metallic or luminous shine.
///
/// Example:
/// ```dart
/// ShimmerButton(
///   text: 'Upgrade to Pro',
///   onPressed: () {},
///   baseColor: Colors.black87,
///   shimmerColor: Colors.white24,
/// )
/// ```
class ShimmerButton extends StatefulWidget {
  const ShimmerButton({
    required this.text,
    super.key,
    this.onPressed,
    this.baseColor,
    this.shimmerColor,
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

  /// Base background color.
  final Color? baseColor;

  /// Shimmer highlight color.
  final Color? shimmerColor;

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
  State<ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<ShimmerButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = widget.baseColor ?? (isDark ? const Color(0xFF1E1E26) : const Color(0xFF0F172A));
    final shimmer = widget.shimmerColor ?? Colors.white.withValues(alpha: 0.15);

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
            // Sweep from -1.0 to 2.0 to give a pause between shimmers
            final slide = -1.0 + (_controller.value * 3.0);
            return Container(
              height: widget.height,
              width: widget.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    base,
                    base,
                    shimmer,
                    base,
                    base,
                  ],
                  stops: [
                    0.0,
                    slide - 0.2,
                    slide,
                    slide + 0.2,
                    1.0,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: base.withValues(alpha: _isPressed ? 0.4 : 0.2),
                    blurRadius: _isPressed ? 12 : 8,
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
