import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cz_checker/src/models/check_response.dart';
import 'package:cz_checker/src/theme/status_colors.dart';

void main() {
  test('toCardColor returns correct colors', () {
    expect(null.toCardColor(), Colors.grey.shade200);

    final ok = CheckResponse(status: 'IN_CIRCULATION');
    expect(ok.toCardColor(), Colors.green.shade300);

    final err = CheckResponse(status: 'ERROR_NETWORK');
    expect(err.toCardColor(), Colors.red.shade300);

    final other = CheckResponse(status: 'EMITTED');
    expect(other.toCardColor(), Colors.orange.shade300);
  });
} 