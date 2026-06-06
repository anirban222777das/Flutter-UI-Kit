import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the current [ThemeMode] and allows toggling between modes.
///
/// Defaults to [ThemeMode.dark] for the premium catalog experience.
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

/// Notifier that manages theme mode state.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.dark;

  /// Cycles through theme modes: dark → light → system → dark.
  void toggle() {
    switch (state) {
      case ThemeMode.dark:
        state = ThemeMode.light;
      case ThemeMode.light:
        state = ThemeMode.system;
      case ThemeMode.system:
        state = ThemeMode.dark;
    }
  }

  /// Sets a specific theme mode.
  void setMode(ThemeMode mode) {
    state = mode;
  }

  /// Returns a human-readable label for the current mode.
  String get label => switch (state) {
        ThemeMode.dark => 'Dark',
        ThemeMode.light => 'Light',
        ThemeMode.system => 'System',
      };

  /// Returns the icon for the current mode.
  IconData get icon => switch (state) {
        ThemeMode.dark => Icons.dark_mode_rounded,
        ThemeMode.light => Icons.light_mode_rounded,
        ThemeMode.system => Icons.brightness_auto_rounded,
      };
}
