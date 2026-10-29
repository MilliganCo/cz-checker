import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cz_checker/src/data/crpt_api.dart';

final crptApiProvider = Provider<CrptApi>((ref) {
  final api = CrptApi();
  ref.onDispose(api.dispose);
  return api;
}); 