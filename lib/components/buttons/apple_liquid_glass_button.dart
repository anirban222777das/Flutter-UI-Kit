import 'dart:ui' as ui;
import 'package:flutter/material.dart';

enum AppleLiquidGlassMaterial { iosFrosted, visionOsClear }

class AppleLiquidGlassButton extends StatefulWidget {
  const AppleLiquidGlassButton({
    required this.text,
    super.key,
    this.onPressed,
    this.icon,
    this.width,
    this.height = 56,
    this.borderRadius,
    this.material = AppleLiquidGlassMaterial.iosFrosted,
  });

  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final double? borderRadius;
  final AppleLiquidGlassMaterial material;

  @override
  State<AppleLiquidGlassButton> createState() => _AppleLiquidGlassButtonState();
}

class _AppleLiquidGlassButtonState extends State<AppleLiquidGlassButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  
  Offset _pointerOffset = Offset.zero;
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _isDisabled => widget.onPressed == null;
  double get _radius => widget.borderRadius ?? widget.height / 2;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _updatePointer(Offset localPosition, Size size) {
    if (_isDisabled || size.width == 0 || size.height == 0) return;
    
    // Normalize pointer from -1.0 to 1.0
    final dx = ((localPosition.dx / size.width) * 2 - 1).clamp(-1.0, 1.0);
    final dy = ((localPosition.dy / size.height) * 2 - 1).clamp(-1.0, 1.0);
    
    final nextPointer = Offset(dx, dy);

    if ((nextPointer - _pointerOffset).distance > 0.01) {
      setState(() => _pointerOffset = nextPointer);
    }
  }

  void _resetPointer() {
    setState(() {
      _isHovered = false;
      _isPressed = false;
      _pointerOffset = Offset.zero;
    });
    _scaleController.reverse();
  }

  void _handlePointerDown(PointerDownEvent event, Size size) {
    if (_isDisabled) return;
    _updatePointer(event.localPosition, size);
    setState(() => _isPressed = true);
    _scaleController.forward();
  }

  void _handlePointerMove(PointerMoveEvent event, Size size) {
    if (_isPressed || _isHovered) _updatePointer(event.localPosition, size);
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_isDisabled) return;
    setState(() => _isPressed = false);
    _scaleController.reverse();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isVision = widget.material == AppleLiquidGlassMaterial.visionOsClear;

    // Use the exact parameters from liquid_glass_navbar
    final double blurSigma = isVision ? 40.0 : 20.0;
    
    final Color tintColor = isVision
        ? (isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white.withValues(alpha: 0.05))
        : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.25));

    final Color foregroundColor = isDark ? Colors.white : Colors.black87;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = widget.width ?? (constraints.maxWidth.isFinite ? constraints.maxWidth : 240.0);
        final Size size = Size(width, widget.height);

        return MouseRegion(
          cursor: _isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => _resetPointer(),
          onHover: (event) => _updatePointer(event.localPosition, size),
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (e) => _handlePointerDown(e, size),
            onPointerMove: (e) => _handlePointerMove(e, size),
            onPointerUp: _handlePointerUp,
            onPointerCancel: (_) => _resetPointer(),
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                final scale = _scaleAnimation.value;
                final bool isInteracting = _isHovered || _isPressed;
                
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: width,
                    height: widget.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                          blurRadius: isInteracting ? 12 : 24,
                          offset: Offset(0, isInteracting ? 6 : 12),
                        ),
                      ],
                    ),
                    child: RepaintBoundary(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_radius),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // 1. Extreme Blur Backdrop
                            BackdropFilter(
                              filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                              child: Container(
                                color: tintColor,
                              ),
                            ),

                            // 2. Reactive Light Bending (Pointer tracking)
                            if (isInteracting)
                              CustomPaint(
                                painter: _LightBendingPainter(
                                  pointer: _pointerOffset,
                                  isVision: isVision,
                                ),
                              ),

                            // 3. Crisp Rim & Bevel exactly like liquid_glass_navbar
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _GlassBorderPainter(
                                  borderRadius: _radius,
                                  isDark: isDark,
                                ),
                              ),
                            ),

                            // 4. Content
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: foregroundColor.withValues(alpha: _isDisabled ? 0.4 : 1.0),
                                    letterSpacing: -0.3,
                                  ),
                                  child: IconTheme(
                                    data: IconThemeData(
                                      color: foregroundColor.withValues(alpha: _isDisabled ? 0.4 : 1.0),
                                      size: 20,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (widget.icon != null) ...[
                                          Icon(widget.icon),
                                          const SizedBox(width: 8),
                                        ],
                                        Flexible(
                                          child: Text(
                                            widget.text,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// Paints the internal reactive light that bends around your finger
class _LightBendingPainter extends CustomPainter {
  _LightBendingPainter({required this.pointer, required this.isVision});

  final Offset pointer;
  final bool isVision;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    final glowPaint = Paint()
      ..blendMode = BlendMode.screen
      ..shader = ui.Gradient.radial(
        Offset(
          size.width * (0.5 + pointer.dx * 0.4),
          size.height * (0.5 + pointer.dy * 0.4),
        ),
        size.width * 0.8,
        [
          Colors.white.withValues(alpha: isVision ? 0.15 : 0.25),
          Colors.transparent,
        ],
      );
      
    canvas.drawRect(rect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _LightBendingPainter oldDelegate) {
    return oldDelegate.pointer != pointer || oldDelegate.isVision != isVision;
  }
}

/// Exact copy of the highly-praised border painter from liquid_glass_navbar
class _GlassBorderPainter extends CustomPainter {
  _GlassBorderPainter({required this.borderRadius, required this.isDark});

  final double borderRadius;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final insetRRect = rrect.deflate(0.5);

    // Specular Highlight (Top Left)
    final highlightPaint = Paint()
      ..shader = ui.Gradient.linear(
        rect.topLeft,
        rect.bottomRight,
        [
          Colors.white.withValues(alpha: isDark ? 0.3 : 0.8),
          Colors.white.withValues(alpha: 0.0),
          Colors.transparent,
        ],
        [0.0, 0.3, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(insetRRect, highlightPaint);

    // Depth Shadow Bevel (Bottom Right)
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
        [0.0, 0.7, 0.9, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(insetRRect, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant _GlassBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius || oldDelegate.isDark != isDark;
  }
}
