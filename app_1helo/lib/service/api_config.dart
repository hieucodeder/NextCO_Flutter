import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static String? domain;

  // Define the default base URL
  static const String _defaultDomain = 'https://demo.nextco.vn';
// Fetch the domain from SharedPreferences
  static Future<void> loadDomain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    domain = prefs.getString('selectedDomain') ?? _defaultDomain;
  }

  // Get the base URL for the basic API
  static String get baseUrlBasic {
    return '${domain ?? _defaultDomain}/api/';
  }

  // Get the base URL for api-co
  static String get baseUrl {
    return '${domain ?? _defaultDomain}/api/api-co';
  }

  // Get the base URL for api-core
  static String get baseUrl1 {
    return '${domain ?? _defaultDomain}/api/api-core';
  }

  // Fetch the token from SharedPreferences
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get the headers for API requests, including authorization token if available
  static Future<Map<String, String>> getHeaders() async {
    String? token = await getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}
