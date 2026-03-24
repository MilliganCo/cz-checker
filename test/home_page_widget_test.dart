import 'package:cz_checker/src/models/check_response.dart';
import 'package:cz_checker/src/providers/crpt_api_provider.dart';
import 'package:cz_checker/src/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  testWidgets('scanned item turns green when IN_CIRCULATION',
      (tester) async {
    final mockClient = MockClient((req) async =>
        http.Response('{"status":"IN_CIRCULATION"}', 200));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          crptApiProvider.overrideWithValue(CrptApi(client: mockClient)),
        ],
        child: const CzCheckerApp(),
      ),
    );

    // Вводим строку и жмём Enter
    await tester.enterText(find.byType(TextField), '010TEST');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();                 // add item
    await tester.pump(const Duration(milliseconds: 500)); // дождаться цвета

    final card = tester.widget<AnimatedContainer>(
        find.byKey(const ValueKey('010TEST')));
    final boxDeco = card.decoration as BoxDecoration;
    expect(boxDeco.color, Colors.green.shade300);
  });
} 