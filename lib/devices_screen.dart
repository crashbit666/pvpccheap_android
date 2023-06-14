import 'package:flutter/material.dart';
import 'package:pvpccheap/services/api_client.dart';

class DevicesScreen extends StatefulWidget {
  final String token;

  const DevicesScreen({super.key, required this.token});

  @override
  DevicesScreenState createState() => DevicesScreenState();
}

class DevicesScreenState extends State<DevicesScreen> {
  late Future<List<dynamic>> futureDevices;

  @override
  void initState() {
    super.initState();
    var apiClient = ApiClient(baseUrl: 'http://127.0.0.1:5000');
    futureDevices = apiClient.getDevices(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureDevices,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]['name']),  // Asume que cada dispositivo tiene una propiedad 'name'
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Por defecto, muestra un spinner de carga.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
