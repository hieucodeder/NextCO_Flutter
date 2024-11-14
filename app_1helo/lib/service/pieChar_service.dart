import 'dart:convert';
import 'package:app_1helo/model/bodySearchPieChar.dart';
import 'package:app_1helo/model/dropdownEmployee.dart';
import 'package:app_1helo/model/pieCharModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class PiecharService {
  final String apiUrl =
      '${ApiConfig.baseUrlBasic}/api-co/co-documents/dashboard';

  // Fetches pie chart data
  Future<List<PieCharModel>?> fetchPieChartData(DateTime? startDate,
      DateTime? endDate, String? employeeId, String? customerId) async {
    final url = Uri.parse(apiUrl);
    final Map<String, dynamic> requestBody = {
      if (employeeId != null) "employee_id": employeeId,
      if (customerId != null) "customer_id": customerId,
      if (startDate != null)
        "start_date": DateFormat('yyyy-MM-dd').format(startDate),
      if (endDate != null) "end_date": DateFormat('yyyy-MM-dd').format(endDate),
    };

    try {
      final headers = await ApiConfig.getHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body);
        return dataList
            .map((data) => PieCharModel.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        print(
            'Failed to fetch pie chart data. Status code: ${response.statusCode}, body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching pie chart data: $error');
    }

    return [];
  }

  // Fetches a list of employees for dropdown
  Future<List<dropdownEmployee>> fetchEmployeeList() async {
    final headers = await ApiConfig.getHeaders();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      print('No user ID found. User might not be logged in.');
      return [];
    }

    final String employeeApiUrl =
        '${ApiConfig.baseUrl}/employees/dropdown-employeeid/$userId';

    try {
      final response =
          await http.get(Uri.parse(employeeApiUrl), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => dropdownEmployee.fromJson(json)).toList();
      } else {
        print(
            'Failed to fetch employee list. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching employees: $error');
    }
    return [];
  }

  // Fetches data for a specific employee based on full name
  Future<void> fetchDataForUser(String fullName) async {
    print('Fetching data for user: $fullName');

    List<dropdownEmployee> employees = await fetchEmployeeList();
    String employeeId = getEmployeeIdByFullName(fullName, employees);

    if (employeeId.isNotEmpty) {
      final List<PieCharModel>? response =
          await fetchPieChartData(null, null, employeeId, null);
      if (response != null && response.isNotEmpty) {
        print(
            'Pie chart data fetched successfully for employeeId: $employeeId');
      } else {
        print('No pie chart data found for employeeId: $employeeId');
      }
    } else {
      print('Employee ID is empty for full name: $fullName');
    }
  }

  // Helper to get employee ID by full name
  String getEmployeeIdByFullName(
      String fullName, List<dropdownEmployee> employees) {
    for (var employee in employees) {
      if (employee.label == fullName) {
        return employee.value ?? '';
      }
    }
    print('No employee found for full name: $fullName');
    return '';
  }

  Future<List<PieCharModel>> searchByDateRange(DateTime? startDate,
      DateTime? endDate, String? employeeId, String? customerId) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      final requestBody = Bodysearchpiechar(
        customerId: customerId,
        employeeId: employeeId,
        frCreatedDate: startDate,
        toCreatedDate: endDate,
      );

      // Log the request body to ensure it's correctly formed
      print('Request Body: ${jsonEncode(requestBody.toJson())}');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      // Log the status code and response body for debugging
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is Map) {
          final message = jsonResponse['message'];
          if (message == 'Không có kết quả!') {
            print('API Message: $message');
            return [];
          }

          if (jsonResponse.containsKey('data')) {
            List<dynamic> data = jsonResponse['data'];
            return data
                .map((jsonItem) => PieCharModel.fromJson(jsonItem))
                .toList();
          } else {
            throw Exception('No data found in the response.');
          }
        } else {
          throw Exception('Unexpected response format.');
        }
      } else {
        print('Failed to load documents: ${response.body}');
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error searching documents by date range: $error');
      return [];
    }
  }
}
