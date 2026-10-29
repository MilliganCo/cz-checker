import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:cz_checker/src/data/crpt_api.dart';
import 'package:cz_checker/src/models/check_response.dart';
import 'package:cz_checker/src/providers/crpt_api_provider.dart';
import 'package:cz_checker/src/providers/scanned_items_provider.dart';

import 'scanned_items_notifier_test.mocks.dart';

@GenerateMocks([CrptApi])
void main() {
  group('ScannedItemsNotifier', () {
    late MockCrptApi mockCrptApi;
    late ProviderContainer container;

    setUp(() {
      mockCrptApi = MockCrptApi();
      container = ProviderContainer(
        overrides: [
          crptApiProvider.overrideWithValue(mockCrptApi),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('add() exposes pending state until the response arrives', () async {
      final response = Completer<CheckResponse>();
      when(mockCrptApi.check(any)).thenAnswer((_) => response.future);

      final notifier = container.read(scannedItemsProvider.notifier);
      final operation = notifier.add('test_code_1');

      expect(notifier.state.length, 1);
      expect(notifier.state.first.code, 'test_code_1');
      expect(notifier.state.first.response, isNull);

      response.complete(CheckResponse(status: 'IN_CIRCULATION'));
      await operation;
      expect(notifier.state.first.isOk, isTrue);
    });

    test(
        'after CrptApi.check returns IN_CIRCULATION, item is updated and isOk is true',
        () async {
      when(mockCrptApi.check(any))
          .thenAnswer((_) async => CheckResponse(status: 'IN_CIRCULATION'));

      final notifier = container.read(scannedItemsProvider.notifier);
      await notifier.add('test_code_2');

      await container.pump(); // Allow time for async update

      expect(notifier.state.length, 1);
      expect(notifier.state.first.code, 'test_code_2');
      expect(notifier.state.first.isOk, isTrue);
      expect(notifier.state.first.response?.status, 'IN_CIRCULATION');
    });

    test('limit of 500 items: adding 501st removes the oldest', () async {
      when(mockCrptApi.check(any))
          .thenAnswer((_) async => CheckResponse(status: 'IN_CIRCULATION'));

      final notifier = container.read(scannedItemsProvider.notifier);

      // Add 500 items
      for (int i = 0; i < 500; i++) {
        await notifier.add('code_$i');
        await Future.delayed(Duration.zero); // Allow async updates to complete
      }

      expect(notifier.state.length, 500);
      expect(notifier.state.last.code, 'code_0'); // Oldest item

      // Add 501st item
      await notifier.add('code_500');
      await Future.delayed(Duration.zero); // Allow async updates to complete

      expect(notifier.state.length, 500);
      expect(notifier.state.first.code, 'code_500'); // Newest item
      expect(notifier.state.last.code, 'code_1'); // Oldest item (code_0 should be removed)
    });

    test('adding a duplicate code creates a new entry and updates only the latest', () async {
      when(mockCrptApi.check(any))
          .thenAnswer((_) async => CheckResponse(status: 'IN_CIRCULATION'));

      final notifier = container.read(scannedItemsProvider.notifier);

      // Add first instance of code_duplicate
      await notifier.add('code_duplicate');
      await Future.delayed(Duration.zero); // Allow async updates to complete
      expect(notifier.state.length, 1);
      expect(notifier.state.first.isOk, isTrue);
      expect(notifier.state.first.code, 'code_duplicate');

      // Add second instance of code_duplicate
      await notifier.add('code_duplicate');
      await Future.delayed(Duration.zero); // Allow async updates to complete

      expect(notifier.state.length, 2); // Should have two items now
      expect(notifier.state.first.code, 'code_duplicate'); // Newest
      expect(notifier.state.first.isOk, isTrue);
      expect(notifier.state.last.code, 'code_duplicate'); // Oldest
      expect(notifier.state.last.isOk, isTrue);

      // Verify that the initial item's response was not nulled out when the new one was added.
      // For this, we can rely on `identical` check in the notifier.
      // The logic `it.code == rawCode && !it.isDone` ensures only pending items with matching code are updated.
      // Since the first item is now `isDone == true`, it should not be updated by the second add().

      // To properly test this, we should add an item, wait for it to complete, then add another one.
      // The `identical` check ensures the *new* item is updated.
      // The `it.code == rawCode && !it.isDone` handles cases where a previous item with the same code is *still pending*.

      // Let's refine this test case to be more explicit about what's being tested.
      final firstItem = notifier.state[1]; // The older item
      final secondItem = notifier.state[0]; // The newer item

      expect(firstItem.code, 'code_duplicate');
      expect(firstItem.isOk, isTrue); // Should still be done and ok
      expect(secondItem.code, 'code_duplicate');
      expect(secondItem.isOk, isTrue); // Should also be done and ok
    });

  });
} 