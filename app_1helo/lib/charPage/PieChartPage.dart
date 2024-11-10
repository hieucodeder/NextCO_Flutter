import 'dart:async';
import 'package:app_1helo/model/customers.dart';
import 'package:app_1helo/model/dropdownEmployee.dart';
import 'package:app_1helo/model/pieCharModel.dart';
import 'package:app_1helo/model/user.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:app_1helo/service/customer_service..dart';
import 'package:app_1helo/service/document_service.dart';
import 'package:app_1helo/service/pieChar_service.dart';
import 'package:app_1helo/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:app_1helo/model/dropdownCustomer.dart';
import 'package:app_1helo/model/documentss.dart' as Documents;

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
  final AuthService _athServiceService = AuthService();
  Map<String, double> dataMap = {};
  List<Data> _customerList = [];
  List<Data> _filteredCustomers = [];
  List<DataUser> _userList = [];
  List<DataUser> _filteredUsers = [];
  DataUser? selectedUsers;
  dropdownEmployee? selectedDropdownEmployee;
  List<dropdownEmployee> _filtereddropdownEmployee = [];
  EmployeeCustomer? selectedDropdownCustomer;
  List<EmployeeCustomer> _filtereddropdownCustomer = [];
  bool _isFetchingData = false;

  @override
  void initState() {
    super.initState();
    _fetchCustomersData();
    _fetchUsersData();
    if (mounted) {
      fetchData();
      fetchDataCustomer();
    }
  }

  Future<void> fetchData() async {
    await _fetchPieChartData(
      selectedDropdownEmployee?.value,
      selectedDropdownCustomer?.customerId,
      true,
    );
  }

  Future<void> fetchDataCustomer() async {
    await _fetchPieChartData(
      selectedDropdownEmployee?.value,
      selectedDropdownCustomer?.customerId,
      false,
    );
  }

  Future<void> _fetchPieChartData(
      String? employeeId, String? customerId, bool isUserFetch) async {
    if (mounted) {
      setState(() {
        _isFetchingData = true;
      });
    }

    try {
      final pieCharService = PiecharService();
      final List<PieCharModel>? pieChartData =
          await pieCharService.fetchPieChartData(employeeId, customerId);

      print("Pie chart data: $pieChartData");
      await _fetchEmployeeOrCustomerData(isUserFetch);

      _processPieChartData(pieChartData);
    } catch (e) {
      print("Error fetching data: $e");
      if (mounted) {
        setState(() {
          dataMap = {"Không có dữ liệu": 1};
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingData = false;
        });
      }
    }
  }

  void _processPieChartData(List<PieCharModel>? pieChartData) {
    if (pieChartData != null && pieChartData.isNotEmpty) {
      double waiting = 0;
      double completed = 0;
      double processing = 0;
      double canceled = 0;

      for (var item in pieChartData) {
        waiting += item.statusId == 4 ? item.quantity.toDouble() : 0;
        completed += item.complete.toDouble() ?? 0;
        processing += item.processing.toDouble() ?? 0;
        canceled += item.canceled.toDouble() ?? 0;
      }

      print(
          "Data totals - Waiting: $waiting, Completed: $completed, Processing: $processing, Canceled: $canceled"); // Debugging line

      double total = waiting + completed + processing + canceled;

      setState(() {
        dataMap = total > 0
            ? {
                "Chờ duyệt": (waiting / total) * 100,
                "Hoàn thành": (completed / total) * 100,
                "Đang xử lý": (processing / total) * 100,
                "Đã hủy": (canceled / total) * 100,
              }
            : {"Không có dữ liệu": 0};
      });
    } else {
      print("Pie chart data is empty");
      setState(() {
        dataMap = {"Không có dữ liệu": 0};
      });
    }
  }

  Future<void> _fetchEmployeeOrCustomerData(bool isUserFetch) async {
    if (isUserFetch) {
      List<dropdownEmployee>? employees =
          await _athServiceService.getEmployeeInfo();
      if (employees != null && mounted) {
        setState(() {
          _filtereddropdownEmployee = employees;
        });
      }
    } else {
      List<EmployeeCustomer>? customers =
          await _athServiceService.getEmployeeCustomerInfo();
      if (customers != null) {
        setState(() {
          _filtereddropdownCustomer = customers;
        });
      }
    }
  }

  Future<void> _fetchCustomersData() async {
    try {
      _customerList = await _customerService.fetchCustomer();
      if (mounted) {
        setState(() {
          _filteredCustomers = _customerList;
        });
      }
    } catch (e) {
      print("Error fetching customer data: $e");
    }
  }

  Future<void> _fetchUsersData() async {
    try {
      _userList = await _userService.fetchUsers();
      if (mounted) {
        setState(() {
          _filteredUsers = _userList;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.black38),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: width,
      height: 40,
      child: DropdownButton<String>(
        hint: Text(
          hint,
          style: const TextStyle(fontSize: 13, color: Colors.black),
        ),
        value: selectedItem,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        underline: Container(),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget renderCustomerDropdown() {
    List<String> customerNames = _filtereddropdownCustomer
        .map((c) => c.customerName ?? '')
        .toSet()
        .toList();
    customerNames.insert(0, 'Tất cả khách hàng');

    return buildDropdown(
      items: customerNames,
      selectedItem: selectedDropdownCustomer?.customerName,
      hint: 'Tất cả khách hàng',
      width: 180,
      onChanged: (String? newValue) {
        setState(() {
          selectedDropdownCustomer = newValue == 'Tất cả khách hàng'
              ? null
              : _filtereddropdownCustomer.firstWhere(
                  (c) => c.customerName == newValue,
                  orElse: () => _filtereddropdownCustomer[0],
                );
        });
        fetchData();
      },
    );
  }

  Widget renderUserDropdown() {
    List<String> userNames =
        _filtereddropdownEmployee.map((u) => u.label ?? '').toSet().toList();

    if (selectedDropdownEmployee == null &&
        _filtereddropdownEmployee.isNotEmpty) {
      selectedDropdownEmployee = _filtereddropdownEmployee[2];
      fetchDataCustomer();
    }
    return buildDropdown(
      items: userNames,
      selectedItem: selectedDropdownEmployee?.label,
      hint: 'Tất cả nhân viên',
      width: 160,
      onChanged: (String? newValue) {
        setState(() {
          if (newValue == 'Tất cả nhân viên') {
            selectedDropdownEmployee = null;
          } else {
            selectedDropdownEmployee = _filtereddropdownEmployee.firstWhere(
              (u) => u.label == newValue,
              orElse: () => _filtereddropdownEmployee[0],
            );
          }
          fetchDataCustomer();
        });
      },
    );
  }

  String? startDate;
  String? endDate;
  final TextEditingController _controller = TextEditingController();
  late Future<List<PieCharModel>> searchPieChar;
  final PiecharService piecharService = PiecharService();
  String? selectedEmployeeId;
  String? selectedCustomer;

  void _selectDateRange() async {
    final DateTime? startPicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (startPicked != null) {
      final DateTime? endPicked = await showDatePicker(
        context: context,
        initialDate: startPicked.add(const Duration(days: 1)),
        firstDate: startPicked,
        lastDate: DateTime(2101),
      );

      if (endPicked != null) {
        setState(() {
          startDate = DateFormat('yyyy-MM-dd').format(startPicked);
          endDate = DateFormat('yyyy-MM-dd').format(endPicked);
          _controller.text = '$startDate - $endDate';
        });

        await _updateDocumentsByDateRange();
      }
    }
  }

  Future<void> _updateDocumentsByDateRange() async {
    if (startDate != null && endDate != null) {
      final DateTime parsedStartDate =
          DateFormat('yyyy-MM-dd').parse(startDate!);
      final DateTime parsedEndDate = DateFormat('yyyy-MM-dd').parse(endDate!);

      setState(() {
        searchPieChar = piecharService.searchByDateRange(parsedStartDate,
            parsedEndDate, selectedEmployeeId, selectedCustomer);
      });
    } else {
      print('Start date and end date cannot be null.');
    }
  }

  void _clearDateRange() {
    if (mounted) {
      setState(() {
        startDate = null;
        endDate = null;
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _selectDateRange,
              child: Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black38),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        readOnly: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Chọn Ngày Bắt Đầu và Kết Thúc',
                          hintStyle: GoogleFonts.robotoCondensed(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    if (_controller.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _clearDateRange();
                        },
                        child: Icon(
                          Icons.close_sharp,
                          color: Colors.black54,
                          size: 20,
                        ),
                      ),
                    VerticalDivider(
                      width: 20,
                      thickness: 1,
                      color: Colors.black38,
                    ),
                    GestureDetector(
                      onTap: _selectDateRange,
                      child: Icon(Icons.calendar_today, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  renderCustomerDropdown(),
                  const SizedBox(width: 6.0),
                  renderUserDropdown(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: _isFetchingData
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PieChart(
                        dataMap: dataMap,
                        chartType: ChartType.disc,
                        colorList: const [
                          Colors.orange,
                          Colors.green,
                          Colors.blue,
                          Colors.red
                        ],
                        animationDuration: const Duration(milliseconds: 800),
                        chartRadius: MediaQuery.of(context).size.width / 2,
                        legendOptions: const LegendOptions(
                          legendPosition: LegendPosition.right,
                          showLegendsInRow: false,
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
