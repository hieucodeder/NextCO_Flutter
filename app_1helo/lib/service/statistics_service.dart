import 'dart:convert';
import 'package:app_1helo/model/statistics.dart';
import 'package:app_1helo/model/body_statistics.dart'; // Import the BodyStatistics model
import 'package:app_1helo/service/api_config.dart';
import 'package:http/http.dart' as http;

class StatisticsService {
  final String apiUrl =
      '${ApiConfig.baseUrl}/statistics/statisticEmployeeAndStatusCO';

  Future<List<Statistics>?> fetchStatistics({
    String? employeeId,
    String? customerId,
  }) async {
    // Create an instance of BodyStatistics with the input parameters
    final bodyStatistics = BodyStatistics(
      employeeId: employeeId,
      customerId: customerId,
    );

    final url = Uri.parse(apiUrl);
    print("Requesting URL: $url");

    try {
      final headers = await ApiConfig.getHeaders();
      print("Request Headers: $headers");

      // Serialize the BodyStatistics object to JSON
      final body = json.encode(bodyStatistics.toJson());

      final response = await http.post(url, headers: headers, body: body);
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isEmpty) {
          print("No data found in response.");
          return null;
        }

        // Deserialize the JSON data into StatisticsList
        final statisticsList = StatisticsList.fromJson(jsonData);

        if (statisticsList.statistics == null ||
            statisticsList.statistics!.isEmpty) {
          print(
              "No statistics found for employee_id: $employeeId and customer_id: $customerId");
          return null;
        }

        return statisticsList.statistics; // Return the list of Statistics
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
