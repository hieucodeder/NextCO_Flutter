import 'dart:convert';
import 'package:app_1helo/model/bodyTotal.dart';
import 'package:app_1helo/model/totalModel.dart';
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
      print('No user ID found. User might not be logged in.');
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
          print('Failed to fetch total items: ${totalModelsData.success}');
          return null;
        }
      } else {
        print(
            'Error: Response not successful, Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching total items: $error');
      return null;
    }
  }
}
