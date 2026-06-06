import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';
import 'package:uikit/core/constants/app_radius.dart';
import 'package:uikit/core/constants/app_spacing.dart';
import 'package:uikit/core/extensions/context_extensions.dart';
import 'package:uikit/shared/models/component_model.dart';

/// A premium tile widget for displaying component categories
/// on the home screen.
///
/// Features animated tap interactions, gradient accent,
/// and icon display.
class CategoryTile extends StatefulWidget {
  const CategoryTile({
    required this.category,
    required this.onTap,
    super.key,
  });

  /// The category data to display.
  final ComponentCategory category;

  /// Callback when the tile is tapped.
  final VoidCallback onTap;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final accent = widget.category.accentColor;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: AppRadius.borderRadiusXl,
            border: Border.all(
              color: context.colors.outline.withValues(alpha: 0.4),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: context.isDark ? 0.08 : 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with gradient background
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accent.withValues(alpha: 0.15),
                        accent.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: AppRadius.borderRadiusMd,
                    border: Border.all(
                      color: accent.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Icon(
                    widget.category.icon,
                    color: accent,
                    size: 22,
                  ),
                ),
                const Spacer(),
                // Category name
                Text(
                  widget.category.name,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                // Description
                Text(
                  widget.category.description,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                // Component count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: AppRadius.borderRadiusFull,
                  ),
                  child: Text(
                    '${widget.category.componentCount} components',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
