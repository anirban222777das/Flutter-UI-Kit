import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/catalog/data/component_registry.dart';
import 'package:uikit/core/animations/animation_utils.dart';
import 'package:uikit/core/constants/app_spacing.dart';
import 'package:uikit/core/extensions/context_extensions.dart';
import 'package:uikit/core/providers/theme_provider.dart';
import 'package:uikit/core/router/app_router.dart';
import 'package:uikit/shared/widgets/category_tile.dart';

/// The home screen of the UIKit catalog.
///
/// Displays a premium category grid with staggered entry animations,
/// a hero section, and theme toggle.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ComponentRegistry.categories;
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        context.colors.primary,
                        context.colors.primary.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.widgets_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'UIKit',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(themeNotifier.icon),
                tooltip: 'Theme: ${themeNotifier.label}',
                onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),

          // Hero section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Component\nCatalog',
                    style: context.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      letterSpacing: -1.5,
                    ),
                  ).fadeSlideIn(offsetY: 30),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Production-ready Flutter components.\n'
                    'Copy, paste, and ship.',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ).fadeSlideIn(
                    delay: const Duration(milliseconds: 100),
                    offsetY: 20,
                  ),
                ],
              ),
            ),
          ),

          // Category grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: context.isCompact ? 200 : 240,
                mainAxisSpacing: AppSpacing.lg,
                crossAxisSpacing: AppSpacing.lg,
                childAspectRatio: context.isCompact ? 0.70 : 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = categories[index];
                  return CategoryTile(
                    category: category,
                    onTap: () => context.push(
                      AppRoutes.categoryPath(category.id),
                    ),
                  ).staggeredEntrance(
                    index: index,
                    staggerDelay: const Duration(milliseconds: 60),
                  );
                },
                childCount: categories.length,
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
