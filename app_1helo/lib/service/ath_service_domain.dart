import 'dart:convert';
import 'package:app_1helo/model/bodyUser.dart';
import 'package:app_1helo/model/user_domain_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Athservicedomain {
  static const String _baseUrl = "https://nextco.vn/api/user-mobile";

  Future<Map<String, dynamic>?> login(Bodyuser bodyUser) async {
    final url = Uri.parse("$_baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(bodyUser.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        return jsonResponse;
      } else {
        return null;
      }
    } catch (e) {
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
