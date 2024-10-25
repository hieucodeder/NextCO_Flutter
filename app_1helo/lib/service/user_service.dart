import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/lineCharModel.dart';
import 'package:app_1helo/model/user.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class UserService {
  final String apiUrl = '${ApiConfig.baseUrl1}/users/search';

  Future<int?> fetchTotalItemsUsers() async {
    final url = Uri.parse(apiUrl);

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

    try {
      final headers = await ApiConfig.getHeaders();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final User usersData = User.fromJson(jsonData);
        return usersData.totalItems;
      } else {
        print(
            'Error: Response not successful, Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching total items: $error');
      return null;
    }
  }

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

}
