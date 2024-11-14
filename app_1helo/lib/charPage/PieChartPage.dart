import 'dart:async';
import 'dart:ffi';
import 'package:app_1helo/model/customers.dart';
import 'package:app_1helo/model/dropdownEmployee.dart';
import 'package:app_1helo/model/pieCharModel.dart';
import 'package:app_1helo/model/user.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:app_1helo/service/customer_service..dart';
import 'package:app_1helo/service/pieChar_service.dart';
import 'package:app_1helo/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:app_1helo/model/dropdownCustomer.dart';

class Piechartpage extends StatefulWidget {
  const Piechartpage({Key? key}) : super(key: key);

  Future<void> fetchPieChartData() async {
    await Future.delayed(Duration(seconds: 2));
  }

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
  List<PieCharModel> pieCharChartData = [];
  int currentPage = 1;
  int pageSize = 10;
  @override
  void initState() {
    super.initState();
    _fetchUsersData();
    if (mounted) {
      fetchData();
      fetchDataCustomer();
    }
  }

  Future<void> fetchData() async {
    await _fetchPieChartData(
      startDate != null ? DateTime.parse(startDate!) : null,
      endDate != null ? DateTime.parse(endDate!) : null,
      selectedDropdownEmployee?.value,
      selectedDropdownCustomer?.customerId,
      true,
    );
  }

  Future<void> fetchDataCustomer() async {
    await _fetchPieChartData(
      startDate != null ? DateTime.parse(startDate!) : null,
      endDate != null ? DateTime.parse(endDate!) : null,
      selectedDropdownEmployee?.value,
      selectedDropdownCustomer?.customerId,
      false,
    );
  }

  Future<void> _fetchPieChartData(
    DateTime? startDate,
    DateTime? endDate,
    String? employeeId,
    String? customerId,
    bool isUserFetch,
  ) async {
    setState(() => _isFetchingData = true);

    try {
      final pieCharService = PiecharService();
      final List<PieCharModel>? pieChartData = await pieCharService
          .fetchPieChartData(startDate, endDate, employeeId, customerId);

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
      int completedTotal = 0;
      int processingTotal = 0;
      int waitingcancelTotal = 0;
      int waitingTotal = 0;
      int refusedconsider = 0;
      int cancel = 0;
      int editor = 0;
      int waitingrepair = 0;

      for (var item in pieChartData) {
        switch (item.statusId) {
          case 1:
            completedTotal += item.quantity?.toInt() ?? 0;
            break;
          case 2:
            processingTotal += item.quantity?.toInt() ?? 0;
            break;
          case 3:
            waitingcancelTotal += item.quantity?.toInt() ?? 0;
            break;
          case 4:
            waitingTotal += item.quantity?.toInt() ?? 0;
            break;
          case 5:
            refusedconsider += item.quantity?.toInt() ?? 0;
            break;
          case 6:
            cancel += item.quantity?.toInt() ?? 0;
            break;
          case 7:
            editor += item.quantity?.toInt() ?? 0;
            break;
          case 8:
            waitingrepair += item.quantity?.toInt() ?? 0;
            break;
        }
      }

      int total = completedTotal +
          processingTotal +
          waitingcancelTotal +
          waitingTotal +
          refusedconsider +
          cancel +
          editor +
          waitingrepair;

      setState(() {
        dataMap = total > 0
            ? {
                if (completedTotal > 0)
                  "Hoàn thành: ($completedTotal)":
                      (completedTotal / total) * 100,
                if (processingTotal > 0)
                  "Đang thực hiện: ($processingTotal)":
                      (processingTotal / total) * 100,
                if (waitingcancelTotal > 0)
                  "Chờ hủy: ($waitingcancelTotal)":
                      (waitingcancelTotal / total) * 100,
                if (waitingTotal > 0)
                  "Chờ duyệt: ($waitingTotal)": (waitingTotal / total) * 100,
                if (refusedconsider > 0)
                  "Từ chối xét duyệt: ($refusedconsider)":
                      (refusedconsider / total) * 100,
                if (cancel > 0) "Đã hủy: ($cancel)": (cancel / total) * 100,
                if (editor > 0) "Đang sửa: ($editor)": (editor / total) * 100,
                if (waitingrepair > 0)
                  "Chờ sửa: ($waitingrepair)": (waitingrepair / total) * 100,
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

  Future<void> _fetchUsersData() async {
    try {
      _userList = await _userService.fetchUsers(currentPage, pageSize);
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
      selectedDropdownEmployee = _filtereddropdownEmployee[0];
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

      final selectedEmployeeId = selectedDropdownEmployee?.value;
      final selectedCustomer = selectedDropdownCustomer?.customerId;
      setState(() {
        _isFetchingData = true;
      });

      try {
        final pieCharService = PiecharService();
        final List<PieCharModel> pieCharData =
            await pieCharService.searchByDateRange(
          parsedStartDate,
          parsedEndDate,
          selectedEmployeeId,
          selectedCustomer,
        );

        if (pieCharData.isNotEmpty) {
          setState(() {
            pieCharChartData = pieCharData;
          });
        } else {
          print('No data found for the selected date range.');
          setState(() {
            pieCharChartData = [];
          });
        }
      } catch (e) {
        print("Error fetching data: $e");
        if (mounted) {
          setState(() {
            pieCharChartData = [];
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isFetchingData = false;
          });
        }
      }
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
    final colorList = dataMap.keys.contains("Không có dữ liệu")
        ? [Colors.grey]
        : [
            Colors.green, 
            Colors.orange, 
            Colors.orange, 
            Colors.black, 
            Colors.red, 
            Colors.red, 
            Colors.black, 
            Colors.black,
          ];
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
                margin: const EdgeInsets.only(top: 10),
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
                        onTap: _clearDateRange,
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
            const SizedBox(height: 15),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  renderCustomerDropdown(),
                  const SizedBox(width: 6.0),
                  Expanded(child: renderUserDropdown()),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 250,
              child: _isFetchingData
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PieChart(
                        dataMap: dataMap,
                        chartType: ChartType.disc,
                        colorList: colorList,
                        animationDuration: const Duration(milliseconds: 800),
                        chartRadius: double.infinity,
                        legendOptions: LegendOptions(
                          legendPosition: LegendPosition.right,
                          showLegendsInRow: false,
                          legendTextStyle: GoogleFonts.robotoCondensed(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                          chartValueStyle: GoogleFonts.robotoCondensed(
                            fontSize: 14,
                            color: Colors.white,
                          ),
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
