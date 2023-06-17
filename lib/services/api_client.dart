import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pvpccheap/device.dart';

class ApiClient {
  final String baseUrl;
  final String loginEndpoint = "/api/login";
  final String devicesEndpoint = "/api/devices";

  ApiClient({required this.baseUrl});

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl + loginEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String token = data['access_token'];

      return token;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<List<Device>> getDevices(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/devices'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Device.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }
}
