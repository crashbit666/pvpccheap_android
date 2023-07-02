import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'electricity_price_screen.dart';
import 'login_screen.dart';
import 'devices_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PVPC Cheap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: MainScreen(toggleTheme: toggleTheme),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const MainScreen({required this.toggleTheme, Key? key}) : super(key: key);

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
      case 2:
        if (token != null && token!.isNotEmpty) {
          return ElectricityPriceScreen(token: token!);
        } else {
          return const Center(child: Text("Please login first to see electricity prices"));
        }
      default:
        return const Center(child: Text('Select a menu option'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PVPC Cheap'),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
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
                    title: const Text('PVPC Prices'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Toggle Theme'),
                    onTap: () {
                      widget.toggleTheme();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            if (token != null && token!.isNotEmpty)
              ListTile(
                title: const Text('Logout'),
                onTap: () {
                  // Remove token
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.remove('token');
                  });
                  setState(() {
                    token = null;
                    _selectedIndex = 0;  // Redirect to login page
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedIndex),
    );
  }
}
