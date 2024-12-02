import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/bodyReport.dart';
import 'package:app_1helo/model/prodcutReportModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ProductReportService {
  final String apiUrl = '${ApiConfig.baseUrl}/products/report';

  Future<int?> fetchTotalItems() async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      // Log the userId for debugging
      print('User ID: $userId');

      if (userId == null) {
        print('No user ID found. User might not be logged in.');
        return null;
      }

      Bodyreport requestBody = Bodyreport(
        customerId: null,
        frCreatedDate: null,
        pageIndex: 1,
        pageSize: 10,
        searchContent: "",
        toCreatedDate: null,
        typeSearch: 1,
        userId: userId,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

        final Prodcutreportmodel productsReportData =
            Prodcutreportmodel.fromJson(jsonResponse);

        return productsReportData.totalItems;
      } else {
        throw Exception('Failed to fetch total items');
      }
    } catch (error) {
      print('Error fetching total items: $error');
      return null;
    }
  }

Future<List<DataModel>> fetchProductsReportAll(
      int page, int pageSize,) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        print('No user ID found. User might not be logged in.');
        return [];
      }
      Bodyreport requestBody = Bodyreport(
        customerId: null,
        frCreatedDate: null,
        pageIndex: page,
        pageSize: pageSize,
        searchContent: "search",
        toCreatedDate: null,
        typeSearch: 1,
        userId: userId,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final Prodcutreportmodel productsReportData =
            Prodcutreportmodel.fromJson(jsonResponse);
        return productsReportData.data ?? [];
      } else {
        // Log the response body for debugging if status is not 200
        print(
            'Error: Server responded with status code ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error fetching documents: $error');
      return [];
    }
  }
  Future<List<DataModel>> fetchProductsReport(
      int page, int pageSize, String? search, String? customerid) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        print('No user ID found. User might not be logged in.');
        return [];
      }
      Bodyreport requestBody = Bodyreport(
        customerId: customerid,
        frCreatedDate: null,
        pageIndex: page,
        pageSize: pageSize,
        searchContent: search,
        toCreatedDate: null,
        typeSearch: 1,
        userId: userId,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final Prodcutreportmodel productsReportData =
            Prodcutreportmodel.fromJson(jsonResponse);
        return productsReportData.data ?? [];
      } else {
        // Log the response body for debugging if status is not 200
        print(
            'Error: Server responded with status code ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error fetching documents: $error');
      return [];
    }
  }
Future<List<DataModel>> fetchProductsReportQuantity(
      ) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        print('No user ID found. User might not be logged in.');
        return [];
      }
      Bodyreport requestBody = Bodyreport(
        customerId: null,
        frCreatedDate: null,
        pageIndex: 1,
        pageSize: 50,
        searchContent: "",
        toCreatedDate: null,
        typeSearch: 1,
        userId: userId,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final Prodcutreportmodel productsReportData =
            Prodcutreportmodel.fromJson(jsonResponse);
        return productsReportData.data ?? [];
      } else {
        // Log the response body for debugging if status is not 200
        print(
            'Error: Server responded with status code ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error fetching documents: $error');
      return [];
    }
  }
  Future<List<DataModel>> fetchProductsReportDate(
      DateTime? frdDate, DateTime? toDate) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        print('No user ID found. User might not be logged in.');
        return [];
      }
      Bodyreport requestBody = Bodyreport(
        customerId: null,
        frCreatedDate: frdDate,
        pageIndex: 1,
        pageSize: 10,
        searchContent: "",
        toCreatedDate: toDate,
        typeSearch: 1,
        userId: userId,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final Prodcutreportmodel productReportModel =
            Prodcutreportmodel.fromJson(jsonResponse);
        return productReportModel.data ?? [];
      } else {
        print(
            'Error: Server responded with status code ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error fetching documents: $error');
      return [];
    }
  }
}
