import 'package:flutter/material.dart';

class GlowIndicatorNavBarItem {
  final IconData icon;
  final String label;

  const GlowIndicatorNavBarItem({
    required this.icon,
    required this.label,
  });
}

class GlowIndicatorNavBar extends StatefulWidget {
  final int selectedIndex;
  final List<GlowIndicatorNavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final Color glowColor;
  final double height;
  
  const GlowIndicatorNavBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
    this.glowColor = const Color(0xFF6366F1), // Indigo/Purple neon default
    this.height = 76.0,
  });

  @override
  State<GlowIndicatorNavBar> createState() => _GlowIndicatorNavBarState();
}

class _GlowIndicatorNavBarState extends State<GlowIndicatorNavBar> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bgColor = isDark ? const Color(0xFF111111) : Colors.white;
    final inactiveColor = isDark ? Colors.white54 : Colors.black54;
    final activeColor = isDark ? Colors.white : Colors.black87;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / widget.items.length;
          
          return Stack(
            children: [
              // Sliding Glow Indicator at Top
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                top: 0,
                left: widget.selectedIndex * itemWidth,
                width: itemWidth,
                height: widget.height,
                child: Column(
                  children: [
                    // The glowing bar
                    Container(
                      height: 4,
                      width: itemWidth * 0.5,
                      decoration: BoxDecoration(
                        color: widget.glowColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.glowColor.withValues(alpha: 0.8),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    // The light beam gradient
                    Expanded(
                      child: Container(
                        width: itemWidth * 0.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              widget.glowColor.withValues(alpha: 0.15),
                              widget.glowColor.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // NavBar Items
              Row(
                children: List.generate(widget.items.length, (index) {
                  final isSelected = widget.selectedIndex == index;
                  final item = widget.items[index];
                  
                  return GestureDetector(
                    onTap: () => widget.onItemSelected(index),
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: itemWidth,
                      height: widget.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            transformAlignment: Alignment.center,
                            transform: Matrix4.identity()..translate(0.0, isSelected ? -4.0 : 0.0),
                            child: Icon(
                              item.icon,
                              color: isSelected ? activeColor : inactiveColor,
                              size: 26,
                              shadows: isSelected ? [
                                BoxShadow(
                                  color: widget.glowColor.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                )
                              ] : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? activeColor : inactiveColor,
                            ),
                            child: Text(item.label),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
