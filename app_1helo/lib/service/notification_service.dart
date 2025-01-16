import 'dart:convert';
import 'package:app_1helo/model/notification_request.dart';
import 'package:http/http.dart' as http;
import 'package:app_1helo/model/body_notification.dart';
import 'package:app_1helo/service/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/notification_model.dart';

class NotificationService {
  final String apiUrl = '${ApiConfig.baseUrlChat}/notify/search-notify';
  final String apiUrl1 =
      '${ApiConfig.baseUrlChat}/notify/send-document-request';

  Future<List<Data>> fetchNotification(int page, int pageSize) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      BodyNotification requestBody = BodyNotification(
        pageIndex: page,
        pageSize: pageSize,
        userId: userId,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final NotificationModel notificationModelData =
            NotificationModel.fromJson(jsonResponse);

        return notificationModelData.data ?? [];
      } else {
        throw Exception(
            'Failed to load materials. Status code: ${response.statusCode}');
      }
    } catch (error) {
      return [];
    }
  }

  Future<void> sendNotificationFeedback(
      NotificationRequest feedback, String responseMessage) async {
    final url = Uri.parse(apiUrl1);

    try {
      final requestData = {
        ...feedback.toJson(),
        'response': responseMessage,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['success'] == true) {
        } else {}
      } else {}
    } catch (e) {}
  }
}
