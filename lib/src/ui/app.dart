import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/theme_mode_provider.dart';
import 'pages/home_page.dart';

class CzCheckerApp extends HookConsumerWidget {
  const CzCheckerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'CZ Checker',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}
