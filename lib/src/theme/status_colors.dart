import 'package:flutter/material.dart';
import '../models/check_response.dart';

extension StatusColorX on CheckResponse? {
  /// Возвращает базовый цвет фона карточки для данного ответа.
  Color toCardColor() {
    if (this == null) return Colors.grey.shade200;
    final s = this!;
    if (s.isInCirculation) return Colors.green.shade300;
    if (s.status.toUpperCase().startsWith('ERROR')) return Colors.red.shade300;
    return Colors.orange.shade300;
  }
} 