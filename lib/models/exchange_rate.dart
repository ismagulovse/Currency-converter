class ExchangeRate {
  final double rate;
  final String date;

  ExchangeRate({required this.rate, required this.date});

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    final rate = json['rate'];
    final date = json['date'];

    if (rate is! num || date is! String) {
      throw const FormatException('Неверный формат курса');
    }

    return ExchangeRate(rate: rate.toDouble(), date: date);
  }
}
