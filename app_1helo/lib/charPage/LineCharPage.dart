import 'dart:async';
import 'package:app_1helo/model/customers.dart' as Customers;
import 'package:app_1helo/model/dropdownCustomer.dart';
import 'package:app_1helo/model/dropdownEmployee.dart';
import 'package:app_1helo/model/lineCharModel.dart';
import 'package:app_1helo/model/user.dart';
import 'package:app_1helo/service/appLocalizations%20.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:app_1helo/service/lineChar_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_1helo/Cusstom/LegendItem.dart';
import 'package:google_fonts/google_fonts.dart';

class Linecharpage extends StatefulWidget {
  const Linecharpage({super.key});

  @override
  LinecharpageState createState() => LinecharpageState();
}

class LinecharpageState extends State<Linecharpage> {
  final _searchControllerCustomer = TextEditingController();
  final _searchControllerUsers = TextEditingController();

  final LineChartService _lineChartService = LineChartService();
  final AuthService _athServiceService = AuthService();

  DataUser? selectedUsers;
  Data? selectedLineChar;
  Customers.Data? selectedCustomer;

  dropdownEmployee? selectedDropdownEmployee;
  List<dropdownEmployee> _filtereddropdownEmployee = [];

  EmployeeCustomer? selectedemployeeCustomer;
  List<EmployeeCustomer> _filteredEmployeeCustomer = [];

  List<FlSpot> _completeCoSpots = [];
  List<FlSpot> _processingCoSpots = [];
  List<FlSpot> _canceledCoSpots = [];

  List<Widget> _legendItems = [];
  List<String> monthLabels = [];

