import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/dropdownBranchs.dart';
import 'package:app_1helo/model/lineCharModel.dart';
import 'package:app_1helo/model/user.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class UserService {
  final String apiUrl = '${ApiConfig.baseUrl1}/users/search';

  Future<List<DataUser>> fetchUsers() async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      Body requestBody = Body(
        searchContent: "",
        pageIndex: 1,
        pageSize: 10,
        frCreatedDate: null,
        toCreatedDate: null,
        employeeId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
        customerId: null,
        userId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final User userData = User.fromJson(jsonResponse);
        return userData.data ?? [];
      } else {
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error fetching documents: $error');
      return [];
    }
  }

  Future<List<DataUser>> searchUser(String searchContent) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      Body requestBody = Body(
        searchContent: searchContent,
        pageIndex: 1,
        pageSize: 10,
        frCreatedDate: null,
        toCreatedDate: null,
        employeeId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
        customerId: null,
        userId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final User userData = User.fromJson(jsonResponse);

        return userData.data ?? [];
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (error) {
      print('Error fetching customers: $error');
      return [];
    }
  }

  Future<User?> fetchUserData(
      String? branchName, String? departmentName) async {
    final url = Uri.parse(apiUrl);

    Body requestBody = Body(
      searchContent: branchName ?? departmentName,
      pageIndex: 1,
      pageSize: 10,
      frCreatedDate: null,
      toCreatedDate: null,
      employeeId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
      customerId: null,
      userId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
    );

    if (branchName != null && departmentName != null) {
      requestBody.searchContent = '$branchName $departmentName';
    }

    try {
      final headers = await ApiConfig.getHeaders();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        User userResponse = User.fromJson(jsonData);
        print('Total Items: ${userResponse.totalItems}');

        return userResponse;
      } else {
        print('Failed to load user data, Status Code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching user data: $error');
      return null;
    }
  }
//  Future<List<Dropdownbranchs>> fetchEmployeeList() async {
//     const String employeeApiUrl =
//         '${ApiConfig.baseUrl}/employees/dropdown-employeeid/a80f412c-73cc-40be-bc12-83c201cb2c4d';
//     final headers = await ApiConfig.getHeaders();

//     try {
//       print('Fetching employee list from API: $employeeApiUrl');
//       final response =
//           await http.get(Uri.parse(employeeApiUrl), headers: headers);

//       print('Employee list response status: ${response.statusCode}');
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = jsonDecode(response.body);
//         print('Employee list fetched successfully. Count: ${jsonData.length}');
//         return jsonData.map((json) => Dropdownbranchs.fromJson(json)).toList();
//       } else {
//         print(
//             'Failed to fetch employee list. Status code: ${response.statusCode}');
//         return [];
//       }
//     } catch (error) {
//       print('Error fetching employees: $error');
//       return [];
//     }
//   }

//   // Fetch data for user based on full name
//   Future<void> fetchDataForUser(String fullName) async {
//     print('Fetching data for user: $fullName');

//     List<Dropdownbranchs> employees = await fetchEmployeeList();
//     String employeeId = getEmployeeIdByFullName(fullName, employees);
//     print('Retrieved employeeId: $employeeId for full name: $fullName');

//     if (employeeId.isNotEmpty) {
//       final List<Dropdownbranchs>? response =
//           await fetchTotalItemsUsers(employeeId, null, null, null);
//       if (response != null && response.isNotEmpty) {
//         print(
//             'Pie chart data fetched successfully for employeeId: $employeeId');
//         // Process the pie chart data as needed
//       } else {
//         print('No pie chart data found for employeeId: $employeeId');
//       }
//     } else {
//       print('Employee ID is empty for full name: $fullName');
//     }
//   }

//   // Method to get Employee ID by full name from the dynamically fetched employee list
//   String getEmployeeIdByFullName(
//       String fullName, List<dropdownEmployee> employees) {
//     for (var employee in employees) {
//       if (employee.label == fullName) {
//         return employee.value ?? '';
//       }
//     }
//     print('No employee found for full name: $fullName');
//     return '';
//   }
}
