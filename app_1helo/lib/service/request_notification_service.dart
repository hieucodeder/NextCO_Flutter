import 'dart:convert';
import 'package:app_1helo/model/body_notification_request.dart';
import 'package:app_1helo/model/notification_request.dart';
import 'package:app_1helo/service/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<NotificationRequest?> fetchNotificationResquest({
  int? activeFlag,
  String? content,
  String? createdDateTime,
  String? historyNotificationsId,
  bool? isRead,
  bool? isReceived,
  String? receiver,
  int? requestType,
  String? senderId,
  String? target,
  int? type,
}) async {
  final String apiUrl = '${ApiConfig.baseUrlChat}/notify/send-document-request';

  // Lấy userId từ SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  if (userId == null) {
    return null;
  }

  BodyNotificationRequest bodyNotification = BodyNotificationRequest(
    activeFlag: activeFlag,
    content: content,
    createdByUserId: userId,
    createdDateTime: createdDateTime,
    historyNotificationsId: historyNotificationsId,
    isRead: isRead,
    isReceived: isReceived,
    receiver: receiver,
    requestType: requestType,
    senderId: senderId,
    target: target,
    type: type,
  );

  try {
    final body = jsonEncode([bodyNotification.toJson()]);

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
