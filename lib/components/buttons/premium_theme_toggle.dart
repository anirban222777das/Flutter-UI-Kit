import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A premium animated theme toggle switch featuring true optical liquid glass.
///
/// Features a recessed track and a physically larger glass bubble (lens) that slides
/// over the track, blurring the content underneath and catching light with specular highlights.
///
/// Example:
/// ```dart
/// PremiumThemeToggle(
///   isDark: _isDark,
///   onChanged: (val) => setState(() => _isDark = val),
/// )
/// ```
class PremiumThemeToggle extends StatelessWidget {
  const PremiumThemeToggle({
    required this.isDark,
    required this.onChanged,
    super.key,
    this.width = 140,
    this.trackHeight = 44,
    this.thumbSize = 64,
  });

  /// Current theme state. True for Dark mode, false for Light mode.
  final bool isDark;

  /// Callback when the toggle is tapped.
  final ValueChanged<bool> onChanged;

  /// Total width of the toggle component.
  final double width;

  /// Height of the recessed pill track.
  final double trackHeight;

  /// Diameter of the glass bubble thumb (should be larger than trackHeight to overlap).
  final double thumbSize;

  @override
  Widget build(BuildContext context) {
    // We base the colors heavily on the provided premium design reference
    final trackColor = isDark ? const Color(0xFF222429) : const Color(0xFFDDE3EA);
    final textColor = isDark ? Colors.white54 : Colors.black54;

    // Track inner shadow simulation
    final trackInnerShadowDark = isDark ? Colors.black.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.15);
    final trackInnerHighlight = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.8);

    // Provide padding so the larger thumb doesn't get clipped
    final horizontalPadding = (thumbSize - trackHeight) / 2;

    return GestureDetector(
      onTap: () => onChanged(!isDark),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width + (horizontalPadding * 2),
        height: thumbSize, // The total height is dictated by the large thumb
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Recessed Pill Track
            Container(
              width: width,
              height: trackHeight,
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: BorderRadius.circular(trackHeight / 2),
                // Inner shadow effect via borders and box shadows
                border: Border(
                  top: BorderSide(color: trackInnerShadowDark, width: 2),
                  bottom: BorderSide(color: trackInnerHighlight, width: 1),
                  left: BorderSide(color: trackInnerShadowDark, width: 1.5),
                  right: BorderSide(color: trackInnerShadowDark, width: 1.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Text Labels placed rigidly in the track
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dark',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Light',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Liquid Glass Bubble Thumb
            // We use AnimatedAlign to smoothly slide the thumb across the track
            AnimatedAlign(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack, // Gives a slight spring physical effect
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: SizedBox(
                width: thumbSize,
                height: thumbSize,
                // RepaintBoundary isolates the expensive blur from layout updates
                child: RepaintBoundary(
                  child: Stack(
                    children: [
                      // Drop shadow of the glass bubble (cast onto the background)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      
                      // Refractive Glass Lens
                      ClipOval(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Base optical tint of the glass
                              color: isDark 
                                ? Colors.white.withValues(alpha: 0.08) 
                                : Colors.white.withValues(alpha: 0.4),
                            ),
                            // Specular highlights and edge lighting
                            child: CustomPaint(
                              painter: _GlassBubblePainter(isDark: isDark),
                              child: Center(
                                // Animated glowing icon inside the glass
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) => ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                  child: isDark
                                      ? Icon(
                                          Icons.nightlight_round,
                                          key: const ValueKey('dark_icon'),
                                          color: Colors.white,
                                          size: thumbSize * 0.45,
                                          shadows: [
                                            Shadow(
                                              color: Colors.white.withValues(alpha: 0.8),
                                              blurRadius: 12,
                                            )
                                          ],
                                        )
                                      : Icon(
                                          Icons.wb_sunny_rounded,
                                          key: const ValueKey('light_icon'),
                                          color: Colors.white,
                                          size: thumbSize * 0.45,
                                          shadows: [
                                            Shadow(
                                              color: Colors.white.withValues(alpha: 0.8),
                                              blurRadius: 12,
                                            )
                                          ],
                                        ),
                                ),
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
          ],
        ),
      ),
    );
  }
}

/// Renders the complex physical specular highlights and shadows of the glass bubble.
class _GlassBubblePainter extends CustomPainter {
  _GlassBubblePainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Inner dark shadow (creates physical thickness)
    final darkShadowPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          Colors.transparent,
          Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
          Colors.black.withValues(alpha: isDark ? 0.8 : 0.2),
        ],
        [0.7, 0.9, 1.0],
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, darkShadowPaint);

    // 2. Crisp specular highlight on the top-left edge
    // This creates the illusion of a polished optical surface catching the light
    final highlightPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(size.width * 0.6, size.height * 0.6),
        [
          Colors.white.withValues(alpha: isDark ? 0.6 : 0.9),
          Colors.white.withValues(alpha: 0.0),
        ],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 0.75, highlightPaint);

    // 3. Diagonal soft gloss passing over the surface
    final glossPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width * 0.2, 0),
        Offset(size.width, size.height * 0.8),
        [
          Colors.white.withValues(alpha: isDark ? 0.1 : 0.4),
          Colors.transparent,
        ],
      )
      ..style = PaintingStyle.fill;
    
    // Draw gloss only on the top half using an arc path for realism
    final path = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(center.dx - size.width * 0.1, center.dy - size.height * 0.1),
        radius: radius * 0.85,
      ));
    
    canvas.save();
    canvas.clipPath(path);
    canvas.drawCircle(center, radius, glossPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GlassBubblePainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
