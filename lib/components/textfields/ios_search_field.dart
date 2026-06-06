import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A Cupertino-style search field with animated cancel button.
///
/// Mimics iOS system search field behavior with the cancel
/// button sliding in on focus. Fully standalone.
///
/// Example:
/// ```dart
/// IosSearchField(
///   placeholder: 'Search...',
///   onChanged: (query) => print(query),
/// )
/// ```
class IosSearchField extends StatefulWidget {
  const IosSearchField({
    super.key,
    this.placeholder = 'Search',
    this.onChanged,
    this.onCancel,
    this.controller,
    this.backgroundColor,
    this.borderRadius = 10,
    this.height = 36,
  });

  /// Placeholder text.
  final String placeholder;

  /// Value change callback.
  final ValueChanged<String>? onChanged;

  /// Cancel button callback.
  final VoidCallback? onCancel;

  /// Text editing controller.
  final TextEditingController? controller;

  /// Background color override.
  final Color? backgroundColor;

  /// Corner radius.
  final double borderRadius;

  /// Input height.
  final double height;

  @override
  State<IosSearchField> createState() => _IosSearchFieldState();
}

class _IosSearchFieldState extends State<IosSearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _cancel() {
    _controller.clear();
    _focusNode.unfocus();
    widget.onChanged?.call('');
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.06)
            : const Color(0xFFF2F2F7));

    return Row(
      children: [
        // Search field
        Expanded(
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    CupertinoIcons.search,
                    size: 18,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: widget.onChanged,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.3),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _controller.clear();
                      widget.onChanged?.call('');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        size: 18,
                        color: isDark ? Colors.white30 : Colors.black26,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Cancel button
        AnimatedContainer(
          duration: AppDurations.normal,
          curve: Curves.easeOutCubic,
          width: _isFocused ? 70 : 0,
          child: AnimatedOpacity(
            duration: AppDurations.quick,
            opacity: _isFocused ? 1.0 : 0.0,
            child: GestureDetector(
              onTap: _cancel,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Color(0xFF007AFF),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
