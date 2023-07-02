import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ElectricityPriceScreen extends StatefulWidget {
  final String token;

  const ElectricityPriceScreen({Key? key, required this.token}) : super(key: key);

  @override
  ElectricityPriceScreenState createState() => ElectricityPriceScreenState();
}

class ElectricityPriceScreenState extends State<ElectricityPriceScreen> {
  late Future<List<HourPrice>> futureHourPrice;
  late List<HourPrice> sortedData;

  @override
  void initState() {
    super.initState();
    futureHourPrice = fetchHourPrice();
  }

  Future<List<HourPrice>> fetchHourPrice() async {
    if (widget.token.isEmpty) {
      throw Exception('Please login first to see electricity prices.');
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/api/electricity_price'),
      // Make sure to replace 'your-flask-server.com' with your actual server
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<HourPrice> prices = List<HourPrice>.from(
          l.map((model) => HourPrice.fromJson(model)));
      return prices;
    } else {
      throw Exception('Failed to load electricity prices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electricity Prices'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.lock_clock),
            onPressed: () {
              setState(() {
                sortedData.sort((a, b) => int.parse(a.hour).compareTo(int.parse(b.hour)));
              });
            },
            tooltip: 'Sort by Hour',
          ),
          IconButton(
            icon: const Icon(Icons.euro_symbol),
            onPressed: () {
              setState(() {
                sortedData.sort((a, b) => a.price.compareTo(b.price));
              });
            },
            tooltip: 'Sort by Price',
          ),
        ],
      ),
      body: FutureBuilder<List<HourPrice>>(
        future: futureHourPrice,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            sortedData = snapshot.data!;
            return ListView.builder(
              itemCount: sortedData.length,
              itemBuilder: (context, index) {
                final hourPrice = sortedData[index];
                return Card(
                  child: ListTile(
                    leading: Text(hourPrice.hour, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    title: Text(hourPrice.price.toStringAsFixed(4)),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class HourPrice {
  final String hour;
  final double price;

  HourPrice({required this.hour, required this.price});

  factory HourPrice.fromJson(Map<String, dynamic> json) {
    return HourPrice(
      hour: json['hour'],
      price: json['price'].toDouble(),
    );
  }
}
