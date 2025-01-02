import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static String? domain;

  static const String _defaultDomain = 'https://demo.nextco.vn';

  static Future<void> loadDomain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    domain = prefs.getString('selectedDomain') ?? _defaultDomain;
  }

  static String get baseUrlBasic {
    return '${domain ?? _defaultDomain}/api/';
  }

  static String get baseUrl {
    return '${domain ?? _defaultDomain}/api/api-co';
  }

  static String get baseUrl1 {
    return '${domain ?? _defaultDomain}/api/api-core';
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> getHeaders() async {
    String? token = await getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}
