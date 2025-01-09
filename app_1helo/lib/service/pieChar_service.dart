import 'dart:convert';
import 'dart:io';
import 'package:app_1helo/model/body_search_piechar.dart';
import 'package:app_1helo/model/dropdown_employee.dart';
import 'package:app_1helo/model/piechar_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class PiecharService {
  final String apiUrl = '${ApiConfig.baseUrl}/co-documents/dashboard';

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
        final responseBody = jsonDecode(response.body);

        if (responseBody is List) {
          return responseBody
              .map(
                  (data) => PieCharModel.fromJson(data as Map<String, dynamic>))
              .toList();
        } else if (responseBody is Map<String, dynamic>) {
          if (responseBody.containsKey('data') &&
              responseBody['data'] is List) {
            return (responseBody['data'] as List)
                .map((data) =>
                    PieCharModel.fromJson(data as Map<String, dynamic>))
                .toList();
          } else {}
        } else {}
      } else {}
      // ignore: empty_catches
    } catch (error) {}

    return [];
  }

  // Fetches a list of employees for dropdown
  Future<List<DropdownEmployee>> fetchEmployeeList() async {
    final headers = await ApiConfig.getHeaders();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      return [];
    }

    final String employeeApiUrl =
        '${ApiConfig.baseUrl}/employees/dropdown-employeeid/$userId';

    try {
      final response =
          await http.get(Uri.parse(employeeApiUrl), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => DropdownEmployee.fromJson(json)).toList();
      } else {}
      // ignore: empty_catches
    } catch (error) {}
    return [];
  }

  // Fetches data for a specific employee based on full name
  Future<void> fetchDataForUser(String fullName) async {
    List<DropdownEmployee> employees = await fetchEmployeeList();
    String employeeId = getEmployeeIdByFullName(fullName, employees);

    if (employeeId.isNotEmpty) {
      final List<PieCharModel>? response =
          await fetchPieChartData(null, null, employeeId, null);
      if (response != null && response.isNotEmpty) {
      } else {}
    } else {}
  }

  // Helper to get employee ID by full name
  String getEmployeeIdByFullName(
      String fullName, List<DropdownEmployee> employees) {
    for (var employee in employees) {
      if (employee.label == fullName) {
        return employee.value ?? '';
      }
    }
    return '';
  }

  Future<List<PieCharModel>> searchByDateRange(
    DateTime? startDate,
    DateTime? endDate,
    String? employeeId,
    String? customerId,
  ) async {
    final url = Uri.parse(apiUrl);

    try {
      // Prepare headers
      final headers = await ApiConfig.getHeaders();

      // Create request body
      final requestBody = Bodysearchpiechar(
        customerId: customerId,
        employeeId: employeeId,
        frCreatedDate: startDate,
        toCreatedDate: endDate,
      );

      // Logging request details
      print('Sending POST request to $url with body: ${requestBody.toJson()}');

      // Make the POST request
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      // Log response details
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map && jsonResponse.containsKey('message')) {
          if (jsonResponse['message'] == 'Không có kết quả!') {
            print('No results found: ${jsonResponse['message']}');
            return [];
          }
        }

        if (jsonResponse is Map && jsonResponse.containsKey('data')) {
          final data = jsonResponse['data'];
          if (data is List) {
            return data.map((item) => PieCharModel.fromJson(item)).toList();
          } else {
            throw FormatException('Unexpected data format in response.');
          }
        } else {
          throw FormatException(
              'Response does not contain expected "data" field.');
        }
      } else {
        throw HttpException(
          'Failed to load data. Status Code: ${response.statusCode}, Response: ${response.body}',
        );
      }
    } catch (error, stackTrace) {
      print('Error occurred: $error');
      print('Stack Trace: $stackTrace');
      return [];
    }
  }
}
