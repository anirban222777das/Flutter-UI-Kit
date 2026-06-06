import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/catalog/data/component_registry.dart';
import 'package:uikit/catalog/widgets/code_block.dart';
import 'package:uikit/core/animations/animation_utils.dart';
import 'package:uikit/core/constants/app_radius.dart';
import 'package:uikit/core/constants/app_spacing.dart';
import 'package:uikit/core/extensions/context_extensions.dart';
import 'package:uikit/core/providers/favorites_provider.dart';
import 'package:uikit/shared/widgets/tag_chip.dart';

/// Detailed preview screen for a single component.
///
/// Shows a large live preview, customizable controls,
/// description, features, dependencies, and usage example.
class ComponentPreviewScreen extends ConsumerWidget {
  const ComponentPreviewScreen({
    required this.categoryId,
    required this.componentId,
    super.key,
  });

  /// ID of the parent category.
  final String categoryId;

  /// ID of the component to preview.
  final String componentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final component = ComponentRegistry.getComponentById(componentId);
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(componentId);

    if (component == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Component not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => context.pop(),
            ),
            title: Text(component.name),
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey(isFavorite),
                    color: isFavorite ? Colors.redAccent : null,
                  ),
                ),
                onPressed: () =>
                    ref.read(favoritesProvider.notifier).toggle(componentId),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),

          // Live Preview Area
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.xl),
              height: 280,
              decoration: BoxDecoration(
                color: context.isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.02),
                borderRadius: AppRadius.borderRadiusXl,
                border: Border.all(
                  color: context.colors.outline.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: AppRadius.borderRadiusXl,
                child: Center(
                  child: RepaintBoundary(
                    child: component.previewBuilder(),
                  ),
                ),
              ),
            ).fadeSlideIn(offsetY: 20),
          ),

          // Component Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  if (component.tags.isNotEmpty) ...[
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: component.tags
                          .map((tag) => TagChip(label: tag))
                          .toList(),
                    ).fadeSlideIn(
                      delay: const Duration(milliseconds: 100),
                      offsetY: 16,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Description
                  Text(
                    'Description',
                    style: context.textTheme.titleMedium,
                  ).fadeSlideIn(
                    delay: const Duration(milliseconds: 150),
                    offsetY: 16,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    component.description,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ).fadeSlideIn(
                    delay: const Duration(milliseconds: 180),
                    offsetY: 16,
                  ),

                  // Features
                  if (component.features.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Features',
                      style: context.textTheme.titleMedium,
                    ).fadeSlideIn(
                      delay: const Duration(milliseconds: 200),
                      offsetY: 16,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...component.features.asMap().entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 18,
                                  color: context.colors.primary,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                      color:
                                          context.colors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).fadeSlideIn(
                            delay: Duration(
                              milliseconds: 220 + (entry.key * 40),
                            ),
                            offsetY: 12,
                          ),
                        ),
                  ],

                  // Dependencies
                  if (component.dependencies.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Dependencies',
                      style: context.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: component.dependencies
                          .map(
                            (dep) => TagChip(
                              label: dep,
                              color: context.colors.secondary,
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  // Usage Example
                  if (component.usageExample.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Usage',
                      style: context.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    CodeBlock(code: component.usageExample),
                  ],

                  // Implementation Notes
                  if (component.implementationNotes.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Implementation Notes',
                      style: context.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      component.implementationNotes,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.hero),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
