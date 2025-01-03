import 'package:app_1helo/model/dropdown_customer.dart';
import 'package:app_1helo/model/dropdown_employee.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:app_1helo/service/authservice.dart';
import 'package:flutter/material.dart';
import 'package:app_1helo/service/statistics_service.dart';
import 'package:app_1helo/model/statistics.dart';
import 'package:google_fonts/google_fonts.dart';

class TableEmployeedPage extends StatefulWidget {
  const TableEmployeedPage({
    required GlobalKey<TableEmployeedPageState> key,
  }) : super(key: key);

  @override
  TableEmployeedPageState createState() => TableEmployeedPageState();
}

class TableEmployeedPageState extends State<TableEmployeedPage> {
  List<Statistics>? statisticsList;
  bool isLoading = true;

  DropdownEmployee? selectedDropdownEmployee;
  List<DropdownEmployee> _filtereddropdownEmployee = [];
  EmployeeCustomer? selectedemployeeCustomer;
  List<EmployeeCustomer> _filteredEmployeeCustomer = [];
  String? _employeedId;
  String? _customerId;

  final _authService = AuthService();
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> refreshTabletData() async {
    setState(() {
      isLoading = true;
    });

    {
      setState(() {
        _fetchStatistics();
      });
    }
  }

  Future<void> _fetchStatistics(
      {String? customerId, String? employeeId}) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final fetchedStatistics = await StatisticsService().fetchStatistics(
        customerId: customerId,
        employeeId: employeeId,
      );

