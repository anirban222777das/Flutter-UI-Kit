import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ─────────────────────────────────────────────
//  Data model
// ─────────────────────────────────────────────

class ChromaticRippleNavBarItem {
  final IconData icon;
  final String label;
  const ChromaticRippleNavBarItem({required this.icon, required this.label});
}

// ─────────────────────────────────────────────
//  SPRING SIMULATION
//  Apple-tuned critically damped springs.
// ─────────────────────────────────────────────

class _Spring {
  double value;
  double velocity = 0;
  final double stiffness;
  final double damping;

  _Spring({
    required this.value,
    this.stiffness = 380, // Snappy but smooth
    this.damping = 26, // Prevents excessive oscillation
  });

  void tick(double target, double dt) {
    final force = -stiffness * (value - target) - damping * velocity;
    velocity += force * dt;
    value += velocity * dt;
  }
}

// ─────────────────────────────────────────────
//  CHROMATIC RIPPLE NAV BAR
//
//  Ultra-premium Apple Music-style glass tab bar:
//  • Hardware-accelerated rendering (no MaskFilters)
//  • Buttery 120fps performance
//  • Clean elastic stretch (no messy trailing blobs)
//  • Authentic Apple frosted glass overlay blend
// ─────────────────────────────────────────────

class ChromaticRippleNavBar extends StatefulWidget {
  final List<ChromaticRippleNavBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final double height;

  const ChromaticRippleNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.height = 76,
  });

  @override
  State<ChromaticRippleNavBar> createState() => _ChromaticRippleNavBarState();
}

