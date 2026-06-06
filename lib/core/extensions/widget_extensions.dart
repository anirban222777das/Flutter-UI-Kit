import 'package:flutter/material.dart';

/// Convenience extensions on [Widget] for common layout operations.
extension WidgetExtensions on Widget {
  /// Wraps this widget with [Padding] using the given [EdgeInsets].
  Widget padded(EdgeInsets padding) => Padding(
        padding: padding,
        child: this,
      );

  /// Wraps this widget with symmetric horizontal padding.
  Widget paddedH(double value) => Padding(
        padding: EdgeInsets.symmetric(horizontal: value),
        child: this,
      );

  /// Wraps this widget with symmetric vertical padding.
  Widget paddedV(double value) => Padding(
        padding: EdgeInsets.symmetric(vertical: value),
        child: this,
      );

  /// Wraps this widget with uniform padding on all sides.
  Widget paddedAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  /// Centers this widget within its parent.
  Widget centered() => Center(child: this);

  /// Wraps this widget in a [SliverToBoxAdapter].
  Widget toSliver() => SliverToBoxAdapter(child: this);

  /// Wraps this widget in an [Expanded] with optional flex.
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// Wraps this widget in [Opacity] for visibility control.
  Widget withOpacity(double opacity) => Opacity(
        opacity: opacity,
        child: this,
      );

  /// Wraps this widget in a [RepaintBoundary] for performance.
  Widget repaintBoundary() => RepaintBoundary(child: this);
}
