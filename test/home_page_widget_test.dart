import 'dart:async';

import 'package:cz_checker/src/data/crpt_api.dart';
import 'package:cz_checker/src/providers/crpt_api_provider.dart';
import 'package:cz_checker/src/providers/scanned_items_provider.dart';
import 'package:cz_checker/src/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('scanned item turns green when IN_CIRCULATION', (tester) async {
    final api = CrptApi(
      client: MockClient(
        (_) async => http.Response('{"status":"IN_CIRCULATION"}', 200),
      ),
    );
    addTearDown(api.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [crptApiProvider.overrideWithValue(api)],
        child: const CzCheckerApp(),
      ),
    );

    await tester.enterText(find.byType(TextField), '010TEST');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final card = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('010TEST')),
    );
    final decoration = card.decoration as BoxDecoration;
    expect(decoration.color, Colors.green.shade300);
  });

  testWidgets('a completed scan does not touch an unmounted page', (tester) async {
    final response = Completer<http.Response>();
    final api = CrptApi(client: MockClient((_) => response.future));
    final container = ProviderContainer(
      overrides: [crptApiProvider.overrideWithValue(api)],
    );
    addTearDown(() {
      container.dispose();
      api.dispose();
    });

    // Keep the provider alive while disposing only the page/controller/context.
    // This isolates the UI await boundary from provider-disposal cancellation.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CzCheckerApp(),
      ),
    );
    await tester.enterText(find.byType(TextField), '010PENDING');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.text('Проверяется…'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    response.complete(http.Response('{"status":"IN_CIRCULATION"}', 200));
    await tester.pumpAndSettle();

    expect(
      container.read(scannedItemsProvider).single.response?.isInCirculation,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });
}
