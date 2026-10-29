import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cz_checker/src/providers/theme_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('ThemeModeNotifier toggles from system to dark, then light', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(themeModeProvider.notifier);

    expect(container.read(themeModeProvider), ThemeMode.system);

    notifier.toggle();
    expect(container.read(themeModeProvider), ThemeMode.dark);

    notifier.toggle();
    expect(container.read(themeModeProvider), ThemeMode.light);
  });
} 