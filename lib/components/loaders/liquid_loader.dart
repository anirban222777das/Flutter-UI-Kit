import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A liquid-like animated loader with morphing blob effect.
///
/// Uses CustomPainter with animated radius offsets to create
/// an organic, fluid loading indicator. Fully standalone.
///
/// Example:
/// ```dart
/// LiquidLoader(
///   size: 60,
///   color: Colors.indigo,
/// )
/// ```
class LiquidLoader extends StatefulWidget {
  const LiquidLoader({
    super.key,
    this.size = 48,
    this.color,
    this.speed = 1.0,
    this.strokeWidth = 3.0,
  });

  /// Overall size of the loader.
  final double size;

  /// Primary color. Defaults to indigo.
  final Color? color;

  /// Speed multiplier (1.0 = normal).
  final double speed;

  /// Stroke width for the blob outline.
  final double strokeWidth;

  @override
  State<LiquidLoader> createState() => _LiquidLoaderState();
}

class _LiquidLoaderState extends State<LiquidLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (2000 / widget.speed).round(),
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _LiquidPainter(
              progress: _controller.value,
              color: color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  _LiquidPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2 - strokeWidth;
    final angle = progress * 2 * math.pi;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    final path = Path();
    const segments = 60;

    for (var i = 0; i <= segments; i++) {
      final t = i / segments;
      final segAngle = t * 2 * math.pi;

      // Create organic distortion
      final distortion = baseRadius *
          0.12 *
          (math.sin(segAngle * 3 + angle * 2) +
              math.sin(segAngle * 2 - angle * 1.5) * 0.6);
      final r = baseRadius + distortion;

      final x = center.dx + r * math.cos(segAngle);
      final y = center.dy + r * math.sin(segAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LiquidPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
