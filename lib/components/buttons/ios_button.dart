import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A Cupertino-inspired button with opacity-based press feedback.
///
/// Mimics iOS native button feel with a subtle scale-down and
/// opacity reduction on press. Supports filled, tinted, and plain styles.
///
/// Example:
/// ```dart
/// IosButton(
///   text: 'Done',
///   onPressed: () {},
///   style: IosButtonStyle.filled,
/// )
/// ```
enum IosButtonStyle {
  /// Solid filled background.
  filled,

  /// Tinted translucent background.
  tinted,

  /// No background — text only.
  plain,
}

class IosButton extends StatefulWidget {
  const IosButton({
    required this.text,
    super.key,
    this.onPressed,
    this.style = IosButtonStyle.filled,
    this.color,
    this.textColor,
    this.height = 48,
    this.width,
    this.borderRadius = 12,
    this.textStyle,
    this.icon,
    this.fontSize = 16,
  });

  /// Button label text.
  final String text;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Visual style variant.
  final IosButtonStyle style;

  /// Accent color. Defaults to system blue.
  final Color? color;

  /// Text/icon color override.
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

  /// Font size for the label.
  final double fontSize;

  @override
  State<IosButton> createState() => _IosButtonState();
}

class _IosButtonState extends State<IosButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final accent = widget.color ?? const Color(0xFF007AFF);

    Color backgroundColor;
    Color foregroundColor;

    switch (widget.style) {
      case IosButtonStyle.filled:
        backgroundColor = accent;
        foregroundColor = widget.textColor ?? Colors.white;
      case IosButtonStyle.tinted:
        backgroundColor = accent.withValues(alpha: 0.12);
        foregroundColor = widget.textColor ?? accent;
      case IosButtonStyle.plain:
        backgroundColor = Colors.transparent;
        foregroundColor = widget.textColor ?? accent;
    }

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.7 : 1.0,
          duration: AppDurations.fastest,
          child: Container(
            height: widget.height,
            width: widget.width,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Row(
              mainAxisSize: widget.width != null
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: foregroundColor, size: 20),
                  const SizedBox(width: 6),
                ],
                Text(
                  widget.text,
                  style: widget.textStyle ??
                      TextStyle(
                        fontFamily: 'Inter',
                        color: foregroundColor,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
