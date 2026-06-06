import 'package:flutter/material.dart';

/// Adaptive responsive grid layout that adjusts columns
/// based on available width.
///
/// Uses [LayoutBuilder] to determine the optimal column count
/// and renders children in a [GridView].
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    super.key,
    this.minCrossAxisExtent = 160,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 16,
    this.childAspectRatio = 1.0,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = false,
    this.physics,
  });

  /// Widgets to display in the grid.
  final List<Widget> children;

  /// Minimum width for each column.
  final double minCrossAxisExtent;

  /// Spacing between rows.
  final double mainAxisSpacing;

  /// Spacing between columns.
  final double crossAxisSpacing;

  /// Aspect ratio of each grid cell.
  final double childAspectRatio;

  /// Padding around the grid.
  final EdgeInsets padding;

  /// Whether the grid should shrink-wrap its content.
  final bool shrinkWrap;

  /// Scroll physics override.
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: minCrossAxisExtent,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}
