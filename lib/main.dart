import 'package:flutter/material.dart';
import 'package:cz_checker/src/ui/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: CzCheckerApp()));
}
