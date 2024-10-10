import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/productss.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ProductService {
  final String apiUrl = '${ApiConfig.baseUrl}/products/search';

  Future<int?> fetchTotalItemsProducts() async {
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
        final Productss productsData = Productss.fromJson(jsonData);
        return productsData.totalItems;
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

  Future<List<Data>> fetchProducts(int page, int pageSize) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      Body requestBody = Body(
        searchContent: "",
        pageIndex: page,
        pageSize: pageSize,
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
        final Productss productsData = Productss.fromJson(jsonResponse);
        return productsData.data ?? [];
      } else {
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error fetching documents: $error');
      return [];
    }
  }

  Future<List<Data>> searchProducts(String searchContent) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      Body requestBody = Body(
        searchContent: searchContent,
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
        final Productss productssData = Productss.fromJson(jsonResponse);

        return productssData.data ?? [];
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (error) {
      print('Error fetching customers: $error');
      return [];
    }
  }
}
