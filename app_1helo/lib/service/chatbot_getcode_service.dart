import 'dart:convert';
import 'package:app_1helo/model/chatbot_getcode.dart';
import 'package:http/http.dart' as http;

Future<ChatbotGetcode?> fetchChatbotGetcode() async {
  const String apiUrl =
      'https://smartchat.aiacademy.edu.vn/api/chatbot/get-by-code/a4db1b36-8e24-4fee-bbef-70ca4413e988';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return ChatbotGetcode.fromJson(jsonData);
    } else {
      print("Failed to load data: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
  return null;
}
