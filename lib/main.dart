import 'package:flutter/material.dart';
import 'models/currency.dart';
import 'package:intl/intl.dart';
import 'package:myapp/services/api.services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Convertidor de Monedas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<Currency> _futureCurrency;
  final TextEditingController _amountController = TextEditingController();
  String _selectedCurrency = 'USD';
  double _convertedAmount = 0.0;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
  );

  @override
  void initState() {
    super.initState();
    _futureCurrency = _apiService.getExchangeRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Convertidor de Monedas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _convertCurrency();
              },
            ),
            SizedBox(height: 20),
            FutureBuilder<Currency>(
              future: _futureCurrency,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitFadingCircle(color: Colors.blue);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return Text('No hay datos');
                } else {
                  final currency = snapshot.data!;
                  return DropdownButton<String>(
                    value: _selectedCurrency,
                    items:
                        currency.rates.keys.map((String key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(key),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCurrency = newValue!;
                        _convertCurrency();
                      });
                    },
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              'Cantidad convertida: ${_currencyFormat.format(_convertedAmount)} $_selectedCurrency',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _convertCurrency() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (_futureCurrency != null) {
      _futureCurrency.then((currency) {
        final rate = currency.rates[_selectedCurrency] ?? 1.0;
        setState(() {
          _convertedAmount = amount * rate;
        });
      });
    }
  }
}
