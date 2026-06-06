import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'liquid_glass_button_constants.dart';

/// A CustomPainter that renders realistic glass reflections, edge lighting,
/// and subtle internal diffusion without relying on heavy widget trees.
class LiquidGlassPainter extends CustomPainter {
  LiquidGlassPainter({
    required this.borderRadius,
    required this.reflectionColor,
    required this.isDark,
    required this.pressProgress,
  });

  final double borderRadius;
  final Color reflectionColor;
  final bool isDark;
  
  /// A value from 0.0 to 1.0 representing how far the button is pressed down.
  final double pressProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Calculate dynamic opacities based on press state
    // When pressed, reflections slightly dim to simulate physical compression
    final dynamicMaxOpacity = LiquidGlassConstants.reflectionMaxOpacity * (1.0 - (pressProgress * 0.3));
    final dynamicGlossOpacity = LiquidGlassConstants.glossOpacity * (1.0 - (pressProgress * 0.5));

    _drawInnerThickness(canvas, rrect, size);
    _drawTopEdgeHighlight(canvas, rrect, size, dynamicMaxOpacity);
    _drawDiagonalGloss(canvas, rect, rrect, size, dynamicGlossOpacity);
  }

  /// 1. Inner dark shadow (creates physical thickness)
  void _drawInnerThickness(Canvas canvas, RRect rrect, Size size) {
    final darkShadowPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, size.height * 0.3),
        Offset(0, size.height),
        [
          Colors.transparent,
          Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
          Colors.black.withValues(alpha: isDark ? 0.6 : 0.15),
        ],
      )
      ..style = PaintingStyle.fill;
      
    // Draw the thickness shadow but clip to the rounded rect
    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRect(Offset.zero & size, darkShadowPaint);
    canvas.restore();
  }

  /// 2. Crisp specular highlight on the top-left edge
  void _drawTopEdgeHighlight(Canvas canvas, RRect rrect, Size size, double maxOpacity) {
    final highlightPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(size.width * 0.5, size.height * 0.5),
        [
          reflectionColor.withValues(alpha: isDark ? 0.6 : 0.9),
          reflectionColor.withValues(alpha: 0.0),
        ],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // We draw an inset rrect so the stroke is perfectly inside the bounds
    final insetRRect = rrect.deflate(0.75);
    canvas.drawRRect(insetRRect, highlightPaint);
  }

  /// 3. Diagonal soft gloss passing over the top half of the surface
  void _drawDiagonalGloss(Canvas canvas, Rect rect, RRect rrect, Size size, double glossOpacity) {
    final glossPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width * 0.1, 0),
        Offset(size.width * 0.9, size.height * 0.8),
        [
          reflectionColor.withValues(alpha: isDark ? 0.15 : 0.4),
          Colors.transparent,
        ],
      )
      ..style = PaintingStyle.fill;
    
    // Draw gloss only on the top half using an arc/curve path for realism
    final path = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * -0.2),
        width: size.width * 1.5,
        height: size.height * 1.5,
      ));
    
    canvas.save();
    canvas.clipRRect(rrect);
    canvas.clipPath(path);
    canvas.drawRect(rect, glossPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LiquidGlassPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.reflectionColor != reflectionColor ||
        oldDelegate.isDark != isDark ||
        oldDelegate.pressProgress != pressProgress;
  }
}
