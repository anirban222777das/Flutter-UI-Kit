import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uikit/catalog/screens/category_screen.dart';
import 'package:uikit/catalog/screens/component_preview_screen.dart';
import 'package:uikit/catalog/screens/home_screen.dart';

/// Application route paths.
abstract final class AppRoutes {
  static const String home = '/';
  static const String category = '/category/:categoryId';
  static const String component =
      '/category/:categoryId/component/:componentId';

  /// Builds a category path with the given [categoryId].
  static String categoryPath(String categoryId) => '/category/$categoryId';

  /// Builds a component path with category and component IDs.
  static String componentPath(String categoryId, String componentId) =>
      '/category/$categoryId/component/$componentId';
}

/// GoRouter configuration for the UIKit catalog.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder: _fadeTransition,
      ),
    ),
    GoRoute(
      path: AppRoutes.category,
      pageBuilder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        return CustomTransitionPage(
          key: state.pageKey,
          child: CategoryScreen(categoryId: categoryId),
          transitionsBuilder: _slideUpTransition,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.component,
      pageBuilder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        final componentId = state.pathParameters['componentId']!;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ComponentPreviewScreen(
            categoryId: categoryId,
            componentId: componentId,
          ),
          transitionsBuilder: _slideUpTransition,
        );
      },
    ),
  ],
);

// ──────────────────────────────────────────────
// Transition builders
// ──────────────────────────────────────────────

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    ),
    child: child,
  );
}

Widget _slideUpTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 0.04),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    ),
  );

  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    ),
    child: SlideTransition(
      position: offsetAnimation,
      child: child,
    ),
  );
}
