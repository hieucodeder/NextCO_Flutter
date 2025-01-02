import 'dart:convert';
import 'package:app_1helo/model/statistics.dart';
import 'package:app_1helo/service/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsService {
  final String apiUrl =
      '${ApiConfig.baseUrl}/statistics/statisticEmployeeAndStatusCO';

  Future<List<Statuses>?> fetchStatistics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeId = prefs.getString('userId');

    if (employeeId == null) {
      print("User ID not found");
      return null; // Return early if employeeId is not found
    }

    final url = Uri.parse(apiUrl);
    print("Requesting URL: $url");

    try {
      final headers = await ApiConfig.getHeaders();
      print("Request Headers: $headers");

      final body = json.encode({
        'employee_id': employeeId, // Pass the userId (employeeId) here
      });

      final response = await http.post(url, headers: headers, body: body);
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isEmpty) {
          print("No data found in response.");
          return null;
        }

        // Find the matching employee_id
        final employeeStats = jsonData.firstWhere(
          (item) => item['employee_id'] == employeeId,
          orElse: () => null,
        );

        if (employeeStats != null) {
          print("Found employee_id, returning Statuses list.");
          final statistics = Statistics.fromJson(employeeStats);

          if (statistics.statuses == null || statistics.statuses!.isEmpty) {
            print("No statuses found for employee_id: $employeeId");
            return null;
          }

          return statistics.statuses;
        } else {
          print("No statistics found for employee_id: $employeeId");
          return null;
        }
      } else {
        print("HTTP request failed with status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching statistics: $e");
      return null;
    }
  }
}