  bool _isLoading = true;
  double _minX = 0, _maxX = 0, _minY = 0, _maxY = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

//Refres
  Future<void> refreshChartData() async {
    setState(() {
      _isLoading = true;
    });

    {
      setState(() {
        _fetchData();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLegendItems(); // Cập nhật giao diện khi ngôn ngữ thay đổi
  }

  @override
  void dispose() {
    _searchControllerCustomer.dispose();
    _searchControllerUsers.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    await Future.wait([
      _fetchCustomersData(),
      _fetchUsersData(),
    ]);
    if (mounted) {
      _fetchData();
      _fetchDataAccountCustomer();
    }
  }

  Future<void> _fetchCustomersData() async {
    try {
      setState(() {});
    } catch (e) {
      print("Error fetching customer data: $e");
    }
  }

  Future<void> _fetchUsersData() async {
    try {
      setState(() {});
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final String? employeeId = selectedDropdownEmployee?.value;
      final String? customerId = selectedemployeeCustomer?.customerId;

      LinecharModel? lineChartResponse =
          await _lineChartService.fetchLineChartData(employeeId, customerId);

      List<dropdownEmployee>? employees =
          await _athServiceService.getEmployeeInfo();
      if (employees != null && mounted) {
        setState(() {
          _filtereddropdownEmployee = employees;
        });
      }

      if (mounted) {
        _completeCoSpots.clear();
        _processingCoSpots.clear();
        _canceledCoSpots.clear();

        if (lineChartResponse?.data?.completeCo != null &&
            lineChartResponse!.data!.completeCo!.isNotEmpty) {
          _completeCoSpots =
              _mapDataToFlSpot(lineChartResponse.data!.completeCo);
        }

        if (lineChartResponse?.data?.processingCo != null &&
            lineChartResponse!.data!.processingCo!.isNotEmpty) {
          _processingCoSpots =
              _mapDataToFlSpot(lineChartResponse.data!.processingCo);
        }

        if (lineChartResponse?.data?.canceledCo != null &&
            lineChartResponse!.data!.canceledCo!.isNotEmpty) {
          _canceledCoSpots =
              _mapDataToFlSpot(lineChartResponse.data!.canceledCo);
        }

        _calculateAxisRanges();
        _updateLegendItems();
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchDataAccountCustomer() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String? customerId = selectedemployeeCustomer?.customerId;
      final String? employeeId = selectedDropdownEmployee?.value;

      LinecharModel? lineChartResponse =
          await _lineChartService.fetchLineChartData(employeeId, customerId);

      List<EmployeeCustomer>? customers =
          await _athServiceService.getEmployeeCustomerInfo();
      if (customers != null && mounted) {
        setState(() {
          _filteredEmployeeCustomer = customers;
        });
      }

      if (employeeId == null && customerId == null) {
        _clearChartData();
        _addNoSelectionLegend();
        return;
      }

      if (mounted) {
        _clearChartData();

        if (lineChartResponse?.data?.completeCo != null &&
            lineChartResponse!.data!.completeCo!.isNotEmpty) {
          _completeCoSpots =
              _mapDataToFlSpot(lineChartResponse.data!.completeCo);
        }

        if (lineChartResponse?.data?.canceledCo != null &&
            lineChartResponse!.data!.canceledCo!.isNotEmpty) {
          _canceledCoSpots =
              _mapDataToFlSpot(lineChartResponse.data!.canceledCo);
        }

        _calculateAxisRanges();
        _updateLegendItems();
      }
    } catch (e) {
      print('An error occurred while fetching account customer data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearChartData() {
    _completeCoSpots.clear();
    _processingCoSpots.clear();
    _canceledCoSpots.clear();
  }

  void _addNoSelectionLegend() {
    final localization = AppLocalizations.of(context);
    setState(() {
      _legendItems = [
        LegendItem(
          color: Colors.grey,
          text: localization?.translate('please_select_employee') ??
              'Vui lòng chọn nhân viên!!!',
        ),
      ];
      _isLoading = false;
    });
  }

  void _updateLegendItems() {
    if (!mounted) return;

    final localization = AppLocalizations.of(context);
    setState(() {
      _legendItems.clear();

      if (_completeCoSpots.isNotEmpty) {
        _legendItems.add(
          LegendItem(
            color: Colors.green,
            text: localization?.translate('completed') ?? 'Hoàn thành',
          ),
        );
      }

      if (_processingCoSpots.isNotEmpty) {
        _legendItems.add(
          LegendItem(
            color: Colors.orange,
            text: localization?.translate('processing') ?? 'Đã sửa',
          ),
        );
      }

      if (_canceledCoSpots.isNotEmpty) {
        _legendItems.add(
          LegendItem(
            color: Colors.red,
            text: localization?.translate('canceled') ?? 'Đã hủy',
          ),
        );
      }

      if (_completeCoSpots.isEmpty &&
          _processingCoSpots.isEmpty &&
          _canceledCoSpots.isEmpty) {
        _legendItems.add(
          LegendItem(
            color: Colors.grey,
            text: localization?.translate('select_employee') ??
                'Hãy chọn nhân viên',
          ),
        );
      }
    });
  }

  List<FlSpot> _mapDataToFlSpot(List<dynamic>? dataList) {
    if (dataList == null || dataList.isEmpty) return [];

    final Map<String, double> monthQuantityMap = {};
    DateTime? minDate;
    DateTime? maxDate;

    for (var entry in dataList) {
      Map<String, dynamic> value = entry.toJson();

      try {
        String createdDateStr = value["created_date"] ?? '';
        DateTime createdDate = DateTime.parse(createdDateStr);
        String monthKey =
            "${createdDate.year}-${createdDate.month.toString().padLeft(2, '0')}";

        double quantity =
            double.tryParse(value['quantity']?.toString() ?? '0') ?? 0;
        monthQuantityMap.update(
            monthKey, (existingQty) => existingQty + quantity,
            ifAbsent: () => quantity);

        if (minDate == null || createdDate.isBefore(minDate))
          minDate = createdDate;
        if (maxDate == null || createdDate.isAfter(maxDate))
          maxDate = createdDate;
      } catch (e) {
        print("Error parsing entry: $entry - $e");
      }
    }

    if (monthQuantityMap.isEmpty) return [];

    List<String> allMonths = [];
    DateTime currentDate = minDate!;
    while (currentDate.isBefore(maxDate!)) {
      allMonths.add(
          "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}");
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }
    allMonths
        .add("${maxDate.year}-${maxDate.month.toString().padLeft(2, '0')}");

    for (var month in allMonths) {
      monthQuantityMap.putIfAbsent(month, () => 0);
    }

    monthLabels = monthQuantityMap.keys.toList()..sort();

    List<FlSpot> flSpotList = [];
    for (int xIndex = 0; xIndex < monthLabels.length; xIndex++) {
      final month = monthLabels[xIndex];
      final quantity = monthQuantityMap[month]!;
      flSpotList.add(FlSpot(xIndex.toDouble(), quantity));
    }

    return flSpotList;
  }

  void _calculateAxisRanges() {
    List<FlSpot> allSpots = []
      ..addAll(_completeCoSpots)
      ..addAll(_processingCoSpots)
      ..addAll(_canceledCoSpots);

    if (allSpots.isNotEmpty) {
      _minX = allSpots.map((spot) => spot.x).reduce((a, b) => a < b ? a : b);
      _maxX = allSpots.map((spot) => spot.x).reduce((a, b) => a > b ? a : b);
      _minY = allSpots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
      _maxY = allSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    } else {
      _minX = 0;
      _maxX = 1;
      _minY = 0;
      _maxY = 50;
    }
  }

  Widget buildDropdown({
    required List<String> items,
    required String? selectedItem,
    required String hint,
    required ValueChanged<String?> onChanged,
    double width = 200,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black38),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: width,
      height: 40,
      child: DropdownButton<String>(
        hint: Text(
          hint,
          style: GoogleFonts.robotoCondensed(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
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
              style: GoogleFonts.robotoCondensed(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget renderCustomerDropdown(BuildContext context) {
    final localization = AppLocalizations.of(context);

    List<String> userNames = _filteredEmployeeCustomer
        .map((u) => u.customerName ?? '')
        .toSet()
        .toList();

    String allCustomersLabel =
        localization?.translate('all_customers') ?? 'Tất cả khách hàng';
    userNames.insert(0, allCustomersLabel);

    return buildDropdown(
      items: userNames,
      selectedItem: selectedemployeeCustomer?.customerName,
      hint: allCustomersLabel,
      width: 180,
      onChanged: (String? newValue) {
        setState(() {
          selectedemployeeCustomer = newValue == allCustomersLabel
              ? null
              : _filteredEmployeeCustomer.firstWhere(
                  (c) => c.customerName == newValue,
                  orElse: () => _filteredEmployeeCustomer[0],
                );
        });
        _fetchDataAccountCustomer();
      },
    );
  }

  Widget renderUserDropdown(BuildContext context) {
    final localization = AppLocalizations.of(context);
    List<String> userNames =
        _filtereddropdownEmployee.map((u) => u.label ?? '').toSet().toList();
    String allEmployeedLabel =
        localization?.translate('all_employeed') ?? 'Tất cả nhân viên';
    userNames.insert(0, allEmployeedLabel);
    if (selectedDropdownEmployee == null &&
        _filtereddropdownEmployee.isNotEmpty) {
      selectedDropdownEmployee = _filtereddropdownEmployee[0];
      _fetchData();
    }
    return buildDropdown(
      items: userNames,
      selectedItem: selectedDropdownEmployee?.label,
      hint: allEmployeedLabel,
      width: 160,
      onChanged: (String? newValue) {
        setState(() {
          if (newValue == allEmployeedLabel) {
            selectedDropdownEmployee = null;
          } else {
            selectedDropdownEmployee = _filtereddropdownEmployee.firstWhere(
              (u) => u.label == newValue,
              orElse: () => _filtereddropdownEmployee[0],
            );
          }
          _fetchData();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FittedBox(
                    child: SizedBox(
                        width: 200, child: renderCustomerDropdown(context))),
                const SizedBox(width: 6),
                FittedBox(
                    child: SizedBox(
                        width: 140, child: renderUserDropdown(context))),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _legendItems,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.33,
              child: AspectRatio(
                aspectRatio: 1.4,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              horizontalInterval: 4,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1,
                              ),
                              getDrawingVerticalLine: (value) => FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  interval: 4,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: GoogleFonts.robotoCondensed(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();

                                    if (index < 0 ||
                                        index >= monthLabels.length) {
                                      return const SizedBox.shrink();
                                    }

                                    final selectedMonth = monthLabels[index];
                                    final parts = selectedMonth.split('-');
                                    final year = parts[0];
                                    final month = parts[1];

                                    return Text(
                                      '$month/$year',
                                      style: GoogleFonts.robotoCondensed(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    );
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _completeCoSpots,
                                isCurved: true,
                                color: Colors.green,
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(show: false),
                              ),
                              LineChartBarData(
                                spots: _processingCoSpots,
                                isCurved: true,
                                color: Colors.orange,
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(show: false),
                              ),
                              LineChartBarData(
                                spots: _canceledCoSpots,
                                isCurved: true,
                                color: Colors.red,
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: const Color(0xff37434d),
                                width: 1,
                              ),
                            ),
                            minX: _minX,
                            maxX: _maxX,
                            minY: _minY,
                            maxY: _maxY,
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
