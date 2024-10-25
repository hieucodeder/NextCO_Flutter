import 'dart:convert';
import 'package:app_1helo/model/lineCharModel.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class LineChartService {
  final String apiUrl =
      '${ApiConfig.baseUrlBasic}/api-co/statistics/get-dashboard-co';

  Future<LinecharModel?> fetchLineChartData(
      String employeeId, String customerId) async {
    final url = Uri.parse(apiUrl);

    final Map<String, dynamic> requestBody = {
      "employee_id": "a80f412c-73cc-40be-bc12-83c201cb2c4d",
      "customer_id": null,
    };

    try {
      final headers = await ApiConfig.getHeaders();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        LinecharModel lineChartResponse = LinecharModel.fromJson(jsonData);
        print('Success: ${lineChartResponse.success}');
        return lineChartResponse;
      } else {
        print(
            'Error: Response not successful, Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching line chart data: $error');
      return null;
    }
  }
  Future<LinecharModel?> fetchLineChartDemoCustomer(
      String employeeId, String customerId) async {
    final url = Uri.parse(apiUrl);

    final Map<String, dynamic> requestBody = {
      "employee_id": "2d89931f-2694-414a-95f2-0433c559d5fe",
      "customer_id": null,
    };

    try {
      final headers = await ApiConfig.getHeaders();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        LinecharModel lineChartResponse = LinecharModel.fromJson(jsonData);
        print('Success: ${lineChartResponse.success}');
        return lineChartResponse;
      } else {
        print(
            'Error: Response not successful, Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching line chart data: $error');
      return null;
    }
  }
}
