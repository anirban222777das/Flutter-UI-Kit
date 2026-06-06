import 'package:flutter/material.dart';

/// A pulsing dot loader with staggered concentric animations.
///
/// Displays a row of dots that pulse in sequence with
/// configurable count, color, and timing. Fully standalone.
///
/// Example:
/// ```dart
/// PulseLoader(
///   dotCount: 3,
///   color: Colors.indigo,
///   size: 48,
/// )
/// ```
class PulseLoader extends StatefulWidget {
  const PulseLoader({
    super.key,
    this.dotCount = 3,
    this.color,
    this.size = 48,
    this.dotSize = 10,
    this.spacing = 8,
    this.speed = 1.0,
  });

  /// Number of pulsing dots.
  final int dotCount;

  /// Dot color. Defaults to primary.
  final Color? color;

  /// Overall widget size constraint.
  final double size;

  /// Individual dot diameter.
  final double dotSize;

  /// Spacing between dots.
  final double spacing;

  /// Speed multiplier (1.0 = normal).
  final double speed;

  @override
  State<PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<PulseLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (1400 / widget.speed).round(),
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
      height: widget.size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.dotCount, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final delay = index / widget.dotCount;
              final value =
                  ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);

              // Pulse curve: scale up then down
              final scale = value < 0.5
                  ? 1.0 + (value * 2) * 0.5
                  : 1.0 + ((1.0 - value) * 2) * 0.5;
              final opacity = value < 0.5
                  ? 0.4 + (value * 2) * 0.6
                  : 0.4 + ((1.0 - value) * 2) * 0.6;

              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: widget.spacing / 2,
                ),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: widget.dotSize,
                    height: widget.dotSize,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: opacity),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
