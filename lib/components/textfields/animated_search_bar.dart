import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// An expandable search bar that slides open on tap.
///
/// Starts as a compact icon button and expands to reveal
/// the full text input. The icon transforms into a close button.
/// Fully standalone.
///
/// Example:
/// ```dart
/// AnimatedSearchBar(
///   hintText: 'Search components...',
///   onChanged: (query) => print(query),
/// )
/// ```
class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.expandedWidth = 280,
    this.collapsedSize = 44,
    this.height = 44,
    this.borderRadius = 22,
    this.backgroundColor,
    this.iconColor,
    this.textStyle,
    this.duration,
  });

  /// Placeholder text.
  final String hintText;

  /// Value change callback.
  final ValueChanged<String>? onChanged;

  /// Submit callback.
  final ValueChanged<String>? onSubmitted;

  /// Width when expanded.
  final double expandedWidth;

  /// Size when collapsed (icon-only).
  final double collapsedSize;

  /// Input height.
  final double height;

  /// Corner radius.
  final double borderRadius;

  /// Background color override.
  final Color? backgroundColor;

  /// Icon color override.
  final Color? iconColor;

  /// Input text style override.
  final TextStyle? textStyle;

  /// Animation duration override.
  final Duration? duration;

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool _isExpanded = false;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _expand() {
    setState(() => _isExpanded = true);
    Future<void>.delayed(
      widget.duration ?? AppDurations.normal,
      () {
        if (mounted) _focusNode.requestFocus();
      },
    );
  }

  void _collapse() {
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.unfocus();
    setState(() => _isExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.05));
    final fgColor = widget.iconColor ??
        (isDark ? Colors.white60 : Colors.black45);

    return AnimatedContainer(
      duration: widget.duration ?? AppDurations.normal,
      curve: Curves.easeOutCubic,
      width: _isExpanded ? widget.expandedWidth : widget.collapsedSize,
      height: widget.height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: _isExpanded
              ? (isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.08))
              : Colors.transparent,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Search/Close icon
          GestureDetector(
            onTap: _isExpanded ? _collapse : _expand,
            child: SizedBox(
              width: widget.collapsedSize,
              height: widget.height,
              child: AnimatedSwitcher(
                duration: AppDurations.quick,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Icon(
                  _isExpanded
                      ? Icons.close_rounded
                      : Icons.search_rounded,
                  key: ValueKey(_isExpanded),
                  color: fgColor,
                  size: 20,
                ),
              ),
            ),
          ),
          // Text input
          if (_isExpanded)
            Expanded(
              child: AnimatedOpacity(
                duration: AppDurations.quick,
                opacity: _isExpanded ? 1.0 : 0.0,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  style: widget.textStyle ??
                      TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: isDark ? Colors.white24 : Colors.black26,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(right: 16),
                    isDense: true,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
