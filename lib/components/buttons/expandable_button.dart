import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A button that expands from icon-only to full text+icon on tap.
///
/// Animates width and fades in text content for a smooth
/// progressive disclosure effect. Fully standalone.
///
/// Example:
/// ```dart
/// ExpandableButton(
///   icon: Icons.add_rounded,
///   expandedText: 'New Item',
///   onPressed: () {},
/// )
/// ```
class ExpandableButton extends StatefulWidget {
  const ExpandableButton({
    required this.icon,
    required this.expandedText,
    super.key,
    this.onPressed,
    this.collapsedSize = 48,
    this.expandedWidth = 160,
    this.height = 48,
    this.borderRadius = 24,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.textStyle,
    this.duration,
    this.expandOnTap = true,
  });

  /// Icon displayed in collapsed state.
  final IconData icon;

  /// Text shown when expanded.
  final String expandedText;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Width when collapsed (icon-only).
  final double collapsedSize;

  /// Width when expanded (icon + text).
  final double expandedWidth;

  /// Button height.
  final double height;

  /// Corner radius.
  final double borderRadius;

  /// Background color override.
  final Color? backgroundColor;

  /// Icon color override.
  final Color? iconColor;

  /// Text color override.
  final Color? textColor;

  /// Text style override.
  final TextStyle? textStyle;

  /// Animation duration override.
  final Duration? duration;

  /// Whether tapping toggles expanded state.
  final bool expandOnTap;

  @override
  State<ExpandableButton> createState() => _ExpandableButtonState();
}

class _ExpandableButtonState extends State<ExpandableButton> {
  bool _isExpanded = false;

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    if (!widget.expandOnTap) {
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? const Color(0xFF6366F1);
    final fgColor = widget.iconColor ?? Colors.white;
    final textColor = widget.textColor ?? Colors.white;

    return GestureDetector(
      onTap: () {
        _toggle();
        if (_isExpanded && widget.expandOnTap) {
          widget.onPressed?.call();
        }
      },
      child: AnimatedContainer(
        duration: widget.duration ?? AppDurations.normal,
        curve: Curves.easeOutCubic,
        width: _isExpanded ? widget.expandedWidth : widget.collapsedSize,
        height: widget.height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: bgColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: _isExpanded ? 16.0 : 0,
                ),
                child: Icon(widget.icon, color: fgColor, size: 22),
              ),
              if (_isExpanded) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: AnimatedOpacity(
                    opacity: _isExpanded ? 1.0 : 0.0,
                    duration: AppDurations.quick,
                    child: Text(
                      widget.expandedText,
                      style: widget.textStyle ??
                          TextStyle(
                            fontFamily: 'Inter',
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.1,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
