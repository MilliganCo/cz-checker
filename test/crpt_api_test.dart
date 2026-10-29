import 'dart:convert';
import 'package:cz_checker/src/data/crpt_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('CrptApi.check', () {
    test('returns IN_CIRCULATION', () async {
      final mockClient = MockClient((req) async {
        return http.Response(jsonEncode({'status': 'IN_CIRCULATION'}), 200);
      });
      final api = CrptApi(client: mockClient);
      final resp = await api.check('dummy');
      expect(resp.status, 'IN_CIRCULATION');
      expect(resp.isInCirculation, isTrue);
    });

    test('returns ERROR_HTTP_404 on 404', () async {
      final mockClient = MockClient((req) async => http.Response('', 404));
      final api = CrptApi(client: mockClient);
      final resp = await api.check('dummy');
      expect(resp.status, 'ERROR_HTTP_404');
      expect(resp.isInCirculation, isFalse);
    });
  });
} 