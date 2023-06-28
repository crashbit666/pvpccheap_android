import 'package:flutter/material.dart';
import 'package:pvpccheap/services/api_client.dart';
import 'package:pvpccheap/device.dart';
import 'sleep_hour_bar.dart';

class DevicesScreen extends StatefulWidget {
  final String token;

  const DevicesScreen({Key? key, required this.token}) : super(key: key);

  @override
  DevicesScreenState createState() => DevicesScreenState();
}

class DevicesScreenState extends State<DevicesScreen> {
  late Future<List<Device>> futureDevices;

  @override
  void initState() {
    super.initState();
    var apiClient = ApiClient(baseUrl: 'http://127.0.0.1:5000');
    futureDevices = apiClient.getDevices(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Device>>(
      future: futureDevices,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var devices = snapshot.data!;
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return Card( // Wrap each ListTile with a Card
                margin: const EdgeInsets.all(20.0), // Increase margin around each card
                elevation: 8, // Increase elevation for more pronounced shadow
                child: ListTile(
                  title: Text(devices[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Protocol: ${devices[index].protocol}\n"
                              "${devices[index].webhook.isNotEmpty ? 'Webhook: ${devices[index].webhook}\n' : ''}"
                              "Max Hours: ${devices[index].maxHours}\n"
                      ),
                      const Text('Active Hours:'),
                      SleepHourBar(
                        sleepHours: devices[index].sleepHours,
                        activeColor: Colors.green,
                      ),
                      const Text('Active Hours Weekend:'),
                      SleepHourBar(
                        sleepHours: devices[index].sleepHoursWeekend,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}