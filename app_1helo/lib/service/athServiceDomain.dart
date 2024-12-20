import 'dart:convert';
import 'package:app_1helo/model/bodyUser.dart';
import 'package:app_1helo/model/userDomainModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Athservicedomain {
  static const String _baseUrl = "https://nextco.vn/api/user-mobile";

  Future<Map<String, dynamic>?> login(Bodyuser bodyUser) async {
    final url = Uri.parse("$_baseUrl/login");
    print('API login URL: $url'); // Log the login URL
    try {
      // Make the POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(bodyUser.toJson()),
      );

      // Log the status code and response body
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body
        final jsonResponse = json.decode(response.body);

        // Log the parsed JSON response
        print('Parsed JSON Response: $jsonResponse');

        // You can directly return the full JSON response from the API here.
        return jsonResponse;
      } else {
        // Handle login failure and print the error
        print("Login failed: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      // Log any exceptions
      print("Error during login: $e");
      return null;
    }
  }

  // Lấy thông tin tài khoản từ SharedPreferences
  Future<Userdomainmodel?> getAccountInfo() async {
    final prefs = await SharedPreferences.getInstance();

    // Kiểm tra thông tin đã lưu trong SharedPreferences
    final username = prefs.getString('username');
    final password = prefs.getString('password');
    final subdomain = prefs.getString('subdomain');

    if (username != null && password != null && subdomain != null) {
      return Userdomainmodel(
        username: username,
        password: password,
        subdomain: subdomain,
      );
    }
    return null;
  }
}
