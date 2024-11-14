import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/documentss.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class DocumentService {
  final String apiUrl = '${ApiConfig.baseUrl}/co-documents/search';

  Future<List<Data>> fetchDocuments(int page, int pageSize) async {
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
        final Documentss documentData = Documentss.fromJson(jsonResponse);
        return documentData.data ?? [];
      } else {
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error fetching documents: $error');
      return [];
    }
  }

  Future<List<Data>> searchDocumentsByDateRange(
      DateTime? startDate, DateTime? endDate) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      Body requestBody = Body(
        searchContent: "",
        pageIndex: 1,
        pageSize: 10,
        frCreatedDate: startDate,
        toCreatedDate: endDate,
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
        final Documentss documentData = Documentss.fromJson(jsonResponse);
        return documentData.data ?? [];
      } else {
        print('Failed to load documents: ${response.body}');
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error searching documents by date range: $error');
      return [];
    }
  }

  Future<List<Data>> searchDocuments(String searchContent) async {
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
          userId: userId);

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final Documentss documentssData = Documentss.fromJson(jsonResponse);

        return documentssData.data ?? [];
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (error) {
      print('Error fetching customers: $error');
      return [];
    }
  }
}
