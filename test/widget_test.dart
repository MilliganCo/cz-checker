import 'package:cz_checker/src/data/crpt_api.dart';
import 'package:cz_checker/src/providers/crpt_api_provider.dart';
import 'package:cz_checker/src/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

void main() {
  testWidgets('scanner shell renders and changes theme without HTTP',
      (tester) async {
    var requests = 0;
    final api = CrptApi(client: MockClient((_) async {
      requests += 1;
      throw StateError('The shell smoke must not make an HTTP request');
    }));
    addTearDown(api.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [crptApiProvider.overrideWithValue(api)],
        child: const CzCheckerApp(),
      ),
    );

    expect(find.text('CZ Checker'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsNothing);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.system,
    );

    await tester.tap(find.byTooltip('Светлая/тёмная тема'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    await tester.tap(find.byTooltip('Светлая/тёмная тема'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
    expect(requests, 0);
  });
}
