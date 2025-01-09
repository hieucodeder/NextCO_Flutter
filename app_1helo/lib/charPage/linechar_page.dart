// ignore_for_file: empty_catches, library_prefixes

import 'dart:async';
import 'package:app_1helo/model/customers.dart' as Customers;
import 'package:app_1helo/model/dropdown_customer.dart';
import 'package:app_1helo/model/dropdown_employee.dart';
import 'package:app_1helo/model/linechar_model.dart';
import 'package:app_1helo/model/user.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:app_1helo/service/authservice.dart';
import 'package:app_1helo/service/linechar_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_1helo/Cusstom/legend_item.dart';
import 'package:google_fonts/google_fonts.dart';

class Linecharpage extends StatefulWidget {
  const Linecharpage({super.key});

  @override
  LinecharpageState createState() => LinecharpageState();
}

class LinecharpageState extends State<Linecharpage> {
  final _searchControllerCustomer = TextEditingController();
  final _searchControllerUsers = TextEditingController();

  final LinecharService _lineChartService = LinecharService();
  final AuthService _athServiceService = AuthService();

  DataUser? selectedUsers;
  Data? selectedLineChar;
  Customers.Data? selectedCustomer;

  DropdownEmployee? selectedDropdownEmployee;
  List<DropdownEmployee> _filtereddropdownEmployee = [];

  EmployeeCustomer? selectedemployeeCustomer;
  List<EmployeeCustomer> _filteredEmployeeCustomer = [];

  List<FlSpot> _completeCoSpots = [];
  List<FlSpot> _processingCoSpots = [];
  List<FlSpot> _canceledCoSpots = [];

