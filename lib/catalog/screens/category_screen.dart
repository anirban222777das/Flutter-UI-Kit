import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/catalog/data/component_registry.dart';
import 'package:uikit/core/animations/animation_utils.dart';
import 'package:uikit/core/constants/app_spacing.dart';
import 'package:uikit/core/extensions/context_extensions.dart';
import 'package:uikit/core/router/app_router.dart';
import 'package:uikit/shared/widgets/component_card.dart';

/// Screen that displays all components within a selected category.
///
/// Shows animated component cards with live previews and
/// navigation to detailed component previews.
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    required this.categoryId,
    super.key,
  });

  /// ID of the category to display.
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final category = ComponentRegistry.getCategoryById(categoryId);
    final components = ComponentRegistry.getComponentsByCategory(categoryId);

    if (category == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Category not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with category info
          SliverAppBar(
            floating: true,
            snap: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => context.pop(),
            ),
            title: Text(category.name),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: AppSpacing.lg),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: category.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${components.length} components',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: category.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          // Category description
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: Text(
                category.description,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ).fadeSlideIn(offsetY: 16),
            ),
          ),

          // Component grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: context.isCompact ? 220 : 280,
                mainAxisSpacing: AppSpacing.lg,
                crossAxisSpacing: AppSpacing.lg,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final component = components[index];
                  return ComponentCard(
                    component: component,
                    onTap: () => context.push(
                      AppRoutes.componentPath(categoryId, component.id),
                    ),
                  ).staggeredEntrance(
                    index: index,
                    staggerDelay: const Duration(milliseconds: 50),
                  );
                },
                childCount: components.length,
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.hero),
          ),
        ],
      ),
    );
  }
}