class _ChromaticRippleNavBarState extends State<ChromaticRippleNavBar>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _prev = Duration.zero;

  // Notifier to surgically rebuild only the moving pill
  final _animationNotifier = _TickNotifier();

  // Spring state
  late _Spring _pillX;
  late _Spring _pillRx;
  late _Spring _pillRy;
  late _Spring _wobble;

  double _pressSquish = 0;

  static const double _pillNaturalR = 30;
  static const double _pillMaxStretch = 16;

  double _barWidth = 0;

  double get _barH => widget.height;

  double _centreXForIndex(int i) {
    if (_barWidth == 0 || widget.items.isEmpty) return 0;
    final slot = _barWidth / widget.items.length;
    return slot * i + slot / 2;
  }

  @override
  void initState() {
    super.initState();
    final startX = _centreXForIndex(widget.selectedIndex);

    // Tuned for Apple's signature fluid interaction
    _pillX = _Spring(value: startX, stiffness: 320, damping: 28);
    _pillRx = _Spring(value: _pillNaturalR, stiffness: 260, damping: 22);
    _pillRy = _Spring(value: _pillNaturalR, stiffness: 260, damping: 22);
    _wobble = _Spring(value: 0, stiffness: 180, damping: 14);

    _ticker = createTicker(_tick)..start();
  }

  @override
  void didUpdateWidget(ChromaticRippleNavBar old) {
    super.didUpdateWidget(old);
    if (old.selectedIndex != widget.selectedIndex) {
      _wobble
        ..value = 0
        ..velocity = 280;
      _pillRx.velocity += 180;
    }
  }

  void _tick(Duration elapsed) {
    if (_prev == Duration.zero) {
      _prev = elapsed;
      return;
    }
    final dt = ((elapsed - _prev).inMicroseconds / 1e6).clamp(0.0, 0.05);
    _prev = elapsed;

    final targetX = _centreXForIndex(widget.selectedIndex);
    final speed = _pillX.velocity.abs();
    
    // Elastic stretch based on movement speed
    final stretchBonus =
        (speed / 800 * _pillMaxStretch).clamp(0.0, _pillMaxStretch);

    final rxTarget = _pillNaturalR + stretchBonus;
    final squishFromStretch = (stretchBonus / _pillMaxStretch) * 4;
    final pressRyDelta = _pressSquish * 6;
    final ryTarget = _pillNaturalR - squishFromStretch - pressRyDelta;
    final pressRxBonus = _pressSquish * 5;

    _pillX.tick(targetX, dt);
    _pillRx.tick(rxTarget + pressRxBonus, dt);
    _pillRy.tick(ryTarget, dt);
    _wobble.tick(0, dt);

    if (mounted) _animationNotifier.notify();
  }

  void _onPressDown(Offset local) {
    _pressSquish = 1.0;
    _pillRy.velocity -= 120;
    _wobble.velocity += 150;
  }

  void _onPressUp(Offset local, int index) {
    _pressSquish = 0.0;
    _pillRy.velocity += 100;
    widget.onItemSelected(index);
  }

  void _onPressCancel() {
    _pressSquish = 0.0;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(builder: (ctx, box) {
      if (_barWidth != box.maxWidth) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _barWidth = box.maxWidth;
              _pillX.value = _centreXForIndex(widget.selectedIndex);
            });
          }
        });
        _barWidth = box.maxWidth;
      }

      return SizedBox(
        height: _barH,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Glass track background ───────────
            _GlassTrack(height: _barH, isDark: isDark),

            // ── Premium Gel Blob Overlay ─────────
            // Wrapped in AnimatedBuilder and RepaintBoundary so we never
            // rebuild the expensive BackdropFilter track on every frame.
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _animationNotifier,
                builder: (context, _) {
                  return Positioned.fill(
                    child: CustomPaint(
                      painter: _GelBlobPainter(
                        pillCx: _pillX.value,
                        pillRx: _pillRx.value,
                        pillRy: _pillRy.value,
                        wobble: _wobble.value,
                        barH: _barH,
                        isDark: isDark,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Nav icons row ───────────────────
            Row(
              children: List.generate(widget.items.length, (i) {
                return _NavItemWidget(
                  item: widget.items[i],
                  isSelected: widget.selectedIndex == i,
                  isDark: isDark,
                  width: _barWidth / widget.items.length,
                  height: _barH,
                  onPressDown: _onPressDown,
                  onPressUp: (local) => _onPressUp(local, i),
                  onCancel: _onPressCancel,
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
//  GEL BLOB PAINTER
//  Optimized for 120fps: No MaskFilters. Uses 
//  hardware shadows and clean gradient falloffs.
// ─────────────────────────────────────────────
class _GelBlobPainter extends CustomPainter {
  final double pillCx, pillRx, pillRy;
  final double wobble;
  final double barH;
  final bool isDark;

  const _GelBlobPainter({
    required this.pillCx,
    required this.pillRx,
    required this.pillRy,
    required this.wobble,
    required this.barH,
    required this.isDark,
  });

  Path _blobPath(double cx, double rx, double ry, double wob) {
    final cy = barH / 2;
    final wobTop = wob.clamp(-12.0, 12.0);
    final wobBot = -wobTop * 0.6;

    const k = 0.5522847498; // Circle approx

    return Path()
      ..moveTo(cx, cy - ry + wobTop * 0.2)
      ..cubicTo(
        cx + rx * k, cy - ry + wobTop * 0.2,
        cx + rx, cy - ry * k + wobBot * 0.15,
        cx + rx, cy,
      )
      ..cubicTo(
        cx + rx, cy + ry * k + wobTop * 0.15,
        cx + rx * k, cy + ry + wobBot * 0.2,
        cx, cy + ry + wobBot * 0.2,
      )
      ..cubicTo(
        cx - rx * k, cy + ry + wobBot * 0.2,
        cx - rx, cy + ry * k + wobTop * 0.15,
        cx - rx, cy,
      )
      ..cubicTo(
        cx - rx, cy - ry * k + wobBot * 0.15,
        cx - rx * k, cy - ry + wobTop * 0.2,
        cx, cy - ry + wobTop * 0.2,
      )
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (pillRx < 1) return;

    final cy = barH / 2;
    final path = _blobPath(pillCx, pillRx, pillRy, wobble);
    final pillRect = Rect.fromCenter(
      center: Offset(pillCx, cy),
      width: pillRx * 2 + 2,
      height: pillRy * 2 + 2,
    );

    // ── Hardware-accelerated Drop Shadow ───
    canvas.drawShadow(
      path,
      Colors.black.withValues(alpha: 0.25),
      isDark ? 2.5 : 1.5,
      true, // transparent occluder
    );

    canvas.save();
    canvas.clipPath(path);

    // ── Base Fill ──────────────────────────
    // Authentic Apple glass is incredibly subtle.
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [
                Colors.white.withValues(alpha: 0.12),
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.03),
                Colors.white.withValues(alpha: 0.08),
              ]
            : [
                Colors.white.withValues(alpha: 0.65),
                Colors.white.withValues(alpha: 0.40),
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.50),
              ],
        stops: const [0.0, 0.35, 0.65, 1.0],
      ).createShader(pillRect);
    canvas.drawPath(path, fillPaint);

    // ── Specular Highlight (Lens flare) ────
    // Using a simple RadialGradient is much faster than MaskFilter.
    final specPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.6),
        radius: 1.0,
        colors: [
          Colors.white.withValues(alpha: isDark ? 0.15 : 0.40),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(pillRect);
    canvas.drawPath(path, specPaint);

    canvas.restore();

    // ── Ultra-crisp Rim Light ──────────────
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isDark ? 0.6 : 1.0
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: isDark ? 0.45 : 0.90),
          Colors.white.withValues(alpha: isDark ? 0.10 : 0.25),
          Colors.white.withValues(alpha: isDark ? 0.05 : 0.12),
          Colors.white.withValues(alpha: isDark ? 0.20 : 0.45),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(pillRect);
    canvas.drawPath(path, rimPaint);
  }

  @override
  bool shouldRepaint(_GelBlobPainter old) => true;
}

// ─────────────────────────────────────────────
//  GLASS TRACK BACKGROUND
// ─────────────────────────────────────────────
class _GlassTrack extends StatelessWidget {
  final double height;
  final bool isDark;
  const _GlassTrack({required this.height, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45), // Extreme Apple blur
        child: CustomPaint(
          painter: _GlassTrackPainter(height: height, isDark: isDark),
          child: SizedBox(height: height, width: double.infinity),
        ),
      ),
    );
  }
}

class _GlassTrackPainter extends CustomPainter {
  final double height;
  final bool isDark;
  const _GlassTrackPainter({required this.height, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = height / 2;
    final rr = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Very transparent base tint
    canvas.drawRRect(
      rr,
      Paint()
        ..color = isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.white.withValues(alpha: 0.10),
    );

    // Track rim light
    canvas.drawRRect(
      rr.deflate(0.4),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: isDark ? 0.35 : 0.75),
            Colors.white.withValues(alpha: isDark ? 0.08 : 0.15),
            Colors.white.withValues(alpha: isDark ? 0.04 : 0.08),
            Colors.white.withValues(alpha: isDark ? 0.15 : 0.35),
          ],
          stops: const [0.0, 0.35, 0.65, 1.0],
        ).createShader(rect),
    );

    // Depth bevel
    canvas.drawRRect(
      rr.deflate(0.4),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Colors.black.withValues(alpha: isDark ? 0.08 : 0.03),
            Colors.black.withValues(alpha: isDark ? 0.15 : 0.06),
          ],
          stops: const [0.0, 0.6, 0.85, 1.0],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_GlassTrackPainter old) => old.isDark != isDark;
}

// ─────────────────────────────────────────────
//  Individual nav item
// ─────────────────────────────────────────────
class _NavItemWidget extends StatelessWidget {
  final ChromaticRippleNavBarItem item;
  final bool isSelected;
  final bool isDark;
  final double width;
  final double height;
  final void Function(Offset) onPressDown;
  final void Function(Offset) onPressUp;
  final VoidCallback onCancel;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.width,
    required this.height,
    required this.onPressDown,
    required this.onPressUp,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? Colors.white : Colors.black87;
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.42)
        : Colors.black.withValues(alpha: 0.42);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (d) => onPressDown(d.localPosition),
      onTapUp: (d) => onPressUp(d.localPosition),
      onTapCancel: onCancel,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutCubic,
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: Icon(
                item.icon,
                key: ValueKey('${item.label}_$isSelected'),
                size: isSelected ? 24 : 22,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.1,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TICKER NOTIFIER
// ─────────────────────────────────────────────
class _TickNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

