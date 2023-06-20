import 'package:flutter/material.dart';
import 'package:pvpccheap/services/api_client.dart';
import 'package:pvpccheap/device.dart';

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
              var sleepHours = devices[index].sleepHours.map((sh) => "${sh.hour} : Active? ${sh.isActive}").join(', ');
              var sleepHoursWeekend = devices[index].sleepHoursWeekend.map((sh) => "${sh.hour} : Active? ${sh.isActive}").join(', ');
              return ListTile(
                title: Text(devices[index].name),
                subtitle: Text(
                    "Protocol: ${devices[index].protocol}\n${devices[index].webhook != null ? "Webhook: ${devices[index].webhook}\n" : ""}Max Hours: ${devices[index].maxHours}\nSleep Hours: $sleepHours\nSleep Hours Weekend: $sleepHoursWeekend"
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
