import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A premium floating label text field with smooth label animation.
///
/// The label floats above the input on focus with a smooth
/// translation and scale animation. Fully standalone.
///
/// Example:
/// ```dart
/// FloatingLabelField(
///   label: 'Email',
///   hintText: 'you@example.com',
///   prefixIcon: Icons.email_outlined,
/// )
/// ```
class FloatingLabelField extends StatefulWidget {
  const FloatingLabelField({
    required this.label,
    super.key,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.borderRadius = 12,
    this.backgroundColor,
    this.borderColor,
    this.focusColor,
    this.textStyle,
    this.keyboardType,
    this.maxLines = 1,
  });

  /// Label text that floats above the input.
  final String label;

  /// Placeholder text.
  final String? hintText;

  /// Optional prefix icon.
  final IconData? prefixIcon;

  /// Optional suffix icon.
  final IconData? suffixIcon;

  /// Text editing controller.
  final TextEditingController? controller;

  /// Value change callback.
  final ValueChanged<String>? onChanged;

  /// Whether to obscure text (for passwords).
  final bool obscureText;

  /// Corner radius.
  final double borderRadius;

  /// Background color override.
  final Color? backgroundColor;

  /// Unfocused border color override.
  final Color? borderColor;

  /// Focused border/label color override.
  final Color? focusColor;

  /// Input text style override.
  final TextStyle? textStyle;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Maximum lines.
  final int maxLines;

  @override
  State<FloatingLabelField> createState() => _FloatingLabelFieldState();
}

class _FloatingLabelFieldState extends State<FloatingLabelField> {
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
    final accent = widget.focusColor ?? const Color(0xFF6366F1);
    final bgColor = widget.backgroundColor ??
        (isDark ? const Color(0xFF1E1E26) : const Color(0xFFF8F9FC));
    final defaultBorder = widget.borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.08));

    return AnimatedContainer(
      duration: AppDurations.quick,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: _isFocused ? accent : defaultBorder,
          width: _isFocused ? 1.5 : 1,
        ),
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        style: widget.textStyle ??
            TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
            ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          labelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: _isFocused
                ? accent
                : (isDark ? Colors.white38 : Colors.black38),
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: isDark ? Colors.white24 : Colors.black26,
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  size: 20,
                  color: _isFocused
                      ? accent
                      : (isDark ? Colors.white38 : Colors.black38),
                )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? Icon(
                  widget.suffixIcon,
                  size: 20,
                  color: isDark ? Colors.white38 : Colors.black38,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}
