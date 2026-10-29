import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cz_checker/src/providers/crpt_api_provider.dart';
import 'package:cz_checker/src/models/scanned_item.dart';

class ScannedItemsNotifier extends StateNotifier<List<ScannedItem>> {
  ScannedItemsNotifier(this._ref) : super(const []);

  final Ref _ref;

  static const _maxItems = 500;

  Future<void> add(String rawCode) async {
    // 1. Создаём временный элемент
    final item = ScannedItem(code: rawCode, response: null, ts: DateTime.now());

    // новые сверху, и обрезаем список, если превышает _maxItems
    state = [item, ...state];
    if (state.length > _maxItems) {
      state = state.sublist(0, _maxItems);
    }

    // 2. Делаем запрос
    final api = _ref.read(crptApiProvider);
    final resp = await api.check(rawCode);

    // 3. Обновляем тот же элемент (по ссылке или коду)
    state = [
      for (final it in state)
        if (identical(it, item) || it.code == rawCode && !it.isDone)
          it.copyWith(response: resp)
        else
          it,
    ];
  }

  void clear() => state = [];
}

final scannedItemsProvider =
    StateNotifierProvider<ScannedItemsNotifier, List<ScannedItem>>(
      (ref) => ScannedItemsNotifier(ref),
    );
