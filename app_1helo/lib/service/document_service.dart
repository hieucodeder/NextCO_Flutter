import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/bodyfilter.dart';
import 'package:app_1helo/model/documentss.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class DocumentService {
  final String apiUrl = '${ApiConfig.baseUrl}/co-documents/search';

  Future<List<Data>> fetchAllDocuments(int page, int pageSize) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
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
      return [];
    }
  }

  Future<List<Data>> fetchDocuments(
      int page, int pageSize, String? employeeId, String? customerId) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        return [];
      }
      Body requestBody = Body(
        searchContent: "",
        pageIndex: page,
        pageSize: pageSize,
        frCreatedDate: null,
        toCreatedDate: null,
        employeeId: employeeId,
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
        final Documentss documentData = Documentss.fromJson(jsonResponse);
        return documentData.data ?? [];
      } else {
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Data>> fetchDocumentsFilter(int page, int pageSize, int statusId,
      String? employeeId, String? customerId) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        return [];
      }
      Bodyfilter requestBodyfilter = Bodyfilter(
        searchContent: "",
        pageIndex: page,
        pageSize: pageSize,
        statusId: statusId,
        employeeId: employeeId,
        customerId: customerId,
        userId: userId,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBodyfilter.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final Documentss documentData = Documentss.fromJson(jsonResponse);
        return documentData.data ?? [];
      } else {
        throw Exception('Failed to load documents');
      }
    } catch (error) {
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
        throw Exception('Failed to load documents');
      }
    } catch (error) {
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
      return [];
    }
  }
}
