import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'liquid_glass_button_animation.dart';
import 'liquid_glass_button_constants.dart';
import 'liquid_glass_button_painter.dart';
import 'liquid_glass_button_style.dart';
import 'liquid_glass_button_theme.dart';

/// A production-ready, highly optimized Liquid Glass Button.
///
/// Simulates premium polished acrylic/glass interfaces (e.g., visionOS, macOS)
/// using realistic layered translucency, edge lighting, and depth simulation.
///
/// Example:
/// ```dart
/// LiquidGlassButton(
///   text: 'Continue',
///   onPressed: () {},
///   icon: Icons.arrow_forward_rounded,
///   variant: LiquidGlassButtonVariant.primary,
/// )
/// ```
class LiquidGlassButton extends StatefulWidget {
  const LiquidGlassButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.size = LiquidGlassButtonSize.medium,
    this.variant = LiquidGlassButtonVariant.primary,
    this.borderRadius = 24.0,
    this.blurSigma = LiquidGlassConstants.blurSigma,
    this.isLoading = false,
    this.width,
  }) : assert(
          text != null || icon != null,
          'LiquidGlassButton must have either text, an icon, or both.',
        );

  /// The text label to display.
  final String? text;

  /// An optional leading icon.
  final IconData? icon;

  /// The callback when the button is pressed. If null, the button is disabled.
  final VoidCallback? onPressed;

  /// The size variant controlling height and padding.
  final LiquidGlassButtonSize size;

  /// The visual style variant controlling the base tint color.
  final LiquidGlassButtonVariant variant;

  /// The corner radius of the button.
  final double borderRadius;

  /// The strength of the background blur.
  /// Lower values increase performance but reduce the frosted effect.
  final double blurSigma;

  /// Whether the button is in a loading state. Displays a spinner if true.
  final bool isLoading;

  /// The width of the button. Null defaults to intrinsic width.
  final double? width;

  @override
  State<LiquidGlassButton> createState() => _LiquidGlassButtonState();
}

class _LiquidGlassButtonState extends State<LiquidGlassButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  late final AnimationController _pressController;
  late final Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: LiquidGlassConstants.pressDuration,
      reverseDuration: LiquidGlassConstants.releaseDuration,
    );

    _pressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: LiquidGlassAnimation.pressCurve,
        reverseCurve: LiquidGlassAnimation.releaseCurve,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  bool get _isDisabled => widget.onPressed == null || widget.isLoading;

  void _handleTapDown(TapDownDetails details) {
    if (_isDisabled) return;
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isDisabled) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (_isDisabled) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _handleHover(bool isHovered) {
    if (_isDisabled) return;
    setState(() => _isHovered = isHovered);
  }

  void _handleFocusChange(bool isFocused) {
    if (_isDisabled) return;
    setState(() => _isFocused = isFocused);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Resolve Theme Extension
    final glassTheme = theme.extension<LiquidGlassButtonTheme>() ??
        LiquidGlassButtonTheme.defaultTheme(context);

    // Resolve Colors
    final reflectionColor = glassTheme.reflectionColor ?? Colors.white;
    final shadowColor = glassTheme.shadowColor ?? Colors.black;

    // Force the base color to be white to act strictly as optical glass, 
    // unless the variant is explicitly destructive. This makes it look like real glass 
    // instead of a flat colored button.
    final baseColor = widget.variant == LiquidGlassButtonVariant.destructive 
        ? Colors.redAccent 
        : Colors.white;

    // Use extreme low opacity for the glass body to let the BackdropFilter do the work
    final double baseOpacity = isDark ? 0.08 : 0.4;

    double targetOpacity = baseOpacity;
    if (_isHovered || _isFocused) {
      targetOpacity += 0.05;
    }
    if (_isPressed) {
      targetOpacity += 0.1;
    }
    if (_isDisabled) {
      targetOpacity *= 0.5;
    }

    final effectiveColor = baseColor.withValues(alpha: targetOpacity);
    final foregroundColor = isDark ? Colors.white : Colors.black87;

    return Semantics(
      button: true,
      enabled: !_isDisabled,
      label: widget.text,
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        cursor: _isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: FocusableActionDetector(
            onShowFocusHighlight: _handleFocusChange,
            child: AnimatedBuilder(
              animation: _pressAnimation,
              builder: (context, child) {
                // Scale effect based on press animation
                final scale = 1.0 - ((1.0 - LiquidGlassConstants.pressScale) * _pressAnimation.value);

                return Transform.scale(
                  scale: scale,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Independent Drop Shadow Layer
                      Container(
                        width: widget.width,
                        height: widget.size.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor.withValues(
                                alpha: isDark ? 0.4 : 0.15,
                              ),
                              blurRadius: 16 - (8 * _pressAnimation.value),
                              offset: Offset(0, 8 - (4 * _pressAnimation.value)),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),

                      // 2. RepaintBoundary + Refractive Glass Layer
                      SizedBox(
                        width: widget.width,
                        height: widget.size.height,
                        child: RepaintBoundary(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // 1. Glass Blur Layer
                                BackdropFilter(
                                  filter: ui.ImageFilter.blur(
                                    sigmaX: widget.blurSigma,
                                    sigmaY: widget.blurSigma,
                                  ),
                                  child: const SizedBox.expand(),
                                ),

                                // 2. Tint Layer (Implicitly animated for hover/focus state changes)
                                AnimatedContainer(
                                  duration: LiquidGlassConstants.interactionDuration,
                                  curve: LiquidGlassAnimation.smoothCurve,
                                  decoration: BoxDecoration(color: effectiveColor),
                                ),

                                // 3. Optical Reflections & Specular Highlights (CustomPainter)
                                CustomPaint(
                                  painter: LiquidGlassPainter(
                                    borderRadius: widget.borderRadius,
                                    reflectionColor: reflectionColor,
                                    isDark: isDark,
                                    pressProgress: _pressAnimation.value,
                                  ),
                                ),

                                // 4. Content Layer
                                AnimatedOpacity(
                                  duration: LiquidGlassConstants.interactionDuration,
                                  opacity: _isDisabled && !widget.isLoading ? 0.5 : 1.0,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: widget.size.horizontalPadding,
                                      ),
                                      child: _buildContent(foregroundColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color foregroundColor) {
    return AnimatedSwitcher(
      duration: LiquidGlassConstants.crossfadeDuration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: widget.isLoading
          ? SizedBox(
              key: const ValueKey('loading'),
              width: widget.size.iconSize,
              height: widget.size.iconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
              ),
            )
          : Row(
              key: const ValueKey('content'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: widget.size.iconSize,
                    color: foregroundColor,
                  ),
                  if (widget.text != null) const SizedBox(width: 8),
                ],
                if (widget.text != null)
                  Text(
                    widget.text!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: widget.size.iconSize * 0.8, // Scales roughly with size
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                      letterSpacing: -0.2,
                    ),
                  ),
              ],
            ),
    );
  }
}
