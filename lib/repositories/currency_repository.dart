import '../models/exchange_rate.dart';
import '../services/currency_api.dart';

class CurrencyRepository {
  final CurrencyApi api;

  CurrencyRepository(this.api);

  Future<ExchangeRate> getRate(String from, String to) {
    return api.getRate(from, to);
  }
}
