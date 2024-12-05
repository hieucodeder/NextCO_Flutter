import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/materials.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class MaterialService {
  final String apiUrl = '${ApiConfig.baseUrl}/materials/search';

  Future<List<Data>> fetchMaterials(int page, int pageSize, String? customerId) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      Body requestBody = Body(
        searchContent: "",
        pageIndex: page,
        pageSize: pageSize,
        frCreatedDate: null,
        toCreatedDate: null,
        employeeId: null,
        customerId: customerId,
        userId: userId,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final Materials materialsData = Materials.fromJson(jsonResponse);
        return materialsData.data ?? []; // Return the data list
      } else {
        throw Exception('Failed to load material');
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Data>> searchMaterials(String searchContent) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
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
        final Materials materialsData = Materials.fromJson(jsonResponse);

        return materialsData.data ?? [];
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (error) {
      return [];
    }
  }
}
