import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/crpt_api.dart';

final crptApiProvider = Provider<CrptApi>((ref) {
  final api = CrptApi();
  ref.onDispose(api.dispose);
  return api;
}); 