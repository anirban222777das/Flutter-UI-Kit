import 'package:flutter/material.dart';

class MorphingIslandNavBarItem {
  final IconData icon;
  final String label;

  const MorphingIslandNavBarItem({
    required this.icon,
    required this.label,
  });
}

class MorphingIslandNavBar extends StatefulWidget {
  final int selectedIndex;
  final List<MorphingIslandNavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final double height;
  final Color activeColor;

  const MorphingIslandNavBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
    this.height = 72.0,
    this.activeColor = const Color(0xFF10B981), // Emerald/Mint default
  });

  @override
  State<MorphingIslandNavBar> createState() => _MorphingIslandNavBarState();
}

class _MorphingIslandNavBarState extends State<MorphingIslandNavBar> 
    with SingleTickerProviderStateMixin {
  
  late int _previousIndex;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.selectedIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Gives the bouncy "island" effect
    );
  }

  @override
  void didUpdateWidget(MorphingIslandNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _previousIndex = oldWidget.selectedIndex;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final inactiveColor = isDark ? Colors.white54 : Colors.black54;
    final activeIconColor = isDark ? Colors.black : Colors.white;

    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(widget.height / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / widget.items.length;
          final padding = 6.0;

          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              // Calculate morphing stretch
              final startOffset = _previousIndex * itemWidth;
              final endOffset = widget.selectedIndex * itemWidth;
              
              // The inertia stretching formula
              final currentOffset = Tween<double>(begin: startOffset, end: endOffset).evaluate(_animation);
              
              // Add a stretching width effect at the middle of the animation
              // It bulges out depending on how far it's traveling
              final distance = (endOffset - startOffset).abs();
              final stretchFactor = (1.0 - (2.0 * (_animation.value - 0.5)).abs()) * (distance * 0.4);
              final morphWidth = itemWidth - (padding * 2) + stretchFactor;

              // To keep it centered while stretching
              final direction = (endOffset > startOffset) ? 1 : -1;
              final adjustedLeft = currentOffset + padding - (stretchFactor > 0 && direction == 1 ? stretchFactor : 0);

              return Stack(
                children: [
                  // Morphing Indicator Indicator
                  Positioned(
                    left: adjustedLeft,
                    top: padding,
                    bottom: padding,
                    width: morphWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.activeColor,
                        borderRadius: BorderRadius.circular(widget.height / 2),
                      ),
                    ),
                  ),

                  // Navigation Items
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
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                color: isSelected ? activeIconColor : inactiveColor,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                fontSize: isSelected ? 14 : 0.01, // Shrink to hide when inactive
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    item.icon,
                                    color: isSelected ? activeIconColor : inactiveColor,
                                    size: 24,
                                  ),
                                  // Animated spacing and text
                                  ClipRect(
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      width: isSelected ? 8 : 0,
                                      height: 0, // spacing handled by width
                                    ),
                                  ),
                                  if (isSelected) Text(item.label),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