      if (mounted) {
        setState(() {
          statisticsList = fetchedStatistics ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchData({String? customerId, String? employeeId}) async {
    setState(() {
      isLoading = true;
    });

    try {
      List<EmployeeCustomer>? customer =
          await _authService.getEmployeeCustomerInfo();
      if (mounted) {
        setState(() {
          _filteredEmployeeCustomer = customer ?? [];
        });
      }

      List<DropdownEmployee>? employees = await _authService.getEmployeeInfo();
      if (mounted) {
        setState(() {
          _filtereddropdownEmployee = employees ?? [];
        });
      }

      await _fetchStatistics(customerId: customerId, employeeId: employeeId);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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

  Widget renderCustomer(BuildContext context) {
    final localization = AppLocalizations.of(context);

    List<String> customersNames = _filteredEmployeeCustomer
        .map((c) => c.customerName ?? '')
        .toSet()
        .toList();

    String allCustomersName =
        localization?.translate('all_customers') ?? 'Tất cả khách hàng';
    customersNames.insert(0, allCustomersName);

    return buildDropdown(
      items: customersNames,
      selectedItem: selectedemployeeCustomer?.customerName ?? allCustomersName,
      hint: allCustomersName,
      width: 180,
      onChanged: (String? newValue) {
        setState(() {
          if (newValue == allCustomersName) {
            selectedemployeeCustomer = null;
            _employeedId = null;
          } else {
            selectedemployeeCustomer = _filteredEmployeeCustomer.firstWhere(
              (employee) => employee.customerName == newValue,
              orElse: () => _filteredEmployeeCustomer[0],
            );
            _customerId = selectedemployeeCustomer?.customerId;
            _employeedId = selectedDropdownEmployee?.value;
          }
        });

        _fetchData(customerId: _customerId, employeeId: _employeedId);
      },
    );
  }

  Widget renderEmployeed(BuildContext context) {
    final localization = AppLocalizations.of(context);

    List<String> employeeNames = _filtereddropdownEmployee
        .map((employee) => employee.label ?? '')
        .toSet()
        .toList();

    String allEmployeesLabel =
        localization?.translate('all_employeed') ?? 'Tất cả nhân viên';
    employeeNames.insert(0, allEmployeesLabel);

    return buildDropdown(
      items: employeeNames,
      selectedItem: selectedDropdownEmployee?.label ?? allEmployeesLabel,
      hint: allEmployeesLabel,
      width: 180,
      onChanged: (String? newValue) {
        setState(() {
          if (newValue == allEmployeesLabel) {
            selectedDropdownEmployee = null;
            _employeedId = null;
          } else {
            selectedDropdownEmployee = _filtereddropdownEmployee.firstWhere(
              (employee) => employee.label == newValue,
              orElse: () => _filtereddropdownEmployee[0],
            );
            _customerId = selectedemployeeCustomer?.customerId;
            _employeedId = selectedDropdownEmployee?.value;
          }
        });

        _fetchData(customerId: _customerId, employeeId: _employeedId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    final textStyle = GoogleFonts.robotoCondensed(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    );
    final textStyleQuantity = GoogleFonts.robotoCondensed(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    );

    final Map<String, Color> statusColors = {
      "Đang chờ duyệt hủy": Colors.orange,
      "Từ chối xét duyệt": Colors.red,
      "Đã được duyệt hủy": Colors.red,
      "Chờ duyệt": Colors.orange,
      "Hoàn thành": Colors.green,
      "Đang thực hiện": Colors.black,
      "Đang chờ duyệt sửa": Colors.black,
      "Đã được duyệt sửa": Colors.black,
      "Tổng số lượng": Colors.black,
    };

    final Map<String, String> statusTranslations = {
      "Từ chối xét duyệt": localization?.translate('rejected') ?? "Rejected",
      "Đã được duyệt hủy":
          localization?.translate('approved_cancel') ?? "Approved Cancel",
      "Đang chờ duyệt hủy":
          localization?.translate('pending_cancel') ?? "Pending Cancel",
      "Chờ duyệt": localization?.translate('pending') ?? "Pending",
      "Hoàn thành": localization?.translate('completed') ?? "Completed",
      "Đang thực hiện": localization?.translate('in_progress') ?? "In Progress",
      "Đang chờ duyệt sửa":
          localization?.translate('pending_edit') ?? "Pending Edit",
      "Đã được duyệt sửa":
          localization?.translate('approved_edit') ?? "Approved Edit",
      "Tổng số lượng":
          localization?.translate('total_quantity') ?? "Total Quantity",
    };

    final allStatusNames = {
      "Hoàn thành",
      "Đã được duyệt sửa",
      "Đang chờ duyệt sửa",
      "Đang thực hiện",
      "Chờ duyệt",
      "Đang chờ duyệt hủy",
      "Từ chối xét duyệt",
      "Đã được duyệt hủy",
      "Tổng số lượng"
    };

    final statusColumns = allStatusNames.map((statusName) {
      final translatedName = statusTranslations[statusName] ?? statusName;
      final statusColor = statusColors[statusName] ?? Colors.black;

      return DataColumn(
        label: Center(
          child: Text(
            translatedName,
            style: textStyle.copyWith(color: statusColor),
          ),
        ),
      );
    }).toList();

    final columns = [
      DataColumn(
        label: Text(
          'STT',
          style: textStyle,
        ),
      ),
      DataColumn(
        label: Text(
          localization?.translate('full_name') ?? 'Full Name',
          style: textStyle,
        ),
      ),
      ...statusColumns,
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FittedBox(
                child: SizedBox(width: 200, child: renderCustomer(context))),
            FittedBox(
                child: SizedBox(width: 140, child: renderEmployeed(context))),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 380,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : statisticsList == null || statisticsList!.isEmpty
                  ? Center(
                      child: Text(localization?.translate('no_data') ??
                          'No data found'))
                  : ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: columns,
                            rows: statisticsList!.map((stat) {
                              List<DataCell> cells = [
                                DataCell(
                                  Center(
                                    child: Text(
                                      (statisticsList!.indexOf(stat) + 1)
                                          .toString(),
                                      style: textStyleQuantity,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      stat.fullName ?? 'N/A',
                                      style: textStyleQuantity,
                                    ),
                                  ),
                                ),
                                ...allStatusNames.map((statusName) {
                                  final status = stat.statuses?.firstWhere(
                                    (s) => s.statusName == statusName,
                                    orElse: () => Statuses(quantity: 0),
                                  );

                                  final statusColor =
                                      statusColors[statusName] ?? Colors.black;

                                  return DataCell(
                                    Center(
                                      child: Text(
                                        status?.quantity.toString() ?? '0',
                                        style: textStyleQuantity.copyWith(
                                            color: statusColor),
                                      ),
                                    ),
                                  );
                                }),
                              ];
                              return DataRow(cells: cells);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
        ),
      ],
    );
  }
}
