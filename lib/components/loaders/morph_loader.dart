import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A shape-morphing loader that transitions between geometric shapes.
///
/// Smoothly morphs between circle, rounded square, and diamond
/// using animated border radius and rotation. Fully standalone.
///
/// Example:
/// ```dart
/// MorphLoader(
///   size: 48,
///   color: Colors.purple,
/// )
/// ```
class MorphLoader extends StatefulWidget {
  const MorphLoader({
    super.key,
    this.size = 44,
    this.color,
    this.strokeWidth = 3.0,
    this.speed = 1.0,
  });

  /// Overall size of the loader.
  final double size;

  /// Shape color. Defaults to primary.
  final Color? color;

  /// Stroke width.
  final double strokeWidth;

  /// Speed multiplier (1.0 = normal).
  final double speed;

  @override
  State<MorphLoader> createState() => _MorphLoaderState();
}

class _MorphLoaderState extends State<MorphLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (3000 / widget.speed).round(),
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
          // Morph through 3 phases
          final phase = (_controller.value * 3).floor() % 3;
          final phaseProgress = (_controller.value * 3) % 1.0;

          // Smooth easing
          final easedProgress =
              Curves.easeInOutCubic.transform(phaseProgress);

          // Border radius morphing
          double borderRadius;
          double rotation;

          switch (phase) {
            case 0: // Circle → Rounded Square
              borderRadius = widget.size / 2 * (1 - easedProgress * 0.7);
              rotation = easedProgress * math.pi / 4;
            case 1: // Rounded Square → Diamond (rotated square)
              borderRadius = widget.size / 2 * 0.3 * (1 - easedProgress);
              rotation = math.pi / 4 + easedProgress * math.pi / 4;
            default: // Diamond → Circle
              borderRadius = widget.size / 2 * easedProgress;
              rotation = math.pi / 2 + easedProgress * math.pi / 2;
          }

          return Transform.rotate(
            angle: rotation,
            child: Container(
              width: widget.size * 0.7,
              height: widget.size * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius * 0.7),
                border: Border.all(
                  color: color,
                  width: widget.strokeWidth,
                ),
                color: color.withValues(alpha: 0.06),
              ),
            ),
          );
        },
      ),
    );
  }
}
