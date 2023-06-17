import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'devices_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PVPC Cheap',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? token;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        token = prefs.getString('token');
      });
    });
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        if (token != null && token!.isNotEmpty) {
          return FutureBuilder<String?>(
            future: SharedPreferences.getInstance().then((prefs) => prefs.getString('username')),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.hasData) {
                return Center(child: Text('Hi!, ${snapshot.data}'));
              } else {
                return const Center(child: Text('Error trying to get username'));
              }
            },
          );
        } else {
          return LoginScreen(
            onLogin: (receivedToken) {
              setState(() {
                token = receivedToken;
                _selectedIndex = 1;  // Change to devices screen
              });
            },
          );
        }
      case 1:
        if (token != null && token!.isNotEmpty) {
          return DevicesScreen(token: token!);
        } else {
          return const Center(child: Text("Please login first to see devices"));
        }
      default:
        return const Center(child: Text('Welcome'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PVPC Cheap'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Devices'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Config'),
              onTap: () {
                // TODO: Navegar a la pantalla de configuración
              },
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedIndex),
    );
  }
}
