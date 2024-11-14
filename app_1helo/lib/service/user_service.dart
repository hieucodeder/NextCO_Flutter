import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/bodySearchUser.dart';
import 'package:app_1helo/model/dropdownBranchs.dart';
import 'package:app_1helo/model/lineCharModel.dart';
import 'package:app_1helo/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class UserService {
  final String apiUrl = '${ApiConfig.baseUrl1}/users/search';

  Future<List<DataUser>> fetchUsers(int page, int pageSize) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        print('No user ID found. User might not be logged in.');
        return [];
      }

      Body requestBody = Body(
        searchContent: "",
        pageIndex: page,
        pageSize: pageSize,
        frCreatedDate: null,
        toCreatedDate: null,
        employeeId: null,
        customerId: null,
        userId: userId,
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
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        print('No user ID found. User might not be logged in.');
        return [];
      }

      Body requestBody = Body(
        searchContent: searchContent,
        pageIndex: 1,
        pageSize: 10,
        frCreatedDate: null,
        toCreatedDate: null,
        employeeId: null,
        customerId: null,
        userId: userId,
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

  Future<User?> fetchUserData(int page, int pageSize,
      String? branchName, String? departmentName) async {
    final url = Uri.parse(apiUrl);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      print('No user ID found. User might not be logged in.');
      return null;
    }

    Body requestBody = Body(
      searchContent: branchName ?? departmentName,
      pageIndex: page,
      pageSize: pageSize,
      frCreatedDate: null,
      toCreatedDate: null,
      employeeId: null,
      customerId: null,
      userId: userId,
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

  Future<List<DataUser>> fetchUserData2(
      String? branchName, String? departmentName) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        print('No user ID found. User might not be logged in.');
        return [];
      }

      Bodysearchuser requestBodysearchuser = Bodysearchuser(
        branchId: branchName,
        customerId: null,
        departmentId: departmentName,
        searchContent: "",
        pageIndex: 1,
        pageSize: 10,
        userId: userId,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBodysearchuser.toJson()),
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
}
