import 'dart:convert';
import 'package:app_1helo/model/dropdownEmployee.dart';
import 'package:app_1helo/model/lineCharModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class LineChartService {
  final String apiUrl = '${ApiConfig.baseUrl}/statistics/get-dashboard-co';

  Future<LinecharModel?> fetchLineChartData(
      String? employeeId, String? customerId) async {
    final url = Uri.parse(apiUrl);
    final Map<String, dynamic> requestBody = {
      "employee_id": employeeId,
      "customer_id": customerId,
    };

    try {
      final headers = await ApiConfig.getHeaders();
      print(
          'Fetching line chart data with employeeId: $employeeId and customerId: $customerId');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        LinecharModel lineChartResponse = LinecharModel.fromJson(jsonData);
        print('Success: ${lineChartResponse.success}');
        return lineChartResponse;
      } else {
        print(
            'Failed to fetch line chart data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching line chart data: $error');
      return null;
    }
  }

  Future<List<dropdownEmployee>> fetchEmployeeList() async {
    final headers = await ApiConfig.getHeaders();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      print('No user ID found. User might not be logged in.');
      return [];
    }

    // Remove 'const' because userId is not a constant value
    final String employeeApiUrl =
        '${ApiConfig.baseUrl}/employees/dropdown-employeeid/$userId';

    try {
      print('Fetching employee list from API: $employeeApiUrl');
      final response =
          await http.get(Uri.parse(employeeApiUrl), headers: headers);

      print('Employee list response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        print('Employee list fetched successfully. Count: ${jsonData.length}');
        return jsonData.map((json) => dropdownEmployee.fromJson(json)).toList();
      } else {
        print(
            'Failed to fetch employee list. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching employees: $error');
      return [];
    }
  }

  Future<void> fetchDataForUser(String fullName) async {
    print('Fetching data for user: $fullName');

    List<dropdownEmployee> employees = await fetchEmployeeList();

    String employeeId = getEmployeeIdByFullName(fullName, employees);
    print('Retrieved employeeId: $employeeId for full name: $fullName');

    if (employeeId.isNotEmpty) {
      final LinecharModel? response =
          await fetchLineChartData(employeeId, null);
      if (response != null) {
        print(
            'Line chart data fetched successfully for employeeId: $employeeId');
      } else {
        print('Failed to fetch line chart data for employeeId: $employeeId');
      }
    } else {
      print('Employee ID is empty for full name: $fullName');
    }
  }

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
}
