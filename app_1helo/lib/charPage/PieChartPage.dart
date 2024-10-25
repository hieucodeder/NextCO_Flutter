import 'dart:async';
import 'package:app_1helo/model/customers.dart';
import 'package:app_1helo/model/pieCharModel.dart';
import 'package:app_1helo/model/user.dart';
import 'package:app_1helo/service/customer_service..dart';
import 'package:app_1helo/service/pieChar_service.dart';
import 'package:app_1helo/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class Piechartpage extends StatefulWidget {
  const Piechartpage({super.key});

  @override
  _PiechartpageState createState() => _PiechartpageState();
}

class _PiechartpageState extends State<Piechartpage> {
  TextEditingController _searchControllerCustomer = TextEditingController();
  TextEditingController _searchControllerUsers = TextEditingController();
  final UserService _userService = UserService();
  final CustomerService _customerService = CustomerService();
  Map<String, double> dataMap = {};
  List<Data> _customerList = [];
  List<Data> _filteredCustomers = [];
  List<DataUser> _userList = [];
  List<DataUser> _filteredUsers = [];
  Timer? timer;

  DataUser? selectedUsers;
  Data? selectedCustomer;
  bool isDropDownVisible = false;
  final List<Color> colorList = [
    Colors.orange, 
  ];
  bool _isFetchingData = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    _fetchCustomersData();
    _fetchUsersData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isFetchingData = true;
    });

    final pieCharService = PiecharService();
    final PieCharModel? pieChartData = await pieCharService.fetchPieChartData(
      'a80f412c-73cc-40be-bc12-83c201cb2c4d',
      '',
      '2024-08-01',
      '2024-09-31',
    );

    if (mounted && pieChartData != null) {
      setState(() {
        dataMap = {
          "Chờ duyệt": pieChartData.statusId == 1
              ? pieChartData.quantity?.toDouble() ?? 0
              : 0,
        };

        if (dataMap.values.every((value) => value == 0)) {
          dataMap = {"Không có dữ liệu": 0};
        }
      });
    } else {
      print('Failed to fetch pie chart data or data is unsuccessful');
    }

    if (mounted) {
      setState(() {
        _isFetchingData = false;
      });
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
    required ValueChanged<String?> onChanged,
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          value: selectedItem,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          onChanged: (value) {
            onChanged(value);
            setState(() {}); // Triggers a rebuild to reflect the selection
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
      ),
    );
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
          _searchControllerUsers.text = selectedUsers?.fullName ?? '';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 36,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 1,
                        color: Colors.black38,
                        style: BorderStyle.solid)),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      labelText: 'Chọn Ngày Bắt Đầu và Kết Thúc',
                      labelStyle: GoogleFonts.robotoCondensed(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                      border: InputBorder.none,
                      suffixIcon: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          VerticalDivider(
                            width: 20,
                            thickness: 1,
                            color: Colors.black38,
                          ),
                          Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.black38,
                          )
                        ],
                      )),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  renderCustomerDropdownCustomer(),
                  const SizedBox(
                    width: 2,
                  ),
                  renderDropdownUser(),
                ],
              ),
              const SizedBox(height: 20),
              _isFetchingData
                  ? const CircularProgressIndicator()
                  : PieChart(
                      dataMap:
                          dataMap.isEmpty ? {'Không có dữ liệu': 0} : dataMap,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 2.5,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.disc,
                      centerText: "Thống kê",
                      legendOptions: const LegendOptions(
                        showLegendsInRow: true,
                        legendPosition: LegendPosition.bottom,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: false,
                        decimalPlaces: 0,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
