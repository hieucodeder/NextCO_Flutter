import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_1helo/model/body_chatbot_answer.dart';
import 'package:app_1helo/model/chatbot_answer_model.dart';

Future<ChatbotAnswerModel?> fetchApiResponse(
    BodyChatbotAnswer chatbotRequest) async {
  const String apiUrl =
      'https://smartchat.aiacademy.edu.vn/api/chatbot/chatbot-answer';

  try {
    // Log khi bắt đầu gửi yêu cầu
    print("Preparing to send request to API...");
    final requestBody = json.encode(chatbotRequest.toJson());
    print("Request body: $requestBody"); // Log nội dung yêu cầu

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    // Kiểm tra mã trạng thái HTTP
    if (response.statusCode == 200) {
      print("Request was successful. Status code: ${response.statusCode}");

      // Log dữ liệu phản hồi
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print("Response body: $jsonResponse"); // Log nội dung phản hồi

      return ChatbotAnswerModel.fromJson(jsonResponse);
    } else {
      // Log khi yêu cầu không thành công
      print("Failed to fetch data: ${response.statusCode}");
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      print("Error Response: ${errorResponse['message']}"); // Log chi tiết lỗi

      if (errorResponse['message'] == 'Chatbot Code not found') {
        print("Error: Chatbot code is invalid or not found.");
      }
      return null; // Trả về null khi có lỗi
    }
  } catch (e) {
    // Log khi có lỗi xảy ra
    print("Error occurred: $e");
    return null;
  }
}
