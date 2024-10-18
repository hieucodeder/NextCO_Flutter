import 'dart:convert';
import 'package:app_1helo/model/pieCharModel.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class PiecharService {
  final String apiUrl =
      '${ApiConfig.baseUrlBasic}/api-co/co-documents/dashboard';

  Future<PieCharModel?> fetchPieChartData(String employeeId, String customerId,
      String fromDate, String toDate) async {
    final url = Uri.parse(apiUrl);

    final Map<String, dynamic> requestBody = {
      "fr_created_date": fromDate,
      "to_created_date": toDate,
      "customer_id": customerId.isNotEmpty ? customerId : null,
      "employee_id": employeeId.isNotEmpty ? employeeId : null
    };

    try {
      final headers = await ApiConfig.getHeaders();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );
      // log lỗi
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return PieCharModel.fromJson(jsonData);
      } else {
        // Handle other response codes
        print(
            'Error: Response not successful, Status code: ${response.statusCode}. Response Body: ${response.body}');
        return null;
      }
    } catch (error) {
      // Handle and log any errors
      print('Error fetching pie chart data: $error');
      return null;
    }
  }
}
