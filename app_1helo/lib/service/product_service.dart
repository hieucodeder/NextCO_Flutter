import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/productss.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ProductService {
  final String apiUrl = '${ApiConfig.baseUrl}/products/search';

  Future<List<Data>> fetchProducts(
      int page, int pageSize, String? customerId) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        return [];
      }

      Body requestBody = Body(
        searchContent: "",
        pageIndex: page,
        pageSize: pageSize,
        frCreatedDate: null,
        toCreatedDate: null,
        employeeId: null,
        customerId: customerId,
        userId: userId,
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
        throw Exception('Failed to load products');
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Data>> searchProducts(String searchContent) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        return [];
      }

      Body requestBody = Body(
        searchContent: searchContent,
        pageIndex: 1,
        pageSize: 10,
        frCreatedDate: null,
        toCreatedDate: null,
        employeeId: null,
        customerId: null,
        userId: userId,
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
      return [];
    }
  }
}
