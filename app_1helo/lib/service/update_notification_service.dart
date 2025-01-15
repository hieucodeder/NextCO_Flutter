import 'dart:convert';
import 'package:app_1helo/model/body_notification_update.dart';
import 'package:app_1helo/model/update_notification.dart';
import 'package:app_1helo/service/api_config.dart';
import 'package:http/http.dart' as http;

Future<UpdateNotification?> fetchNotificationUpdate({
  required String notifyId, // Đầu vào chính
  required bool isRead, // Trạng thái đọc
  required String senderId, // ID của người gửi
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

  // Tạo đối tượng `BodyNotificationUpdate` từ tham số đầu vào
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
    // Chuyển đổi đối tượng `BodyNotificationUpdate` thành JSON
    final body = jsonEncode({
      "notifications": [bodyNotification.toJson()]
    });
    print("Sending request to $apiUrl");
    print("Request body: $body");
    final headers = await ApiConfig.getHeaders();
    // Gửi yêu cầu POST
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    // Kiểm tra kết quả trả về
    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("Request successful. Parsed response: $responseData");
      return UpdateNotification.fromJson(responseData);
    } else {
      // Xử lý lỗi từ server
      print("Failed to fetch data. Status code: ${response.statusCode}");
      print("Response: ${response.body}");
      return null;
    }
  } catch (error) {
    // Bắt lỗi trong quá trình gửi yêu cầu
    print("Error occurred: $error");
    return null;
  }
}
