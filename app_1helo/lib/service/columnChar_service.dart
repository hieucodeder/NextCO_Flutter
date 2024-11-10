import 'dart:convert';
import 'package:app_1helo/model/columnChar.dart';
import 'package:app_1helo/service/api_config.dart';
import 'package:http/http.dart' as http;

Future<List<ColumnChar>> fetchChartData(int year) async {
  final url = Uri.parse('${ApiConfig.baseUrl1}/customers/get-data/$year');
  final headers = await ApiConfig.getHeaders();

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => ColumnChar.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load data for year $year');
  }
}
