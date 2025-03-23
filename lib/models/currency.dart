class Currency {
  final String base;
  final Map<String, double> rates;

  Currency({
    required this.base,
    required this.rates,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      base: json['base'],
      rates: Map<String, double>.from(json['rates']),
    );
  }
}