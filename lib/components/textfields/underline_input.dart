import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A minimal underline-only text input with animated focus indicator.
///
/// Features a thin animated underline that changes color and
/// width on focus. Fully standalone.
///
/// Example:
/// ```dart
/// UnderlineInput(
///   label: 'Full Name',
///   activeColor: Colors.indigo,
/// )
/// ```
class UnderlineInput extends StatefulWidget {
  const UnderlineInput({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.textStyle,
    this.labelStyle,
    this.obscureText = false,
    this.keyboardType,
  });

  /// Label displayed above the input.
  final String? label;

  /// Placeholder text.
  final String? hintText;

  /// Text editing controller.
  final TextEditingController? controller;

  /// Value change callback.
  final ValueChanged<String>? onChanged;

  /// Color when focused.
  final Color? activeColor;

  /// Color when unfocused.
  final Color? inactiveColor;

  /// Input text style override.
  final TextStyle? textStyle;

  /// Label text style override.
  final TextStyle? labelStyle;

  /// Whether to obscure text.
  final bool obscureText;

  /// Keyboard type.
  final TextInputType? keyboardType;

  @override
  State<UnderlineInput> createState() => _UnderlineInputState();
}

class _UnderlineInputState extends State<UnderlineInput> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = widget.activeColor ?? const Color(0xFF6366F1);
    final inactiveColor = widget.inactiveColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.12));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          AnimatedDefaultTextStyle(
            duration: AppDurations.quick,
            style: widget.labelStyle ??
                TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _isFocused
                      ? activeColor
                      : (isDark ? Colors.white38 : Colors.black38),
                  letterSpacing: 0.1,
                ),
            child: Text(widget.label!),
          ),
          const SizedBox(height: 8),
        ],

        // Text field
        TextField(
          focusNode: _focusNode,
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          style: widget.textStyle ??
              TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.2),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            isDense: true,
          ),
        ),

        // Animated underline
        AnimatedContainer(
          duration: AppDurations.normal,
          curve: Curves.easeOutCubic,
          height: _isFocused ? 2 : 1,
          decoration: BoxDecoration(
            color: _isFocused ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
}
