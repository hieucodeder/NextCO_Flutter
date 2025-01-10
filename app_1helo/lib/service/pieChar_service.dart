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
      // Chuẩn bị headers
      final headers = await ApiConfig.getHeaders();

      // Tạo body cho request
      final requestBody = Bodysearchpiechar(
        customerId: customerId,
        employeeId: employeeId,
        frCreatedDate: startDate,
        toCreatedDate: endDate,
      );

      // Ghi log thông tin request
      print('Sending POST request to $url with body: ${requestBody.toJson()}');

      // Gửi request POST
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      // Ghi log thông tin phản hồi
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse JSON response
        final List<dynamic> jsonData = jsonDecode(response.body);

        // Chuyển đổi từng phần tử thành PieCharModel
        List<PieCharModel> listPieCharModel =
            jsonData.map((item) => PieCharModel.fromJson(item)).toList();

        return listPieCharModel;
      } else {
        // Ném lỗi nếu không thành công
        throw HttpException(
          'Failed to load data. Status Code: ${response.statusCode}, Response: ${response.body}',
        );
      }
    } catch (error, stackTrace) {
      // Xử lý lỗi và ghi log
      print('Error occurred: $error');
      print('Stack Trace: $stackTrace');
      return [];
    }
  }
}
