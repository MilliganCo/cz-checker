import 'package:cz_checker/src/models/check_response.dart';

class ScannedItem {
  final String code;
  final CheckResponse? response;
  final DateTime ts;

  ScannedItem({required this.code, this.response, required this.ts});

  bool get isDone => response != null;
  bool get isError => response?.status.startsWith('ERROR') ?? false;
  bool get isOk => response?.isInCirculation ?? false;

  ScannedItem copyWith({
    String? code,
    CheckResponse? response,
    DateTime? ts,
  }) {
    return ScannedItem(
      code: code ?? this.code,
      response: response ?? this.response,
      ts: ts ?? this.ts,
    );
  }
} 