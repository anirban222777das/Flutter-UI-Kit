import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// An expandable floating action button with a radial menu.
///
/// When tapped, expands to reveal multiple action items
/// arranged in a vertical column with staggered spring animations.
///
/// Example:
/// ```dart
/// FloatingActionButtonCustom(
///   icon: Icons.add,
///   items: [
///     FabItem(icon: Icons.photo, label: 'Photo', onTap: () {}),
///     FabItem(icon: Icons.video_call, label: 'Video', onTap: () {}),
///   ],
/// )
/// ```
class FabItem {
  const FabItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  /// Icon shown on the mini FAB.
  final IconData icon;

  /// Label for the item.
  final String label;

  /// Callback when this item is tapped.
  final VoidCallback onTap;

  /// Optional accent color.
  final Color? color;
}

class FloatingActionButtonCustom extends StatefulWidget {
  const FloatingActionButtonCustom({
    required this.items,
    super.key,
    this.icon = Icons.add_rounded,
    this.closeIcon = Icons.close_rounded,
    this.backgroundColor,
    this.iconColor,
    this.size = 56,
    this.miniSize = 44,
    this.spacing = 14,
  });

  /// Items to display when expanded.
  final List<FabItem> items;

  /// Icon for the main FAB (default state).
  final IconData icon;

  /// Icon for the main FAB (expanded state).
  final IconData closeIcon;

  /// Background color of the main FAB.
  final Color? backgroundColor;

  /// Icon color of the main FAB.
  final Color? iconColor;

  /// Size of the main FAB.
  final double size;

  /// Size of the mini FABs.
  final double miniSize;

  /// Spacing between items.
  final double spacing;

  @override
  State<FloatingActionButtonCustom> createState() =>
      _FloatingActionButtonCustomState();
}

class _FloatingActionButtonCustomState
    extends State<FloatingActionButtonCustom>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.normal,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ?? const Color(0xFF6366F1);
    final fgColor = widget.iconColor ?? Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Mini FABs
        ...widget.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final reversedIndex = widget.items.length - 1 - index;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final itemAnimation = CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  reversedIndex * 0.1,
                  0.6 + reversedIndex * 0.1,
                  curve: Curves.easeOutBack,
                ),
              );

              return Transform.translate(
                offset: Offset(
                  0,
                  (1 - itemAnimation.value) * 20,
                ),
                child: Opacity(
                  opacity: itemAnimation.value,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.spacing),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Label
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E26)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Mini FAB
                  GestureDetector(
                    onTap: () {
                      item.onTap();
                      _toggle();
                    },
                    child: Container(
                      width: widget.miniSize,
                      height: widget.miniSize,
                      decoration: BoxDecoration(
                        color: item.color ?? bgColor.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (item.color ?? bgColor)
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        item.icon,
                        color: fgColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        // Main FAB
        GestureDetector(
          onTap: _toggle,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: bgColor.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Transform.rotate(
                  angle: _controller.value * math.pi / 4,
                  child: Icon(
                    _isOpen ? widget.closeIcon : widget.icon,
                    color: fgColor,
                    size: 26,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
