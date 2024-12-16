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
    final url = Uri.parse('${ApiConfig.baseUrlBasic}login');
    print('Đây là api login: $url');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(loginData.toJson()),
      );

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
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Account?> getAccountInfo() async {
    final headers = await ApiConfig.getHeaders();

    if (!headers.containsKey('Authorization')) {
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
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
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<dropdownEmployee>?> getEmployeeInfo() async {
    final headers = await ApiConfig.getHeaders();

    if (!headers.containsKey('Authorization')) {
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
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
        return null;
      }
    } catch (e) {
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
        return Future.error(
            'Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      return Future.error('Exception: $e');
    }
  }

  Future<List<Dropdownbranchs>?> getBranchsInfo() async {
    final headers = await ApiConfig.getHeaders();

    if (!headers.containsKey('Authorization')) {
      return Future.error('No token found. User not logged in.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/branchs/dropdown');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        // Log the entire JSON response

        List<Dropdownbranchs> dropdownBranchList =
            jsonResponse.map((item) => Dropdownbranchs.fromJson(item)).toList();

        // Log the parsed list
        return dropdownBranchList;
      } else {
        return Future.error(
            'Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      return Future.error('Exception: $e');
    }
  }
}
