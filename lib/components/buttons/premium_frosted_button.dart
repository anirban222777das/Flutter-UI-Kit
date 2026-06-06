import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A premium frosted glass button that authentically bends light and reacts
/// with the background. Built to match modern web glassmorphism trends.
///
/// Features a refractive backdrop, dynamic edge lighting (brighter at top-left),
/// and supports an optional dark action circle (e.g., for a 'Get Started' chevron).
///
/// Example:
/// ```dart
/// PremiumFrostedButton(
///   text: 'Get started',
///   actionIcon: Icons.chevron_right_rounded,
///   onPressed: () {},
/// )
/// ```
class PremiumFrostedButton extends StatefulWidget {
  const PremiumFrostedButton({
    required this.text,
    this.onPressed,
    this.actionIcon,
    this.width,
    this.height = 64,
    super.key,
  });

  /// The text displayed inside the button.
  final String text;

  /// Callback when the button is tapped.
  final VoidCallback? onPressed;

  /// Optional icon to display inside a dark circular thumb on the right side.
  /// If null, the text is centered.
  final IconData? actionIcon;

  /// Optional fixed width. If null, the button sizes to its content.
  final double? width;

  /// Height of the button. Defaults to 64 for a premium, spacious feel.
  final double height;

  @override
  State<PremiumFrostedButton> createState() => _PremiumFrostedButtonState();
}

class _PremiumFrostedButtonState extends State<PremiumFrostedButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  late final AnimationController _pressController;
  late final Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 300),
    );

    _pressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOutCubic,
        reverseCurve: const ElasticOutCurve(0.8),
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final hasAction = widget.actionIcon != null;
    final borderRadius = widget.height / 2;

    return Semantics(
      button: true,
      enabled: widget.onPressed != null,
      label: widget.text,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.onPressed != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedBuilder(
            animation: _pressAnimation,
            builder: (context, child) {
              // 1. Deeper overall button scale for a physical push feel
              final scale = 1.0 - (0.06 * _pressAnimation.value);

              // 2. Independent, deeper scale for the dark action thumb
              final thumbScale = 1.0 - (0.12 * _pressAnimation.value);
              
              // 3. Slide the icon slightly to the right when pressed
              final iconOffset = Offset(4.0 * _pressAnimation.value, 0);

              return Transform.scale(
                scale: scale,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. Subtle Drop Shadow (placed under the glass to not ruin refraction)
                    Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 16 - (10 * _pressAnimation.value),
                            offset: Offset(0, 8 - (6 * _pressAnimation.value)),
                          ),
                        ],
                      ),
                    ),

                    // 2. Refractive Glass Body
                    SizedBox(
                      width: widget.width,
                      height: widget.height,
                      child: RepaintBoundary(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(borderRadius),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Optical Blur (Bends the background light)
                              BackdropFilter(
                                filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                                child: const SizedBox.expand(),
                              ),

                              // Frosted Tint (White gradient for realism)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(
                                          alpha: _isHovered || _isPressed ? 0.45 : 0.3),
                                      Colors.white.withValues(
                                          alpha: _isHovered || _isPressed ? 0.25 : 0.1),
                                    ],
                                  ),
                                ),
                              ),

                              // Inner compression shadow when pressed
                              Container(
                                color: Colors.black.withValues(
                                  alpha: 0.05 * _pressAnimation.value,
                                ),
                              ),

                              // Specular Edge Highlights (CustomPainter)
                              CustomPaint(
                                painter: _FrostedEdgePainter(
                                  borderRadius: borderRadius,
                                ),
                              ),

                              // Content Layer
                              Padding(
                                padding: EdgeInsets.only(
                                  left: hasAction ? 24.0 : 32.0,
                                  right: hasAction ? 8.0 : 32.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: hasAction
                                      ? MainAxisAlignment.spaceBetween
                                      : MainAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      // Scale the text down very slightly when the button is pressed
                                      // for the variant WITHOUT the action thumb to give it some life
                                      scale: hasAction ? 1.0 : 1.0 - (0.02 * _pressAnimation.value),
                                      child: Text(
                                        widget.text,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2D3748), // Dark slate text
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                    ),
                                    if (hasAction) ...[
                                      const SizedBox(width: 16),
                                      // Dark Circular Action Thumb
                                      Transform.scale(
                                        scale: thumbScale,
                                        child: Container(
                                          width: widget.height - 16,
                                          height: widget.height - 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFF222429), // Premium dark grey
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.2),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Transform.translate(
                                              offset: iconOffset,
                                              child: Icon(
                                                widget.actionIcon,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                  ],
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
    );
  }
}

/// Draws the ultra-crisp specular highlight on the top-left edge
/// and a soft shadow on the bottom-right edge to give the frosted glass
/// physical dimension and bevel.
class _FrostedEdgePainter extends CustomPainter {
  _FrostedEdgePainter({required this.borderRadius});

  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final insetRRect = rrect.deflate(0.5);

    // Top-Left Light Catch (Specular Edge)
    final highlightPaint = Paint()
      ..shader = ui.Gradient.linear(
        rect.topLeft,
        rect.bottomRight,
        [
          Colors.white.withValues(alpha: 0.9),
          Colors.white.withValues(alpha: 0.1),
          Colors.transparent,
        ],
        [0.0, 0.4, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(insetRRect, highlightPaint);

    // Bottom-Right Soft Dark Edge (Bevel Depth)
    final shadowPaint = Paint()
      ..shader = ui.Gradient.linear(
        rect.topLeft,
        rect.bottomRight,
        [
          Colors.transparent,
          Colors.transparent,
          Colors.black.withValues(alpha: 0.05),
          Colors.black.withValues(alpha: 0.15),
        ],
        [0.0, 0.6, 0.8, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(insetRRect, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant _FrostedEdgePainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius;
  }
}
