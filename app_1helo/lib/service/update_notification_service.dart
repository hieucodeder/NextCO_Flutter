import 'dart:convert';
import 'package:app_1helo/model/body_notification_update.dart';
import 'package:app_1helo/model/update_notification.dart';
import 'package:app_1helo/service/api_config.dart';
import 'package:http/http.dart' as http;

Future<UpdateNotification?> fetchNotificationUpdate({
  required String notifyId,
  required bool isRead,
  required String senderId,
  String? recordCount,
  int? rowNumber,
  int? accessCoDetail,
  int? activeFlag,
  String? content,
  String? createdDateTime,
  String? customerName,
  String? historyNotificationsId,
  int? isReceived,
  String? reason,
  int? requestType,
  String? sender,
  String? target,
}) async {
  final String apiUrl = '${ApiConfig.baseUrlChat}/notify/update-notify';

  BodyNotificationUpdate bodyNotification = BodyNotificationUpdate(
    recordCount: recordCount,
    rowNumber: rowNumber,
    accessCoDetail: accessCoDetail,
    activeFlag: activeFlag,
    content: content,
    createdDateTime: createdDateTime,
    customerName: customerName,
    historyNotificationsId: historyNotificationsId,
    isRead: isRead,
    isReceived: isReceived,
    notifyId: notifyId,
    reason: reason,
    requestType: requestType,
    sender: sender,
    senderId: senderId,
    target: target,
  );

  try {
    final body = jsonEncode({
      "notifications": [bodyNotification.toJson()]
    });
    final headers = await ApiConfig.getHeaders();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return UpdateNotification.fromJson(responseData);
    } else {
      return null;
    }
  } catch (error) {
    return null;
  }
}
