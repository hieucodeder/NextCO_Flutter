import 'dart:convert';
import 'package:app_1helo/model/statistics.dart';
import 'package:app_1helo/model/body_statistics.dart'; 
import 'package:app_1helo/service/api_config.dart';
import 'package:http/http.dart' as http;

class StatisticsService {
  final String apiUrl =
      '${ApiConfig.baseUrl}/statistics/statisticEmployeeAndStatusCO';

  Future<List<Statistics>?> fetchStatistics({
    String? employeeId,
    String? customerId,
  }) async {
    final bodyStatistics = BodyStatistics(
      employeeId: employeeId,
      customerId: customerId,
    );

    final url = Uri.parse(apiUrl);

    try {
      final headers = await ApiConfig.getHeaders();

      // Serialize the BodyStatistics object to JSON
      final body = json.encode(bodyStatistics.toJson());

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isEmpty) {
          return null;
        }

        // Deserialize the JSON data into StatisticsList
        final statisticsList = StatisticsList.fromJson(jsonData);

        if (statisticsList.statistics == null ||
            statisticsList.statistics!.isEmpty) {
          return null;
        }

        return statisticsList.statistics; // Return the list of Statistics
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
