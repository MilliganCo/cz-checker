import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/check_response.dart';

class CrptApi {
  static const _baseUrl = 'https://mobile.api.crpt.ru';

  final http.Client _client;

  CrptApi({http.Client? client}) : _client = client ?? http.Client();

  Future<CheckResponse> check(String code) async {
    final uri = Uri.parse('$_baseUrl/mobile/check').replace(queryParameters: {
      'code': code,
    });

    try {
      final resp = await _client
          .get(uri)
          .timeout(const Duration(seconds: 6));

      if (resp.statusCode == 200) {
        final json = jsonDecode(resp.body) as Map<String, dynamic>;
        return CheckResponse.fromJson(json);
      } else {
        // ЧЗ иногда отдаёт 400/404, трактуем как «не в обороте»
        return CheckResponse(status: 'ERROR_HTTP_${resp.statusCode}');
      }
    } on TimeoutException {
      return CheckResponse(status: 'ERROR_TIMEOUT');
    } on SocketException {
      return CheckResponse(status: 'ERROR_NETWORK');
    } catch (e) {
      return CheckResponse(status: 'ERROR_UNKNOWN');
    }
  }

  void dispose() => _client.close();
}
