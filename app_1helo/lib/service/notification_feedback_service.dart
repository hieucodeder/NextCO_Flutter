// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<void> sendNotificationFeedback(
//     Map<String, dynamic> feedbackData, String responseMessage) async {
//   final url =
//       Uri.parse('https://demo.nextco.vn/api-chat/notify/send-document-request');

//   try {
//     // Prepare the request data by merging the feedbackData with the responseMessage
//     final requestData = {
//       ...feedbackData, // Spread the map contents to include all the keys and values
//       'response': responseMessage, // Add the response message to the request
//     };

//     // Log the request data to monitor what is being sent
//     print("Sending feedback data: ${json.encode(requestData)}");

//     // Perform POST request with feedback data and response message
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(
//           requestData), // Send the request data as the body of the POST request
//     );

//     // Log the response status and body for debugging
//     print("Response status: ${response.statusCode}");
//     print("Response body: ${response.body}");

//     if (response.statusCode == 200) {
//       // Successfully sent request
//       final responseBody = json.decode(response.body);

//       // Check for success flag in response
//       if (responseBody['success'] == true) {
//         print("Phản hồi thành công: ${responseBody['message']}");
//       } else {
//         print("Phản hồi thất bại: ${responseBody['message']}");
//       }
//     } else {
//       // Error from server response
//       print("Lỗi server: ${response.statusCode} - ${response.body}");
//     }
//   } catch (e) {
//     // Handle connection errors
//     print("Lỗi kết nối: $e");
//   }
// }
