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

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        LinecharModel lineChartResponse = LinecharModel.fromJson(jsonData);
        return lineChartResponse;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<List<dropdownEmployee>> fetchEmployeeList() async {
    final headers = await ApiConfig.getHeaders();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      return [];
    }

    // Remove 'const' because userId is not a constant value
    final String employeeApiUrl =
        '${ApiConfig.baseUrl}/employees/dropdown-employeeid/$userId';

    try {
      final response =
          await http.get(Uri.parse(employeeApiUrl), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => dropdownEmployee.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<void> fetchDataForUser(String fullName) async {
    List<dropdownEmployee> employees = await fetchEmployeeList();

    String employeeId = getEmployeeIdByFullName(fullName, employees);

    if (employeeId.isNotEmpty) {
      final LinecharModel? response =
          await fetchLineChartData(employeeId, null);
      if (response != null) {
      } else {}
    } else {}
  }

  String getEmployeeIdByFullName(
      String fullName, List<dropdownEmployee> employees) {
    for (var employee in employees) {
      if (employee.label == fullName) {
        return employee.value ?? '';
      }
    }
    return '';
  }
}
