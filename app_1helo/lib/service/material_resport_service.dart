import 'dart:convert';
import 'package:app_1helo/model/body_report.dart';
import 'package:app_1helo/model/materialreport_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class Materialresportservice {
  final String apiUrl = '${ApiConfig.baseUrl}/materials/report';

  Future<List<Data>> fetchMaterialsReport(
      String? search, String? customerid, int page, int pageSize) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
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
        final Materialreportmodel materialreportmodelData =
            Materialreportmodel.fromJson(jsonResponse);
        return materialreportmodelData.data ?? [];
      } else {
        throw Exception('Failed to load materialResport');
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Data>> fetchMateriaDataAlllsReport(int page, int pageSize, String? search, String? customerid) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
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
        // Parse the JSON response
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final Materialreportmodel materialReportModel =
            Materialreportmodel.fromJson(jsonResponse);
        return materialReportModel.data ?? [];
      } else {
        throw Exception('Failed to load materialResport');
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Data>> fetchMaterialsReportDate(
      DateTime? frdDate, DateTime? toDate) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
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
        final Materialreportmodel materialReportModel =
            Materialreportmodel.fromJson(jsonResponse);
        return materialReportModel.data ?? [];
      } else {
        throw Exception('Failed to load materialResport');
      }
    } catch (error) {
      return [];
    }
  }
}
