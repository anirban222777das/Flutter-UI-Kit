import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';
import 'package:uikit/core/constants/app_radius.dart';
import 'package:uikit/core/constants/app_spacing.dart';
import 'package:uikit/core/extensions/context_extensions.dart';
import 'package:uikit/shared/models/component_model.dart';

/// A premium card widget that displays a component preview
/// with animated tap interactions and hover states.
///
/// Used in category screens to showcase individual components.
class ComponentCard extends StatefulWidget {
  const ComponentCard({
    required this.component,
    required this.onTap,
    super.key,
  });

  /// The component data to display.
  final ComponentItem component;

  /// Callback when the card is tapped.
  final VoidCallback onTap;

  @override
  State<ComponentCard> createState() => _ComponentCardState();
}

class _ComponentCardState extends State<ComponentCard> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: AppRadius.borderRadiusLg,
            border: Border.all(
              color: context.colors.outline.withValues(alpha: 0.5),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: context.isDark ? 0.3 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview area
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg),
                  ),
                  child: Container(
                    color: context.isDark
                        ? Colors.white.withValues(alpha: 0.03)
                        : Colors.black.withValues(alpha: 0.02),
                    child: Center(
                      child: RepaintBoundary(
                        child: Padding(
                          padding: AppSpacing.paddingMd,
                          child: widget.component.previewBuilder(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Info area
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.component.name,
                        style: context.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          widget.component.description,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.component.tags.isNotEmpty)
                        Wrap(
                          spacing: AppSpacing.xs,
                          children: widget.component.tags
                              .take(3)
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colors.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: AppRadius.borderRadiusFull,
                                  ),
                                  child: Text(
                                    tag,
                                    style:
                                        context.textTheme.labelSmall?.copyWith(
                                      color: context.colors.primary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