  List<Widget> _legendItems = [];
  List<String> _monthLabels = [];

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
      _fetchUsersData(),
    ]);
    if (mounted) {
      _fetchData();
      _fetchDataAccountCustomer();
    }
  }

  Future<void> _fetchUsersData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Fetch data logic if any (Currently empty)
    } catch (e) {
      // Handle any exceptions (optional logging)
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchData() async {
    await _fetchLineChartData(
      selectedDropdownEmployee?.value,
      selectedemployeeCustomer?.customerId,
      fetchEmployees: true,
      fetchCustomers: false,
    );
  }

  Future<void> _fetchDataAccountCustomer() async {
    await _fetchLineChartData(
      selectedDropdownEmployee?.value,
      selectedemployeeCustomer?.customerId,
      fetchEmployees: false,
      fetchCustomers: true,
    );
  }

  Future<void> _fetchLineChartData(
    String? employeeId,
    String? customerId, {
    required bool fetchEmployees,
    required bool fetchCustomers,
  }) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch line chart data
      LinecharModel? lineChartResponse =
          await _lineChartService.fetchLineChartData(employeeId, customerId);

      // Fetch employees or customers as needed
      if (fetchEmployees) {
        List<DropdownEmployee>? employees =
            await _athServiceService.getEmployeeInfo();
        if (employees != null && mounted) {
          setState(() {
            _filtereddropdownEmployee = employees;
          });
        }
      }

      if (fetchCustomers) {
        List<EmployeeCustomer>? customers =
            await _athServiceService.getEmployeeCustomerInfo();
        if (customers != null && mounted) {
          setState(() {
            _filteredEmployeeCustomer = customers;
          });
        }
      }

      if (mounted) {
        _clearChartData();

        // Get the separate FlSpot lists
        Map<String, List<FlSpot>> flSpotMap = _mapDataToFlSpot(
          lineChartResponse!.data!.completeCo,
          lineChartResponse.data!.processingCo,
          lineChartResponse.data!.canceledCo,
        );

        // Update chart data for each status
        if (flSpotMap.containsKey('complete') &&
            flSpotMap['complete']!.isNotEmpty) {
          _completeCoSpots = flSpotMap['complete']!;
        }

        if (flSpotMap.containsKey('processing') &&
            flSpotMap['processing']!.isNotEmpty) {
          _processingCoSpots = flSpotMap['processing']!;
        }

        if (flSpotMap.containsKey('canceled') &&
            flSpotMap['canceled']!.isNotEmpty) {
          _canceledCoSpots = flSpotMap['canceled']!;
        }

        _calculateAxisRanges();
        _updateLegendItems();
      }
    } catch (e) {
      print("Error fetching line chart data: $e");
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
            text: localization?.translate('corrected') ?? 'Đã sửa',
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

  Map<String, List<FlSpot>> _mapDataToFlSpot(
    List<dynamic>? completeData,
    List<dynamic>? processingData,
    List<dynamic>? canceledData,
  ) {
    if ((completeData == null || completeData.isEmpty) &&
        (processingData == null || processingData.isEmpty) &&
        (canceledData == null || canceledData.isEmpty)) {
      return {};
    }

    final Map<String, Map<String, double?>> monthQuantityMap = {
      'complete': {},
      'processing': {},
      'canceled': {},
    };

    DateTime? minDate;
    DateTime? maxDate;

    void processData(List<dynamic>? data, String status) {
      if (data == null) return;
      for (var entry in data) {
        Map<String, dynamic> value = entry.toJson();
        try {
          String createdDateStr = value["created_date"] ?? '';
          DateTime createdDate = DateTime.parse(createdDateStr);
          String monthKey =
              "${createdDate.year}-${createdDate.month.toString().padLeft(2, '0')}";

          double quantity =
              double.tryParse(value['quantity']?.toString() ?? '0') ?? 0;

          monthQuantityMap[status]!.update(
            monthKey,
            (existingQty) => (existingQty ?? 0) + quantity,
            ifAbsent: () => quantity,
          );

          minDate ??= createdDate;
          maxDate ??= createdDate;

          if (createdDate.isBefore(minDate!)) {
            minDate = createdDate;
          }
          if (createdDate.isAfter(maxDate!)) {
            maxDate = createdDate;
          }
        } catch (e) {
          continue;
        }
      }
    }

    processData(completeData, 'complete');
    processData(processingData, 'processing');
    processData(canceledData, 'canceled');

    if (minDate == null || maxDate == null) return {};

    List<String> monthLabels = [];
    DateTime currentDate = minDate!;
    while (currentDate.isBefore(maxDate!) ||
        currentDate.isAtSameMomentAs(maxDate!)) {
      String monthKey =
          "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}";
      monthLabels.add(monthKey);
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }

    // In ra kiểm tra trước khi áp dụng lọc
    print("Before filtering, Month Labels: $monthLabels");

    // Giữ lại 10 tháng mới nhất
    if (monthLabels.length > 6) {
      monthLabels = monthLabels.sublist(monthLabels.length - 6);
    }

    // In ra sau khi lọc
    print("After filtering, Month Labels: $monthLabels");

    // Đảm bảo mọi trạng thái có dữ liệu cho các tháng này
    for (var month in monthLabels) {
      for (var status in monthQuantityMap.keys) {
        if (!monthQuantityMap[status]!.containsKey(month)) {
          monthQuantityMap[status]![month] = null;
        }
      }
    }

    // Tạo danh sách FlSpot cho biểu đồ
    Map<String, List<FlSpot>> flSpotMap = {
      'complete': [],
      'processing': [],
      'canceled': [],
    };

    for (int xIndex = 0; xIndex < monthLabels.length; xIndex++) {
      final month = monthLabels[xIndex];
      double? completeQty = monthQuantityMap['complete']![month];
      double? processingQty = monthQuantityMap['processing']![month];
      double? canceledQty = monthQuantityMap['canceled']![month];

      if (completeQty != null) {
        flSpotMap['complete']!.add(FlSpot(xIndex.toDouble(), completeQty));
      }
      if (processingQty != null) {
        flSpotMap['processing']!.add(FlSpot(xIndex.toDouble(), processingQty));
      }
      if (canceledQty != null) {
        flSpotMap['canceled']!.add(FlSpot(xIndex.toDouble(), canceledQty));
      }
    }

    // Cập nhật _monthLabels cho getTitlesWidget
    _monthLabels = monthLabels.map((month) {
      final parts = month.split('-');
      final year = parts[0];
      final monthNum = int.parse(parts[1]);
      return "${monthNum.toString().padLeft(2, '0')}/$year";
    }).toList();

    return flSpotMap;
  }

  void _calculateAxisRanges() {
    List<FlSpot> allSpots = [
      ..._completeCoSpots,
      ..._processingCoSpots,
      ..._canceledCoSpots
    ];

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

    // Danh sách tên khách hàng
    List<String> userNames = _filteredEmployeeCustomer
        .map((u) => u.customerName ?? '')
        .toSet()
        .toList();

    // Gắn thêm mục 'Tất cả khách hàng'
    String allCustomersLabel =
        localization?.translate('all_customers') ?? 'Tất cả khách hàng';
    userNames.insert(0, allCustomersLabel);

    return buildDropdown(
      items: userNames,
      selectedItem: selectedemployeeCustomer?.customerName ?? allCustomersLabel,
      hint: allCustomersLabel,
      width: 180,
      onChanged: (String? newValue) {
        setState(() {
          if (newValue == allCustomersLabel) {
            selectedemployeeCustomer = null;
          } else {
            selectedemployeeCustomer = _filteredEmployeeCustomer.firstWhere(
              (c) => c.customerName == newValue,
              orElse: () => _filteredEmployeeCustomer.isNotEmpty
                  ? _filteredEmployeeCustomer.first
                  : EmployeeCustomer(),
            );
          }
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
      selectedItem: selectedDropdownEmployee?.label ?? allEmployeedLabel,
      hint: allEmployeedLabel,
      width: 160,
      onChanged: (String? newValue) {
        setState(() {
          if (newValue == allEmployeedLabel) {
            selectedDropdownEmployee = null;
          } else {
            selectedDropdownEmployee = _filtereddropdownEmployee.firstWhere(
              (u) => u.label == newValue,
              orElse: () => _filtereddropdownEmployee.isNotEmpty
                  ? _filtereddropdownEmployee.first
                  : DropdownEmployee(),
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
            child: Column(children: [
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
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
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
                                          index >= _monthLabels.length) {
                                        return const SizedBox.shrink();
                                      }
                                      return Text(
                                        _monthLabels[index],
                                        style: GoogleFonts.robotoCondensed(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
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
              )
            ])));
  }
}
