import 'package:flutter/material.dart';

import '../models/exchange_rate.dart';
import '../repositories/currency_repository.dart';

class ConverterState extends ChangeNotifier {
  final CurrencyRepository repository;

  ConverterState(this.repository);

  String fromCurrency = 'EUR';
  String toCurrency = 'RUB';
  bool isLoading = false;
  String? error;
  ExchangeRate? exchangeRate;
  double? convertedAmount;

  void setFromCurrency(String currency) {
    fromCurrency = currency;
    _clearResult();
  }

  void setToCurrency(String currency) {
    toCurrency = currency;
    _clearResult();
  }

  void swapCurrencies() {
    final oldCurrency = fromCurrency;
    fromCurrency = toCurrency;
    toCurrency = oldCurrency;
    _clearResult();
  }

  void _clearResult() {
    error = null;
    exchangeRate = null;
    convertedAmount = null;
    notifyListeners();
  }

  Future<void> convert(String amountText) async {
    final amount = double.tryParse(amountText.replaceAll(',', '.'));

    if (amount == null) {
      error = 'Введите сумму';
      notifyListeners();
      return;
    }
    if (amount < 0) {
      error = 'Нельзя вводить отрицательную сумму';
      notifyListeners();
      return;
    }

    isLoading = true;
    error = null;
    exchangeRate = null;
    convertedAmount = null;
    notifyListeners();

    try {
      exchangeRate = await repository.getRate(fromCurrency, toCurrency);
      convertedAmount = amount * exchangeRate!.rate;
    } on FormatException {
      error = 'Сервер прислал данные в неверном формате';
    } catch (_) {
      error = 'Не удалось загрузить курс. Проверьте интернет.';
    }

    isLoading = false;
    notifyListeners();
  }
}
