// ignore_for_file: use_build_context_synchronously, empty_catches

import 'dart:async';
import 'package:app_1helo/model/dropdown_employee.dart';
import 'package:app_1helo/model/piechar_model.dart';
import 'package:app_1helo/model/user.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:app_1helo/service/authservice.dart';
import 'package:app_1helo/service/piechar_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:app_1helo/model/dropdown_customer.dart';

class Piechartpage extends StatefulWidget {
  const Piechartpage({super.key});

  @override
  PiechartpageState createState() => PiechartpageState();
}

class PiechartpageState extends State<Piechartpage> {
  final AuthService _athServiceService = AuthService();
  Map<String, double> dataMap = {};
  DataUser? selectedUsers;
  DropdownEmployee? selectedDropdownEmployee;
  List<DropdownEmployee> _filtereddropdownEmployee = [];
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
      _fetchData();
      _fetchDataCustomer();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshChartData();
  }

//Refres
  Future<void> refreshChartData() async {
    setState(() {});

    {
      setState(() {
        _fetchData();
        _fetchDataCustomer();
      });
    }
  }

  Future<void> _fetchData() async {
    await _fetchPieChartData(
      startDate != null ? DateTime.parse(startDate!) : null,
      endDate != null ? DateTime.parse(endDate!) : null,
      selectedDropdownEmployee?.value,
      selectedDropdownCustomer?.customerId,
      true,
    );
  }

  Future<void> _fetchDataCustomer() async {
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

      await _fetchEmployeeOrCustomerData(isUserFetch);

      _processPieChartData(pieChartData);
    } catch (e) {
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
    final localization = AppLocalizations.of(context);

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
                  "${localization?.translate('completed') ?? 'Hoàn thành'}: ($completedTotal)":
                      (completedTotal / total) * 100,
                if (processingTotal > 0)
                  "${localization?.translate('processing') ?? 'Đang thực hiện'}: ($processingTotal)":
                      (processingTotal / total) * 100,
                if (waitingcancelTotal > 0)
                  "${localization?.translate('waiting_cancel') ?? 'Chờ hủy'}: ($waitingcancelTotal)":
                      (waitingcancelTotal / total) * 100,
                if (waitingTotal > 0)
                  "${localization?.translate('waiting_approval') ?? 'Chờ duyệt'}: ($waitingTotal)":
                      (waitingTotal / total) * 100,
                if (refusedconsider > 0)
                  "${localization?.translate('refused_consideration') ?? 'Từ chối xét duyệt'}: ($refusedconsider)":
                      (refusedconsider / total) * 100,
                if (cancel > 0)
                  "${localization?.translate('canceled') ?? 'Đã hủy'}: ($cancel)":
                      (cancel / total) * 100,
                if (editor > 0)
                  "${localization?.translate('editing') ?? 'Đang sửa'}: ($editor)":
                      (editor / total) * 100,
                if (waitingrepair > 0)
                  "${localization?.translate('waiting_repair') ?? 'Chờ sửa'}: ($waitingrepair)":
                      (waitingrepair / total) * 100,
              }
            : {localization?.translate('no_data') ?? 'Không có dữ liệu': 0};
      });
    } else {
      setState(() {
        final noDataText =
            localization?.translate('no_data') ?? 'Không có dữ liệu';
        dataMap = {noDataText: 0};
      });
    }
  }

  List<Color> _getPieChartColors(BuildContext context) {
    final localization = AppLocalizations.of(context);
    if (dataMap.containsKey(
        localization?.translate('no_data') ?? 'Không có dữ liệu')) {
      return [Colors.grey];
    }

    return [
      Colors.green,
      Colors.black,
      Colors.orange,
      Colors.orange,
      Colors.red,
      Colors.red,
      Colors.black,
      Colors.black,
    ];
  }

  Future<void> _fetchEmployeeOrCustomerData(bool isUserFetch) async {
    if (isUserFetch) {
      List<DropdownEmployee>? employees =
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
      if (mounted) {
        setState(() {});
      }
    } catch (e) {}
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
          style: GoogleFonts.robotoCondensed(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
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
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
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
    List<String> customerNames = _filtereddropdownCustomer
        .map((c) => c.customerName ?? '')
        .toSet()
        .toList();
    String allCustomersLabel =
        localization?.translate('all_customers') ?? 'Tất cả khách hàng';
    customerNames.insert(0, allCustomersLabel);

    return buildDropdown(
      items: customerNames,
      selectedItem: selectedDropdownCustomer?.customerName,
      hint: allCustomersLabel,
      width: 180,
      onChanged: (String? newValue) {
        setState(() {
          selectedDropdownCustomer = newValue == allCustomersLabel
              ? null
              : _filtereddropdownCustomer.firstWhere(
                  (c) => c.customerName == newValue,
                  orElse: () => _filtereddropdownCustomer[0],
                );
        });
        _fetchDataCustomer();
      },
    );
  }

  Widget renderUserDropdown(BuildContext context) {
    final localization = AppLocalizations.of(context);
    List<String> userNames =
        _filtereddropdownEmployee.map((u) => u.label ?? '').toSet().toList();
    String allCustomersLabel =
        localization?.translate('all_employeed') ?? 'Tất cả nhân viên';
    userNames.insert(0, allCustomersLabel);
    if (selectedDropdownEmployee == null &&
        _filtereddropdownEmployee.isNotEmpty) {
      selectedDropdownEmployee = _filtereddropdownEmployee[0];
      _fetchData();
    }
    return buildDropdown(
      items: userNames,
      selectedItem: selectedDropdownEmployee?.label,
      hint: allCustomersLabel,
      width: 160,
      onChanged: (String? newValue) {
        setState(() {
          if (newValue == allCustomersLabel) {
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
      // Show the date picker to select the end date
      final DateTime? endPicked = await showDatePicker(
        context: context,
        initialDate: startPicked.add(const Duration(days: 1)),
        firstDate: startPicked,
        lastDate: DateTime(2101),
      );

      if (endPicked != null) {
        // Set the selected date range
        setState(() {
          startDate = DateFormat('yyyy-MM-dd').format(startPicked);
          endDate = DateFormat('yyyy-MM-dd').format(endPicked);
          _controller.text =
              '$startDate - $endDate'; // Update the text controller
        });

        // Call function to fetch and update data based on selected date range
        await _updateDocumentsByDateRange();
      }
    }
  }

  Future<void> _updateDocumentsByDateRange() async {
    // Ensure both start and end dates are selected
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

        setState(() {
          pieCharChartData = pieCharData.isNotEmpty ? pieCharData : [];
          _processPieChartData(pieCharData);
        });

        if (pieCharData.isEmpty) {}
      } catch (e) {
        setState(() {
          pieCharChartData = [];
        });
      } finally {
        setState(() {
          _isFetchingData = false;
        });
      }
    } else {}
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
    final localization = AppLocalizations.of(context);

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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _controller,
                          readOnly: true,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: localization?.translate('date') ??
                                'Chọn ngày bắt đầu và kết thúc',
                            hintStyle: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    if (_controller.text.isNotEmpty)
                      GestureDetector(
                        onTap: _clearDateRange,
                        child: const Icon(
                          Icons.close_sharp,
                          color: Colors.black54,
                          size: 20,
                        ),
                      ),
                    const VerticalDivider(
                      width: 20,
                      thickness: 1,
                      color: Colors.black38,
                    ),
                    GestureDetector(
                      onTap: _selectDateRange,
                      child: const Icon(Icons.calendar_today,
                          color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FittedBox(
                        child: SizedBox(
                            width: 200,
                            child: renderCustomerDropdown(context))),
                    const SizedBox(width: 6.0),
                    FittedBox(
                        child: SizedBox(
                            width: 140, child: renderUserDropdown(context))),
                  ],
                ),
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
                        colorList: _getPieChartColors(context),
                        animationDuration: const Duration(milliseconds: 800),
                        chartRadius: MediaQuery.of(context).size.width / 1.5,
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