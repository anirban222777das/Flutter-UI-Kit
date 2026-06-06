import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An orbit loader with dots rotating around a center point.
///
/// Displays configurable number of dots orbiting smoothly
/// with trailing opacity effect. Fully standalone.
///
/// Example:
/// ```dart
/// OrbitLoader(
///   orbitRadius: 20,
///   dotCount: 5,
///   color: Colors.cyan,
/// )
/// ```
class OrbitLoader extends StatefulWidget {
  const OrbitLoader({
    super.key,
    this.orbitRadius = 18,
    this.dotCount = 4,
    this.dotSize = 6,
    this.color,
    this.speed = 1.0,
    this.size = 48,
  });

  /// Radius of the orbital path.
  final double orbitRadius;

  /// Number of orbiting dots.
  final int dotCount;

  /// Size of each dot.
  final double dotSize;

  /// Dot color. Defaults to primary.
  final Color? color;

  /// Speed multiplier (1.0 = normal).
  final double speed;

  /// Overall widget size.
  final double size;

  @override
  State<OrbitLoader> createState() => _OrbitLoaderState();
}

class _OrbitLoaderState extends State<OrbitLoader>
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
            painter: _OrbitPainter(
              progress: _controller.value,
              color: color,
              dotCount: widget.dotCount,
              dotSize: widget.dotSize,
              orbitRadius: widget.orbitRadius,
            ),
          );
        },
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({
    required this.progress,
    required this.color,
    required this.dotCount,
    required this.dotSize,
    required this.orbitRadius,
  });

  final double progress;
  final Color color;
  final int dotCount;
  final double dotSize;
  final double orbitRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseAngle = progress * 2 * math.pi;

    for (var i = 0; i < dotCount; i++) {
      final angle = baseAngle + (i / dotCount) * 2 * math.pi;
      final opacity = 1.0 - (i / dotCount) * 0.7;
      final currentDotSize = dotSize * (1.0 - (i / dotCount) * 0.4);

      final x = center.dx + orbitRadius * math.cos(angle);
      final y = center.dy + orbitRadius * math.sin(angle);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        currentDotSize / 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
