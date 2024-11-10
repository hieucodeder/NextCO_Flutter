import 'dart:convert';
import 'package:app_1helo/model/account.dart';
import 'package:app_1helo/model/bodylogin.dart';
import 'package:app_1helo/model/dropdownBranchs.dart';
import 'package:app_1helo/model/dropdownCustomer.dart';
import 'package:app_1helo/model/dropdownEmployee.dart';
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

    final url = Uri.parse(
        '${ApiConfig.baseUrl1}/users/getbyid/a80f412c-73cc-40be-bc12-83c201cb2c4d');

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

    final url = Uri.parse(
        '${ApiConfig.baseUrl}/employees/dropdown-employeeid/a80f412c-73cc-40be-bc12-83c201cb2c4d');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        List<dropdownEmployee> dropdownemploye = jsonResponse
            .map((item) => dropdownEmployee.fromJson(item))
            .toList();
        return dropdownemploye;
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

    final url = Uri.parse(
        '${ApiConfig.baseUrl1}/users/getbyid/a80f412c-73cc-40be-bc12-83c201cb2c4d');

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

  Future<List<Dropdownbranchs>?> getBranchsInfo() async {
    final headers = await ApiConfig.getHeaders();

    if (!headers.containsKey('Authorization')) {
      print('No token found. User not logged in.');
      return null;
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/branchs/dropdown');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        List<Dropdownbranchs> dropdowbranchs =
            jsonResponse.map((item) => Dropdownbranchs.fromJson(item)).toList();
        return dropdowbranchs;
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
