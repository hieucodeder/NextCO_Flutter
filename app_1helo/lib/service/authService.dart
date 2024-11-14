import 'dart:convert';
import 'package:app_1helo/model/account.dart';
import 'package:app_1helo/model/bodylogin.dart';
import 'package:app_1helo/model/dropdownBranchs.dart';
import 'package:app_1helo/model/dropdownCustomer.dart';
import 'package:app_1helo/model/dropdownEmployee.dart';
import 'package:app_1helo/model/dropdownRoom.dart';
import 'package:app_1helo/service/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<Map<String, dynamic>?> login(Bodylogin loginData) async {
    final url = Uri.parse('${ApiConfig.baseUrlBasic}/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(loginData.toJson()),
      );

      print('Response Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        Account account = Account.fromJson(jsonResponse);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', account.userId!);
        await prefs.setString('userName', account.userName!);
        await prefs.setString('token', account.token!);

        return {
          'account': account,
          'token': account.token,
        };
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<Account?> getAccountInfo() async {
    final headers = await ApiConfig.getHeaders();

    if (!headers.containsKey('Authorization')) {
      print('No token found. User not logged in.');
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      print('No user ID found. User might not be logged in.');
      return null;
    }

    final url = Uri.parse('${ApiConfig.baseUrl1}/users/getbyid/$userId');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        Account account = Account.fromJson(jsonResponse);

        return account;
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<List<dropdownEmployee>?> getEmployeeInfo() async {
    final headers = await ApiConfig.getHeaders();

    if (!headers.containsKey('Authorization')) {
      print('No token found. User not logged in.');
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      print('No user ID found. User might not be logged in.');
      return null;
    }

    final url =
        Uri.parse('${ApiConfig.baseUrl}/employees/dropdown-employeeid/$userId');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        List<dropdownEmployee> dropdownEmployeeList = jsonResponse
            .map((item) => dropdownEmployee.fromJson(item))
            .toList();
        return dropdownEmployeeList;
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<List<EmployeeCustomer>?> getEmployeeCustomerInfo() async {
    final headers = await ApiConfig.getHeaders();

    if (!headers.containsKey('Authorization')) {
      return null;
    }
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      print('No user ID found. User might not be logged in.');
      return null;
    }
    final url = Uri.parse('${ApiConfig.baseUrl1}/users/getbyid/$userId');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        dropdownCustomer dropdownCustomerInfo =
            dropdownCustomer.fromJson(jsonResponse);
        return dropdownCustomerInfo.employeeCustomer;
      } else {
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<List<Dropdownroom>?> getRoomInfo() async {
    final headers = await ApiConfig.getHeaders();
    if (!headers.containsKey('Authorization')) {
      return Future.error('No token found. User not logged in.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/departments/dropdown');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((item) => Dropdownroom.fromJson(item)).toList();
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return Future.error(
            'Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
      return Future.error('Exception: $e');
    }
  }

  Future<List<Dropdownbranchs>?> getBranchsInfo() async {
    final headers = await ApiConfig.getHeaders();

    if (!headers.containsKey('Authorization')) {
      print('Error: No token found. User not logged in.');
      return Future.error('No token found. User not logged in.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/branchs/dropdown');
    print('Requesting branch dropdown data from $url with headers: $headers');

    try {
      final response = await http.get(url, headers: headers);
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        print('Response body: $jsonResponse'); // Log the entire JSON response

        List<Dropdownbranchs> dropdownBranchList =
            jsonResponse.map((item) => Dropdownbranchs.fromJson(item)).toList();

        print(
            'Parsed dropdown branch list: $dropdownBranchList'); // Log the parsed list
        return dropdownBranchList;
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return Future.error(
            'Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception caught during branch info fetching: $e');
      return Future.error('Exception: $e');
    }
  }
}
