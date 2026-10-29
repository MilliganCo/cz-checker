import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cz_checker/src/providers/scanned_items_provider.dart';
import 'package:cz_checker/src/models/scanned_item.dart';
import 'package:cz_checker/src/theme/status_colors.dart';
import 'package:cz_checker/src/providers/theme_mode_provider.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final items = ref.watch(scannedItemsProvider);

    ref.listen<List<ScannedItem>>(scannedItemsProvider, (prev, next) {
      if (next.isEmpty) return;
      final latest = next.first;
      if (latest.response != null &&
          latest.response!.isError &&
          context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка проверки: ${latest.response!.status}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    Future<void> onSubmit(String value) async {
      final code = value.trim();
      if (code.isNotEmpty) {
        await ref.read(scannedItemsProvider.notifier).add(code);
      }
      if (!context.mounted) return;
      controller.clear();
      controller.selection = const TextSelection.collapsed(offset: 0);
      FocusScope.of(context).requestFocus(FocusNode()); // сброс
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CZ Checker'),
        actions: [
          IconButton(
            tooltip: 'Светлая/тёмная тема',
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
          IconButton(
            tooltip: 'Очистить список',
            onPressed: () => ref.read(scannedItemsProvider.notifier).clear(),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Отсканируйте код и нажмите Enter',
                border: OutlineInputBorder(),
              ),
              onSubmitted: onSubmit,
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _ScannedItemCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannedItemCard extends StatelessWidget {
  const _ScannedItemCard({required this.item});

  final ScannedItem item;

  @override
  Widget build(BuildContext context) {
    final Color targetColor = item.response.toCardColor();
    final statusText = item.response == null
        ? 'Проверяется…'
        : (item.response!.isError
              ? 'Ошибка: ${item.response!.status}'
              : item.response!.status);

    return AnimatedContainer(
      key: ValueKey(item.code),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: targetColor,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            item.code,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            statusText,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
