import 'dart:convert';
import 'package:app_1helo/model/body.dart';
import 'package:app_1helo/model/customers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class CustomerService {
  final String apiUrl = '${ApiConfig.baseUrl}/customers/search';

  Future<List<Data>> fetchCustomer(int page , int pageSize) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        print('No user ID found. User might not be logged in.');
        return [];
      }
      Body requestBody = Body(
        searchContent: "",
        pageIndex: page,
        pageSize: pageSize,
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
        final Customers customerData = Customers.fromJson(jsonResponse);
        return customerData.data ?? [];
      } else {
        throw Exception('Failed to load documents');
      }
    } catch (error) {
      print('Error fetching documents: $error');
      return [];
    }
  }

  Future<List<Data>> searchCustomers(String searchContent) async {
    try {
      final url = Uri.parse(apiUrl);
      final headers = await ApiConfig.getHeaders();
      final prefs = await SharedPreferences.getInstance();

      final userId = prefs.getString('userId');

      if (userId == null) {
        print('No user ID found. User might not be logged in.');
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
        final Customers customerData = Customers.fromJson(jsonResponse);

        return customerData.data ?? [];
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (error) {
      print('Error fetching customers: $error');
      return [];
    }
  }
}
