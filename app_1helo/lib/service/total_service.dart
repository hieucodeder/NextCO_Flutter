import 'dart:convert';
import 'package:app_1helo/model/body_total.dart';
import 'package:app_1helo/model/total_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class TotalService {
  final String apiUrl =
      '${ApiConfig.baseUrl}/statistics/get-dashboard-total-by-user-name';

  Future<Data?> fetchTotalItemsUsers() async {
    final url = Uri.parse(apiUrl);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userName = prefs.getString('userName');

    if (userId == null) {
      return null;
    }
    bodyTotal requestBody = bodyTotal(userId: userId, userName: userName);

    try {
      final headers = await ApiConfig.getHeaders();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final totalModel totalModelsData = totalModel.fromJson(jsonData);

        if (totalModelsData.success == true) {
          return totalModelsData.data;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
