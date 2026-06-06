import 'package:flutter/widgets.dart';

/// Data model representing a category of UI components.
///
/// Each category groups related components (e.g., Buttons, Cards)
/// and is displayed as a tile on the home screen.
class ComponentCategory {
  const ComponentCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.componentCount,
  });

  /// Unique identifier for routing and lookups.
  final String id;

  /// Display name shown in the catalog.
  final String name;

  /// Brief description of what this category contains.
  final String description;

  /// Icon displayed on the category tile.
  final IconData icon;

  /// Accent color for visual distinction.
  final Color accentColor;

  /// Number of components in this category.
  final int componentCount;
}

/// Data model representing a single UI component.
///
/// Contains metadata, builder, and documentation for each
/// component in the catalog.
class ComponentItem {
  const ComponentItem({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.previewBuilder,
    this.tags = const [],
    this.features = const [],
    this.dependencies = const [],
    this.usageExample = '',
    this.implementationNotes = '',
  });

  /// Unique identifier for routing and lookups.
  final String id;

  /// Display name of the component.
  final String name;

  /// Brief description of the component.
  final String description;

  /// ID of the parent [ComponentCategory].
  final String categoryId;

  /// Builder function that creates the component preview widget.
  final Widget Function() previewBuilder;

  /// Searchable tags for filtering (e.g., "glass", "animated").
  final List<String> tags;

  /// Feature list for the preview documentation.
  final List<String> features;

  /// Package dependencies needed to use this component.
  final List<String> dependencies;

  /// Dart code example showing how to use this component.
  final String usageExample;

  /// Implementation notes and tips.
  final String implementationNotes;
}
