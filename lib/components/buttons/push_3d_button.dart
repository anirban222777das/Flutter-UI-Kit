import 'package:flutter/material.dart';

/// A highly tactile, 3D pushable button.
///
/// Features a thick bottom lip that compresses on tap,
/// simulating a physical mechanical keyboard switch or arcade button.
///
/// Example:
/// ```dart
/// Push3DButton(
///   text: 'Submit',
///   onPressed: () {},
///   color: Colors.indigo,
/// )
/// ```
class Push3DButton extends StatefulWidget {
  const Push3DButton({
    required this.text,
    super.key,
    this.onPressed,
    this.color,
    this.height = 56,
    this.width,
    this.borderRadius = 14,
    this.depth = 6.0,
    this.textStyle,
    this.icon,
  });

  /// Button label text.
  final String text;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Primary top face color.
  final Color? color;

  /// Button base height (excluding depth).
  final double height;

  /// Button width. Null for intrinsic width.
  final double? width;

  /// Corner radius.
  final double borderRadius;

  /// How "deep" or tall the 3D edge is.
  final double depth;

  /// Text style override.
  final TextStyle? textStyle;

  /// Optional leading icon.
  final IconData? icon;

  @override
  State<Push3DButton> createState() => _Push3DButtonState();
}

class _Push3DButtonState extends State<Push3DButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final topColor = widget.color ?? const Color(0xFF6366F1); // Indigo
    // Darken the top color to create the 3D lip effect
    final bottomColor = HSLColor.fromColor(topColor).withLightness(
        (HSLColor.fromColor(topColor).lightness - 0.15).clamp(0.0, 1.0)).toColor();

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: SizedBox(
        width: widget.width,
        height: widget.height + widget.depth,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Bottom 3D Lip
            Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                color: bottomColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            // Top Face that moves down when pressed
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOutCubic,
              bottom: _isPressed ? 0 : widget.depth,
              left: 0,
              right: 0,
              child: Container(
                height: widget.height,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: topColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
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
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.1,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
