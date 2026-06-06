import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// A production-ready loader that simulates a bouncing, squishy drop of liquid glass.
///
/// Features intense "squash and stretch" physics, true optical refraction,
/// and pristine glassmorphism highlights. Uses an isolated [RepaintBoundary]
/// to ensure stable 60/120fps performance during continuous animation.
class SquishLiquidGlassLoader extends StatefulWidget {
  const SquishLiquidGlassLoader({
    super.key,
    this.size = 64.0,
    this.baseColor = const Color(0xFF3B82F6), // vibrant blue
    this.duration = const Duration(milliseconds: 1400),
    this.bounceHeight = 80.0,
    this.blur = 16.0,
  });

  /// The resting diameter of the glass droplet.
  final double size;

  /// The primary tint of the glass and background ambient light.
  final Color baseColor;

  /// Duration of one complete bounce cycle.
  final Duration duration;

  /// How high the droplet bounces.
  final double bounceHeight;

  /// The intensity of the optical glass refraction.
  final double blur;

  @override
  State<SquishLiquidGlassLoader> createState() =>
      _SquishLiquidGlassLoaderState();
}

class _SquishLiquidGlassLoaderState extends State<SquishLiquidGlassLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _translateY;
  late final Animation<double> _scaleX;
  late final Animation<double> _scaleY;
  late final Animation<double> _shadowScale;
  late final Animation<double> _shadowOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    // The bounce path: Starts high, falls, and bounces back up
    // Total weight: 100
    // Phase 1: Fall (0 -> 40)
    // Phase 2: Squish on floor (40 -> 55)
    // Phase 3: Rise (55 -> 100)
    _translateY = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: -widget.bounceHeight, end: widget.size * 0.3)
              .chain(CurveTween(curve: Curves.easeInCubic)),
          weight: 40),
      TweenSequenceItem(
          tween: ConstantTween<double>(widget.size * 0.3), weight: 15),
      TweenSequenceItem(
          tween: Tween<double>(begin: widget.size * 0.3, end: -widget.bounceHeight)
              .chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 45),
    ]).animate(_controller);

    // Squash and stretch X (Width)
    _scaleX = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.8)
              .chain(CurveTween(curve: Curves.easeInQuad)),
          weight: 40), // Falling (stretched thin)
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.8, end: 1.5)
              .chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 6), // Rapid squash on impact
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.5, end: 0.9)
              .chain(CurveTween(curve: Curves.easeInCubic)),
          weight: 9), // Spring back (overshoot)
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.9, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)), // Wobble
          weight: 45), // Flying up
    ]).animate(_controller);

    // Squash and stretch Y (Height)
    _scaleY = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.25)
              .chain(CurveTween(curve: Curves.easeInQuad)),
          weight: 40), // Falling (stretched tall)
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.25, end: 0.4)
              .chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 6), // Rapid squash on impact
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.4, end: 1.1)
              .chain(CurveTween(curve: Curves.easeInCubic)),
          weight: 9), // Spring back (overshoot)
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.1, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)), // Wobble
          weight: 45), // Flying up
    ]).animate(_controller);

    // Shadow scales up as the drop gets closer to the floor
    _shadowScale = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.2, end: 0.8)
              .chain(CurveTween(curve: Curves.easeInQuad)),
          weight: 40),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.8, end: 1.5)
              .chain(CurveTween(curve: Curves.easeOutQuad)),
          weight: 7),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.5, end: 0.9)
              .chain(CurveTween(curve: Curves.easeInQuad)),
          weight: 8),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.9, end: 0.2)
              .chain(CurveTween(curve: Curves.easeOutQuad)),
          weight: 45),
    ]).animate(_controller);

    // Shadow opacity intensifies on impact
    _shadowOpacity = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.1, end: 0.3)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 40),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.3, end: 0.6)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 7),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.6, end: 0.4)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 8),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.4, end: 0.1)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 45),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine bounds based on bounce height and scale limits
    final containerHeight = widget.bounceHeight * 2 + widget.size * 1.5;
    final containerWidth = widget.size * 2.5;

    // Use RepaintBoundary to isolate the continuous animation from the rest of the tree
    return RepaintBoundary(
      child: SizedBox(
        width: containerWidth,
        height: containerHeight,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Subtle ambient background glow to enhance glass refraction
                Positioned(
                  top: containerHeight * 0.3,
                  child: Container(
                    width: widget.size * 1.6,
                    height: widget.size * 1.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.baseColor.withValues(alpha: 0.2),
                          widget.baseColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Floor Shadow
                Positioned(
                  bottom: (containerHeight / 2) - widget.size * 0.8,
                  child: Transform.scale(
                    scale: _shadowScale.value,
                    child: Container(
                      width: widget.size * 1.0,
                      height: widget.size * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: _shadowOpacity.value),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: widget.baseColor.withValues(alpha: _shadowOpacity.value * 1.5),
                            blurRadius: 16,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // The Bouncing Glass Droplet
                Transform.translate(
                  offset: Offset(0, _translateY.value),
                  child: Transform.scale(
                    scaleX: _scaleX.value,
                    scaleY: _scaleY.value,
                    alignment: Alignment.bottomCenter,
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
                        child: Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.7),
                                widget.baseColor.withValues(alpha: 0.08),
                                widget.baseColor.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.4),
                              ],
                              stops: const [0.0, 0.4, 0.8, 1.0],
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Primary Specular Highlight (Top Lens Flare)
                              Positioned(
                                top: widget.size * 0.08,
                                left: widget.size * 0.15,
                                child: Container(
                                  width: widget.size * 0.5,
                                  height: widget.size * 0.25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.9),
                                        Colors.white.withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Secondary Inner Reflection (Bottom Rim)
                              Positioned(
                                bottom: widget.size * 0.05,
                                right: widget.size * 0.1,
                                child: Transform.rotate(
                                  angle: -math.pi / 8,
                                  child: Container(
                                    width: widget.size * 0.6,
                                    height: widget.size * 0.15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.white.withValues(alpha: 0.6),
                                          Colors.white.withValues(alpha: 0.0),
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
