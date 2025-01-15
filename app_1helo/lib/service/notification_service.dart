import 'dart:convert';
import 'package:app_1helo/model/notification_feedback.dart';
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
      // Tạo URL và header
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      // Lấy userId từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      // Tạo request body
      BodyNotification requestBody = BodyNotification(
        pageIndex: page,
        pageSize: pageSize,
        userId: userId,
      );

      // Gửi POST request
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );
      print("Response body: ${response.body}");
      // Kiểm tra trạng thái phản hồi
      if (response.statusCode == 200) {
        // Chuyển đổi phản hồi JSON
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final NotificationModel notificationModelData =
            NotificationModel.fromJson(jsonResponse);

        // Trả về danh sách `Data`
        return notificationModelData.data ?? [];
      } else {
        throw Exception(
            'Failed to load materials. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      return []; // Trả về danh sách trống trong trường hợp lỗi
    }
  }

  Future<void> sendNotificationFeedback(
      NotificationFeedback feedback, String responseMessage) async {
    final url = Uri.parse(apiUrl1);

    try {
      // Chuẩn bị dữ liệu request từ feedback và thêm responseMessage
      final requestData = {
        ...feedback.toJson(),
        'response': responseMessage,
      };

      // Log dữ liệu request
      print("Sending feedback data: ${json.encode(requestData)}");

      // Gửi POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      // Log kết quả phản hồi từ server
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['success'] == true) {
          print("Phản hồi thành công: ${responseBody['message']}");
        } else {
          print("Phản hồi thất bại: ${responseBody['message']}");
        }
      } else {
        print("Lỗi server: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Lỗi kết nối: $e");
    }
  }
}
