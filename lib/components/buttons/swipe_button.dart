import 'package:flutter/material.dart';

/// A highly interactive "slide to confirm" button.
///
/// Features a thumb that the user must drag to the right to trigger the action.
/// Extremely satisfying micro-interaction, perfect for critical actions
/// (e.g. payment, delete).
///
/// Example:
/// ```dart
/// SwipeButton(
///   text: 'Slide to Pay',
///   onSwipeComplete: () {},
/// )
/// ```
class SwipeButton extends StatefulWidget {
  const SwipeButton({
    required this.text,
    super.key,
    this.onSwipeComplete,
    this.height = 64,
    this.width = 300,
    this.borderRadius = 32,
    this.backgroundColor,
    this.thumbColor,
    this.textStyle,
  });

  /// Button label text.
  final String text;

  /// Callback when the thumb reaches the end of the track.
  final VoidCallback? onSwipeComplete;

  /// Button height.
  final double height;

  /// Button width. Required for accurate drag calculation.
  final double width;

  /// Corner radius.
  final double borderRadius;

  /// Background track color.
  final Color? backgroundColor;

  /// Color of the draggable thumb.
  final Color? thumbColor;

  /// Text style override.
  final TextStyle? textStyle;

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _dragPosition = 0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isCompleted) return;

    setState(() {
      _dragPosition += details.delta.dx;
      
      // The max distance the thumb can travel
      final maxDrag = widget.width - widget.height;
      
      if (_dragPosition < 0) {
        _dragPosition = 0;
      } else if (_dragPosition >= maxDrag) {
        _dragPosition = maxDrag;
        _isCompleted = true;
        widget.onSwipeComplete?.call();
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isCompleted) return;

    // Spring back to 0 if not completed
    final Tween<double> tween = Tween(begin: _dragPosition, end: 0.0);
    final Animation<double> animation = tween.animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    animation.addListener(() {
      setState(() {
        _dragPosition = animation.value;
      });
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = widget.backgroundColor ?? (isDark ? const Color(0xFF1E1E26) : const Color(0xFFE2E8F0));
    final thumbColor = widget.thumbColor ?? const Color(0xFF6366F1);
    final textColor = isDark ? Colors.white54 : Colors.black54;

    final maxDrag = widget.width - widget.height;
    final opacity = (1 - (_dragPosition / maxDrag)).clamp(0.0, 1.0);

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Text
          Center(
            child: Opacity(
              opacity: opacity,
              child: Text(
                widget.text,
                style: widget.textStyle ??
                    TextStyle(
                      fontFamily: 'Inter',
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
              ),
            ),
          ),
          
          // Swipe Trail
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: _dragPosition + widget.height,
              decoration: BoxDecoration(
                color: thumbColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
          ),

          // Draggable Thumb
          Positioned(
            left: _dragPosition,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.height,
                height: widget.height,
                decoration: BoxDecoration(
                  color: _isCompleted ? const Color(0xFF22C55E) : thumbColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: (_isCompleted ? const Color(0xFF22C55E) : thumbColor).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(2, 0),
                    )
                  ],
                ),
                child: Icon(
                  _isCompleted ? Icons.check_rounded : Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
