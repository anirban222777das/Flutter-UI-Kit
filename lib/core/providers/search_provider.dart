import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uikit/catalog/data/component_registry.dart';
import 'package:uikit/shared/models/component_model.dart';

/// Current search query string.
final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

/// Notifier for search query state.
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  /// Updates the search query.
  void update(String query) {
    state = query;
  }

  /// Clears the search query.
  void clear() {
    state = '';
  }
}

/// Filtered list of [ComponentItem]s based on the current search query.
///
/// Searches across component name, description, tags, and category.
final filteredComponentsProvider = Provider<List<ComponentItem>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final allComponents = ComponentRegistry.allComponents;

  if (query.isEmpty) return allComponents;

  return allComponents.where((component) {
    final matchesName = component.name.toLowerCase().contains(query);
    final matchesDescription =
        component.description.toLowerCase().contains(query);
    final matchesTags =
        component.tags.any((tag) => tag.toLowerCase().contains(query));
    final matchesCategory =
        component.categoryId.toLowerCase().contains(query);

    return matchesName || matchesDescription || matchesTags || matchesCategory;
  }).toList();
});
