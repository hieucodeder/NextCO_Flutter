import 'dart:convert';
import 'package:app_1helo/model/bodySearchPieChar.dart';
import 'package:app_1helo/model/documentss.dart';
import 'package:app_1helo/model/dropdownEmployee.dart';
import 'package:app_1helo/model/pieCharModel.dart';
import 'package:app_1helo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class PiecharService {
  final String apiUrl =
      '${ApiConfig.baseUrlBasic}/api-co/co-documents/dashboard';

  // Service to fetch pie chart data
  Future<List<PieCharModel>?> fetchPieChartData(
      String? employeeId, String? customerId) async {
    final url = Uri.parse(apiUrl);
    final Map<String, dynamic> requestBody = {
      if (employeeId != null) "employee_id": employeeId,
      if (customerId != null) "customer_id": customerId,
    };

    try {
      final headers = await ApiConfig.getHeaders();
      print(
          'Fetching pie chart data with employeeId: $employeeId, customerId: $customerId');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body);
        print('Pie chart data fetched successfully. Count: ${dataList.length}');

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
      final List<PieCharModel>? response =
          await fetchPieChartData(employeeId, null);
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

      Bodysearchpiechar requestBody = Bodysearchpiechar(
        customerId: customerId,
        employeeId: employeeId,
        frCreatedDate: startDate,
        toCreatedDate: endDate,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        List<dynamic> data;
        if (jsonResponse is List) {
          data = jsonResponse;
        } else if (jsonResponse is Map) {
          data = [jsonResponse];
        } else {
          throw Exception("Unexpected JSON format");
        }

        // Convert the fetched data into a list of `Data` objects
        List<Data> dataList = data
            .map((item) => Data.fromJson(item as Map<String, dynamic>))
            .toList();

        // Filter the data based on the date range
        List<Data> filteredData = dataList.where((dataItem) {
          DateTime createdDate = DateFormat("yyyy-MM-dd")
              .parse(dataItem.createdDate!); // Parse created date to DateTime

          // Check if the createdDate is within the provided date range
          bool isAfterStartDate =
              startDate != null ? createdDate.isAfter(startDate) : true;
          bool isBeforeEndDate =
              endDate != null ? createdDate.isBefore(endDate) : true;

          return isAfterStartDate && isBeforeEndDate;
        }).toList();

        // Convert the filtered data into PieCharModel
        return filteredData.map((item) {
          return PieCharModel(
            statusId: item.statusId,
            quantity:
                item.result, // Assuming quantity comes from `result` or similar
          );
        }).toList();
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
