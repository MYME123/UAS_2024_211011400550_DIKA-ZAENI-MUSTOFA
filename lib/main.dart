import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harga Crypto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: CryptoListPage(),
    );
  }
}

class CryptoListPage extends StatefulWidget {
  @override
  _CryptoListPageState createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage> {
  List<dynamic> _cryptoData = [];
  Map<String, double> _exchangeRates = {
    'USD': 14325.0, // Contoh nilai tukar USD ke IDR
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String apiUrl = 'https://api.coinlore.net/api/tickers/';
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        _cryptoData = jsonDecode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  String formatCurrency(double price, String symbol) {
    if (_exchangeRates.containsKey(symbol)) {
      double exchangeRate = _exchangeRates[symbol]!;
      double priceInIDR = price * exchangeRate;
      return 'Rp ${NumberFormat.decimalPattern().format(priceInIDR)}';
    } else {
      return '\$${NumberFormat.decimalPattern().format(price)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harga Crypto', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 16, 0, 188),
      ),
      backgroundColor: Color.fromARGB(255, 249, 196, 5),
      body: _cryptoData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cryptoData.length,
              itemBuilder: (BuildContext context, int index) {
                var crypto = _cryptoData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        crypto['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        formatCurrency(double.parse(crypto['price_usd']), 'USD'),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 16, 0, 188),
                          fontSize: 16.0,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: const Color.fromARGB(255, 16, 0, 188),
                      ),
                      onTap: () {
                        // Aksi saat ListTile ditekan (opsional)
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
