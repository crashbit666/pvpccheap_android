import 'package:flutter/material.dart';
import 'package:pvpccheap/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String) onLogin;

  const LoginScreen({Key? key, required this.onLogin}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Insert your username';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please, insert your password';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _login,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
            Text(_errorMessage),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      var apiClient = ApiClient(baseUrl: 'http://127.0.0.1:5000');
      try {
        String token = await apiClient.login(
          _usernameController.text,
          _passwordController.text,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('username',
            _usernameController.text); // Save username
        widget.onLogin(token);
      } catch (e) {
        setState(() {
          _errorMessage = 'Error trying to initialize session: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
