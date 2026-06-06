import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A glass-morphism text input with frosted blur background.
///
/// Features animated focus border glow and backdrop blur
/// for a premium translucent appearance. Fully standalone.
///
/// Example:
/// ```dart
/// GlassInput(
///   hintText: 'Search...',
///   blur: 20,
///   prefixIcon: Icons.search_rounded,
/// )
/// ```
class GlassInput extends StatefulWidget {
  const GlassInput({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.blur = 16,
    this.opacity = 0.08,
    this.borderRadius = 14,
    this.borderColor,
    this.focusColor,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
    this.height = 52,
    this.obscureText = false,
  });

  /// Placeholder text.
  final String? hintText;

  /// Text editing controller.
  final TextEditingController? controller;

  /// Value change callback.
  final ValueChanged<String>? onChanged;

  /// Blur intensity.
  final double blur;

  /// Background opacity.
  final double opacity;

  /// Corner radius.
  final double borderRadius;

  /// Unfocused border color.
  final Color? borderColor;

  /// Focused glow color.
  final Color? focusColor;

  /// Optional prefix icon.
  final IconData? prefixIcon;

  /// Optional suffix icon.
  final IconData? suffixIcon;

  /// Input text style override.
  final TextStyle? textStyle;

  /// Input height.
  final double height;

  /// Whether to obscure text.
  final bool obscureText;

  @override
  State<GlassInput> createState() => _GlassInputState();
}

class _GlassInputState extends State<GlassInput> {
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
    final defaultBorder = widget.borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.5));

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.blur,
          sigmaY: widget.blur,
        ),
        child: AnimatedContainer(
          duration: AppDurations.quick,
          curve: Curves.easeOutCubic,
          height: widget.height,
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black)
                .withValues(alpha: widget.opacity),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isFocused
                  ? accent.withValues(alpha: 0.6)
                  : defaultBorder,
              width: _isFocused ? 1.5 : 0.5,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.15),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            focusNode: _focusNode,
            controller: widget.controller,
            onChanged: widget.onChanged,
            obscureText: widget.obscureText,
            style: widget.textStyle ??
                TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.white,
                ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.6),
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      size: 20,
                      color: _isFocused
                          ? accent
                          : (isDark ? Colors.white38 : Colors.white60),
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? Icon(
                      widget.suffixIcon,
                      size: 20,
                      color: isDark ? Colors.white38 : Colors.white60,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
