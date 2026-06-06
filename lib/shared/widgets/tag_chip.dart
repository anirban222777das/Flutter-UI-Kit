import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_radius.dart';
import 'package:uikit/core/constants/app_spacing.dart';
import 'package:uikit/core/extensions/context_extensions.dart';

/// A small chip widget for displaying component tags.
///
/// Used in category screens and component previews to show
/// searchable tags like "glass", "animated", "ios-style".
class TagChip extends StatelessWidget {
  const TagChip({
    required this.label,
    super.key,
    this.color,
    this.textStyle,
  });

  /// The text displayed in the chip.
  final String label;

  /// Optional accent color override.
  final Color? color;

  /// Optional text style override.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? context.colors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: AppRadius.borderRadiusFull,
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: textStyle ??
            context.textTheme.labelSmall?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
