import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/documentss.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class DocumentService {
  final String apiUrl = '${ApiConfig.baseUrl}/co-documents/search';

  Future<int?> fetchTotalItemsDocuments() async {
    final url = Uri.parse(apiUrl);

    Body requestBody = Body(
      searchContent: "",
      pageIndex: 1,
      pageSize: 10,
      frCreatedDate: null,
      toCreatedDate: null,
      employeeId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
      customerId: null,
      userId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
    );
    try {
      final headers = await ApiConfig.getHeaders();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final Documentss documentData = Documentss.fromJson(jsonData);
        return documentData.totalItems;
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

  Future<List<Data>> fetchDocuments() async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      Body requestBody = Body(
        searchContent: "",
        pageIndex: 1,
        pageSize: 10,
        frCreatedDate: null,
        toCreatedDate: null,
        employeeId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
        customerId: null,
        userId: "a80f412c-73cc-40be-bc12-83c201cb2c4d",
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final Documentss documentData = Documentss.fromJson(jsonResponse);
        return documentData.data ?? []; // Return the data list
      } else {
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error fetching documents: $error');
      return [];
    }
  }
}
