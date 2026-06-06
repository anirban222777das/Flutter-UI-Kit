import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Represents a single item in the LiquidGlassNavBar.
class LiquidNavBarItem {
  const LiquidNavBarItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

/// A highly polished, visionOS/iOS inspired floating navigation bar.
///
/// Features true optical refraction (BackdropFilter), a sliding bouncy
/// glass bubble that indicates the active tab, and smooth scale animations
/// when tapping items.
///
/// Example:
/// ```dart
/// LiquidGlassNavBar(
///   selectedIndex: _currentIndex,
///   onItemSelected: (index) => setState(() => _currentIndex = index),
///   items: const [
///     LiquidNavBarItem(icon: Icons.home_rounded, label: 'Home'),
///     LiquidNavBarItem(icon: Icons.analytics_rounded, label: 'Analytics'),
///     LiquidNavBarItem(icon: Icons.person_rounded, label: 'Account'),
///   ],
/// )
/// ```
class LiquidGlassNavBar extends StatefulWidget {
  const LiquidGlassNavBar({
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.height = 72.0,
    this.horizontalPadding = 8.0,
    super.key,
  }) : assert(items.length >= 2, 'Must provide at least 2 items');

  final List<LiquidNavBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final double height;
  final double horizontalPadding;

  @override
  State<LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<LiquidGlassNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

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

  void _handlePointerDown(PointerDownEvent event) {
    _scaleController.forward();
  }

  void _handlePointerUp(PointerUpEvent event) {
    _scaleController.reverse();
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Proper Apple Clear Glass: Almost zero opacity, relies entirely on heavy blur and borders
    final trackColor = isDark
        ? Colors.white.withValues(alpha: 0.02)
        : Colors.white.withValues(alpha: 0.05);

    // Bubble needs to be slightly visible but still clear
    final bubbleColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.2);

    // Physics constants for the jelly effect
    const animationDuration = Duration(milliseconds: 600);
    const animationCurve = ElasticOutCurve(0.85); // Jelly bounce

    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          final scale = _scaleAnimation.value;
          final isInteracting = scale < 1.0;
          
          return Transform.scale(
            scale: scale,
            child: Container(
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height / 2),
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
                  borderRadius: BorderRadius.circular(widget.height / 2),
                  child: Stack(
                    children: [
                      // 1. Refractive Track Backdrop (Extreme blur for clear glass)
                      BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                        child: Container(
                          color: trackColor,
                        ),
                      ),

                      // 2. Track Highlight Edge
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _GlassBorderPainter(
                            borderRadius: widget.height / 2,
                            isDark: isDark,
                          ),
                        ),
                      ),

                      // 3. Sliding Bouncy Bubble & Items
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Responsive widths: Active item is 2x wider than inactive items
                            final totalFlex = (widget.items.length - 1) * 1.0 + 2.0;
                            final flexUnit = constraints.maxWidth / totalFlex;
                            
                            final activeWidth = flexUnit * 2.0;
                            final inactiveWidth = flexUnit * 1.0;
                            
                            // Calculate target left position for the bubble
                            final bubbleLeft = widget.selectedIndex * inactiveWidth;

                            return Stack(
                              children: [
                                // The animated jelly bubble
                                AnimatedPositioned(
                                  duration: animationDuration,
                                  curve: animationCurve,
                                  left: bubbleLeft,
                                  top: 8,
                                  bottom: 8,
                                  width: activeWidth,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(widget.height / 2),
                                      color: bubbleColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: isInteracting ? 0.04 : 0.02,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: isInteracting ? 0.4 : 0.2,
                                        ),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                ),

                                // The tappable icon items
                                Row(
                                  children: List.generate(widget.items.length, (index) {
                                    final isSelected = index == widget.selectedIndex;
                                    final item = widget.items[index];
                                    final targetWidth = isSelected ? activeWidth : inactiveWidth;

                                    return AnimatedContainer(
                                      duration: animationDuration,
                                      curve: animationCurve,
                                      width: targetWidth,
                                      child: _NavBarItemWidget(
                                        item: item,
                                        isSelected: isSelected,
                                        isDark: isDark,
                                        onTap: () => widget.onItemSelected(index),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            );
                          },
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
    );
  }
}

class _NavBarItemWidget extends StatelessWidget {
  const _NavBarItemWidget({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final LiquidNavBarItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? Colors.white : Colors.black87;
    final inactiveColor = isDark 
        ? Colors.white.withValues(alpha: 0.5) 
        : Colors.black.withValues(alpha: 0.4);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent, // Changed to translucent to catch taps reliably
        onTap: onTap,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            style: TextStyle(
              fontFamily: 'Inter',
              // Use a slight scale down rather than exactly 0 for better fluid bounds
              fontSize: isSelected ? 13 : 0.1, 
              fontWeight: FontWeight.w600,
              color: isSelected ? activeColor : inactiveColor.withValues(alpha: 0.0),
              height: 1.2,
            ),
            child: AnimatedTheme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(
                  color: isSelected ? activeColor : inactiveColor,
                  size: isSelected ? 24 : 22,
                ),
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon),
                    // Only render space if selected to avoid layout jumps
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      height: isSelected ? 4 : 0,
                    ),
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints the frosted glass specular highlight on the top left,
/// and a soft shadow bevel on the bottom right.
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
