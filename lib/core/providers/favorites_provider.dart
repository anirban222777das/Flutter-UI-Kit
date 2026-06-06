import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages a set of favorited component IDs.
///
/// Currently in-memory; can be persisted with SharedPreferences
/// or other storage in the future.
final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);

/// Notifier that manages favorite component IDs.
class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  /// Toggles the favorite state of a component.
  void toggle(String componentId) {
    if (state.contains(componentId)) {
      state = {...state}..remove(componentId);
    } else {
      state = {...state, componentId};
    }
  }

  /// Whether a component is currently favorited.
  bool isFavorite(String componentId) => state.contains(componentId);
}
