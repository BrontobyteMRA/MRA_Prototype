import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String loginUrl = 'https://mra3.onebrain.me/api/login.php';
  static const String metersUrl = 'https://mra3.onebrain.me/api/get_assigned_meters.php';
  static const String submitUrl = 'https://mra3.onebrain.me/api/submit_reading.php';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  static Future<List<dynamic>> fetchMeters(String token) async {
    final response = await http.get(
      Uri.parse(metersUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch meters');
    }
  }

  static Future<bool> submitReading(String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(submitUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }
}