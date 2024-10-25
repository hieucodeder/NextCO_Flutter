import 'dart:async';

import 'package:app_1helo/model/customers.dart';
import 'package:app_1helo/model/lineCharModel.dart' as LineCharModel1;
import 'package:app_1helo/model/user.dart';
import 'package:app_1helo/service/customer_service..dart';
import 'package:app_1helo/service/lineChar_service.dart';
import 'package:app_1helo/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class Linecharpage extends StatefulWidget {
  const Linecharpage({super.key});

  @override
  _LinecharpageState createState() => _LinecharpageState();
}

class _LinecharpageState extends State<Linecharpage> {
  TextEditingController _searchControllerCustomer = TextEditingController();
  TextEditingController _searchControllerUsers = TextEditingController();
  final LineChartService _lineChartService = LineChartService();
  final UserService _userService = UserService();
  final CustomerService _customerService = CustomerService();
  DataUser? selectedUsers;
  Data? selectedCustomer;
  List<FlSpot> _completeCoSpots = [];
  List<FlSpot> _processingCoSpots = [];
  List<FlSpot> _canceledCoSpots = [];
  List<String> _quantities = [];
  List<String> _createdDates = [];

  List<Data> _customerList = [];
  List<Data> _filteredCustomers = [];
  List<DataUser> _userList = [];
  List<DataUser> _filteredUsers = [];
  Timer? timer;
  bool _isLoading = true, isDropDownVisible = false;
  double _minX = 0, _maxX = 0, _minY = 0, _maxY = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchCustomersData();
    _fetchUsersData();
  }

  @override
  void dispose() {
    timer?.cancel();
    _searchControllerCustomer.dispose();
    _searchControllerUsers.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    LineCharModel1.LinecharModel? lineChartResponse =
        await _lineChartService.fetchLineChartData('employeeId', 'customerId');

    if (mounted && lineChartResponse?.data != null) {
      setState(() {
        _completeCoSpots =
            _mapDataToFlSpot(lineChartResponse!.data!.completeCo);
        _processingCoSpots =
            _mapDataToFlSpot(lineChartResponse.data!.processingCo);
        _canceledCoSpots = _mapDataToFlSpot(lineChartResponse.data!.canceledCo);

        _quantities = lineChartResponse.data!.processingCo!
            .map((co) => co.quantity ?? 'N/A')
            .toList();
        _createdDates = lineChartResponse.data!.processingCo!
            .map((co) => co.createdDate ?? 'N/A')
            .toList();

        _calculateAxisRanges();
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCustomersData() async {
    try {
      _customerList = await _customerService.fetchCustomer();
      setState(() {
        _filteredCustomers = _customerList;
      });
    } catch (e) {
      print("Error fetching customer data: $e");
    }
  }

  Future<void> _fetchUsersData() async {
    try {
      _userList = await _userService.fetchUsers();
      setState(() {
        _filteredUsers = _userList;
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  List<FlSpot> _mapDataToFlSpot(List<dynamic>? dataList) {
    return dataList?.asMap().entries.map((entry) {
          int index = entry.key;
          var co = entry.value;
          return FlSpot(
              index.toDouble(), double.tryParse(co.quantity ?? '0') ?? 0);
        }).toList() ??
        [];
  }

  void _calculateAxisRanges() {
    List<FlSpot> allSpots = []
      ..addAll(_completeCoSpots)
      ..addAll(_processingCoSpots)
      ..addAll(_canceledCoSpots);

    if (allSpots.isNotEmpty) {
      _minX = allSpots.map((e) => e.x).reduce((a, b) => a < b ? a : b);
      _maxX = allSpots.map((e) => e.x).reduce((a, b) => a > b ? a : b);
      _minY = allSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
      _maxY = allSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    } else {
      _minX = 0;
      _maxX = 1;
      _minY = 0;
      _maxY = 50;
    }
  }

  void toggleDropDownVisibility() {
    setState(() {
      isDropDownVisible = !isDropDownVisible;
    });
  }

  Widget buildDropdown({
    required List<String> items,
    required String? selectedItem,
    required String hint,
    required Function(String?) onChanged,
    double width = 150,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.black38),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: width,
      height: 40,
      child: DropdownButton<String>(
        hint: Text(
          hint,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        value: selectedItem,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        underline: Container(),
        onChanged: (value) {
          onChanged(value);
          setState(() {});
        },
        items: items.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<String> getUniqueNames(
      List<dynamic> items, String Function(dynamic) nameSelector) {
    Set<String> seenNames = {};
    return items
        .map(nameSelector)
        .where((name) => seenNames.add(name ?? ''))
        .toList();
  }

  Widget renderCustomerDropdownCustomer() {
    List<String> customerNames = getUniqueNames(
        _filteredCustomers, (customer) => customer.customerName ?? '');

    return buildDropdown(
      items: customerNames,
      selectedItem: _filteredCustomers.any((customer) =>
              customer.customerName == selectedCustomer?.customerName)
          ? selectedCustomer?.customerName
          : null,
      hint: 'Tất cả khách hàng',
      width: 180,
      onChanged: (String? newValue) {
        setState(() {
          selectedCustomer = _filteredCustomers.firstWhere(
            (customer) => customer.customerName == newValue,
            orElse: () => _filteredCustomers[0],
          );
          _searchControllerCustomer.text = selectedCustomer?.customerName ?? '';
        });
      },
    );
  }

  Widget renderDropdownUser() {
    List<String> userNames =
        getUniqueNames(_filteredUsers, (user) => user.fullName ?? '');

    return buildDropdown(
      items: userNames,
      selectedItem: selectedUsers?.fullName,
      hint: 'Tất cả nhân viên',
      width: 160,
      onChanged: (String? newValue) {
        setState(() {
          selectedUsers = _filteredUsers.firstWhere(
            (user) => user.fullName == newValue,
            orElse: () => _filteredUsers[0],
          );
          _searchControllerCustomer.text = selectedCustomer?.customerName ?? '';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  renderCustomerDropdownCustomer(),
                  const SizedBox(
                    width: 2,
                  ),
                  renderDropdownUser(),
                ],
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.5,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: true),
                          titlesData: const FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _completeCoSpots,
                              isCurved: true,
                              color: Colors.green,
                              barWidth: 3,
                              belowBarData: BarAreaData(show: false),
                            ),
                            LineChartBarData(
                              spots: _processingCoSpots,
                              isCurved: true,
                              color: Colors.orange,
                              barWidth: 3,
                              belowBarData: BarAreaData(show: false),
                            ),
                            LineChartBarData(
                              spots: _canceledCoSpots,
                              isCurved: true,
                              color: Colors.red,
                              barWidth: 3,
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                                color: const Color(0xff37434d), width: 1),
                          ),
                          minX: _minX,
                          maxX: _maxX,
                          minY: _minY,
                          maxY: _maxY,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
