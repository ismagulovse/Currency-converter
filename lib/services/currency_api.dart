import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/exchange_rate.dart';

class CurrencyApi {
  Future<ExchangeRate> getRate(String from, String to) async {
    final url = Uri.parse(
      'https://api.frankfurter.dev/v2/rate/${from.toLowerCase()}/${to.toLowerCase()}',
    );
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ExchangeRate.fromJson(json);
    } else {
      throw Exception('Не удалось получить курс');
    }
  }
}
