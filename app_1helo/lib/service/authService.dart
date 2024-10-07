import 'dart:convert';
import 'package:app_1helo/model/acount.dart';
import 'package:app_1helo/model/bodylogin.dart';
import 'package:app_1helo/service/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<Map<String, dynamic>?> login(Bodylogin loginData) async {
    final url = Uri.parse('${ApiConfig.baseUrlBasic}/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(loginData.toJson()),
      );

      print('Response Status: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        Acount account = Acount.fromJson(jsonResponse);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', account.userId!);
        await prefs.setString('token', account.token!);

        return {
          'account': account,
          'token': account.token,
        };
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
