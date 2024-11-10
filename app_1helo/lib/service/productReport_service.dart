import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/bodyReport.dart';
import 'package:app_1helo/model/prodcutReportModel.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ProductReportService {
  final String apiUrl = '${ApiConfig.baseUrl}/products/report';

  Future<List<Data>> fetchProductsReport(
      int page, int pageSize, String? search, String? customerid) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      Bodyreport requestBody = Bodyreport(
        customerId: customerid,
        frCreatedDate: null,
        pageIndex: page,
        pageSize: pageSize,
        searchContent: search,
        toCreatedDate: null,
        typeSearch: 1,
        userId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
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

  Future<List<Data>> fetchProductsReportDate(
      DateTime? frdDate, DateTime? toDate) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      Bodyreport requestBody = Bodyreport(
        customerId: null,
        frCreatedDate: frdDate,
        pageIndex: 1,
        pageSize: 10,
        searchContent: "",
        toCreatedDate: toDate,
        typeSearch: 1,
        userId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final Prodcutreportmodel _productReportModel =
            Prodcutreportmodel.fromJson(jsonResponse);
        return _productReportModel.data ?? [];
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
