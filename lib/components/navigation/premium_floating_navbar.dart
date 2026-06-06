import 'dart:ui';
import 'package:flutter/material.dart';

class PremiumFloatingNavBarItem {
  final IconData icon;
  final String label;

  const PremiumFloatingNavBarItem({
    required this.icon,
    required this.label,
  });
}

class PremiumFloatingNavBar extends StatefulWidget {
  final int selectedIndex;
  final List<PremiumFloatingNavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final double height;
  final double iconSize;

  const PremiumFloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
    this.height = 70.0,
    this.iconSize = 24.0,
  });

  @override
  State<PremiumFloatingNavBar> createState() => _PremiumFloatingNavBarState();
}

class _PremiumFloatingNavBarState extends State<PremiumFloatingNavBar> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bgColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);
        
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.black.withValues(alpha: 0.1);

    final indicatorColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.white;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.height / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.height / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(widget.height / 2),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / widget.items.length;
                
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Sliding Indicator
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      left: widget.selectedIndex * itemWidth,
                      width: itemWidth,
                      top: 8,
                      bottom: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: indicatorColor,
                          borderRadius: BorderRadius.circular(widget.height / 2),
                          boxShadow: !isDark ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ] : null,
                        ),
                      ),
                    ),
                    
                    // Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(widget.items.length, (index) {
                        final isSelected = widget.selectedIndex == index;
                        final item = widget.items[index];
                        
                        return GestureDetector(
                          onTap: () => widget.onItemSelected(index),
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            width: itemWidth,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOutCubic,
                              transformAlignment: Alignment.center,
                              transform: Matrix4.identity()..scale(isSelected ? 1.1 : 1.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedTheme(
                                    data: Theme.of(context).copyWith(
                                      iconTheme: IconThemeData(
                                        color: isSelected 
                                            ? (isDark ? Colors.white : Colors.black87)
                                            : (isDark ? Colors.white54 : Colors.black54),
                                        size: widget.iconSize,
                                      ),
                                    ),
                                    child: Icon(item.icon),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeOutCubic,
                                    height: isSelected ? 4 : 0,
                                  ),
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 350),
                                    opacity: isSelected ? 1.0 : 0.0,
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 350),
                                      style: TextStyle(
                                        fontSize: isSelected ? 12 : 0,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                      child: Text(item.label),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
