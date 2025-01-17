import 'dart:convert';
import 'package:app_1helo/model/body_notification_refuse.dart';
import 'package:app_1helo/model/notification_request.dart';
import 'package:app_1helo/service/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<NotificationRequest?> fetchNotificationRefuse({
  int? activeFlag,
  String? content,
  String? createdDateTime,
  String? historyNotificationsId,
  String? reason,
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
    print("User ID not found in SharedPreferences.");
    return null;
  }

  BodyNotificationRefuse bodyNotification = BodyNotificationRefuse(
    activeFlag: activeFlag,
    content: content,
    createdByUserId: userId,
    createdDateTime: createdDateTime,
    historyNotificationsId: historyNotificationsId,
    reason: reason,
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

    print("Request payload: ${jsonEncode(bodyNotification.toJson())}");

    print("Sending request to $apiUrl");
    print("Request body: $body");

    final headers = await ApiConfig.getHeaders();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("Request successful. Parsed response: $responseData");
      return NotificationRequest.fromJson(responseData);
    } else {
      print("Failed to fetch data. Status code: ${response.statusCode}");
      print("Response: ${response.body}");
      return null;
    }
  } catch (error) {
    print("Error occurred: $error");
    return null;
  }
}
