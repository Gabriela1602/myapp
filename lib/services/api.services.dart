import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency.dart';

class ApiService {
  static const String apiKey = 'TU_CLAVE_DE_API'; // Reemplaza con tu clave de API
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/USD';

  // Obtener tasas de cambio
  Future<Currency> getExchangeRates() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return Currency.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar las tasas de cambio');
    }
  }
}