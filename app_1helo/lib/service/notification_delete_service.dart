import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_1helo/model/body_notification_delete.dart';
import 'package:app_1helo/model/notification_request.dart';
import 'package:app_1helo/service/api_config.dart';

Future<NotificationRequest?> fetchNotificationRequest({
  required List<String> notificationIds,
}) async {
  final String apiUrl = '${ApiConfig.baseUrlChat}/notify/delete-notify';

  BodyNotificationDelete bodyNotification = BodyNotificationDelete(
    notifications: notificationIds,
  );

  try {
    final body = jsonEncode(bodyNotification.toJson());

    final headers = await ApiConfig.getHeaders();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return NotificationRequest.fromJson(responseData);
    } else {
      return null;
    }
  } catch (error) {
    return null;
  }
}
