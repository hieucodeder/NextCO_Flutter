import 'package:app_1helo/model/dropdown_customer.dart';
import 'package:app_1helo/model/dropdown_employee.dart';
import 'package:app_1helo/model/table_employeed_model.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:app_1helo/service/authservice.dart';
import 'package:app_1helo/service/document_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Tableemployeedpage extends StatefulWidget {
  const Tableemployeedpage({super.key});

  @override
  State<Tableemployeedpage> createState() => TableemployeedpageState();
}

class TableemployeedpageState extends State<Tableemployeedpage> {
  EmployeeCustomer? _selectedDropdownCustomer;
  List<EmployeeCustomer> _filtereddropdownCustomer = [];

  bool isLoading = false;
  bool hasMoreData = true;
  final List<Data> _documentLits = [];
  int pageSize = 10;
  int currentPage = 1;
  int itemsPerPage = 10;
  String? _employeedId;
  String? _customerId;
  final List<int> itemsPerPageOptions = [10, 20, 30];
  DropdownEmployee? selectedDropdownEmployee;
  List<DropdownEmployee> _filtereddropdownEmployee = [];

  DocumentService documentService = DocumentService();
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData({
    String? customerId,
    String? employeedId,
  }) async {
    if (mounted) {
      setState(() {
        isLoading = true;
        _documentLits.clear();
        currentPage = 1;
        hasMoreData = true;
      });
    }

    List<EmployeeCustomer>? customers =
        await _authService.getEmployeeCustomerInfo();
    if (mounted) {
      setState(() {
        _filtereddropdownCustomer = customers ?? [];
      });
    }

    List<DropdownEmployee>? employees = await _authService.getEmployeeInfo();
    if (mounted) {
      setState(() {
        _filtereddropdownEmployee = employees ?? [];
      });
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

  Widget renderEmployeed(BuildContext context) {
    final localization = AppLocalizations.of(context);

    List<String> customerNames =
        _filtereddropdownEmployee.map((c) => c.label ?? '').toSet().toList();
    String allEmployeedLabel =
        localization?.translate('all_employeed') ?? 'Tất cả nhân viên';
    customerNames.insert(0, allEmployeedLabel);

    return buildDropdown(
      items: customerNames,
      selectedItem: selectedDropdownEmployee?.label,
      hint: allEmployeedLabel,
      width: 180,
      onChanged: (String? newValue) {
        setState(() {
          selectedDropdownEmployee = newValue == allEmployeedLabel
              ? null
              : _filtereddropdownEmployee.firstWhere(
                  (c) => c.value == newValue,
                  orElse: () => _filtereddropdownEmployee[0],
                );
          _employeedId = selectedDropdownEmployee?.label;
        });
        _fetchData(customerId: _customerId, employeedId: _employeedId);
      },
    );
  }

  Widget renderCustomer(BuildContext context) {
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
      selectedItem: _selectedDropdownCustomer?.customerName,
      hint: allCustomersLabel,
      width: 180,
      onChanged: (String? newValue) {
        setState(() {
          _selectedDropdownCustomer = newValue == allCustomersLabel
              ? null
              : _filtereddropdownCustomer.firstWhere(
                  (c) => c.customerName == newValue,
                  orElse: () => _filtereddropdownCustomer[0],
                );
          _customerId = _selectedDropdownCustomer?.customerId;
        });
        _fetchData(customerId: _customerId, employeedId: _employeedId);
      },
    );
  }

  final List<Data> sampleData = [
    Data(
      stt: 1,
      employeeName: "Nguyễn Văn A",
      completed: 5,
      inProgress: 3,
      underRepair: 1,
      waitingForRepair: 2,
      waitingForApproval: 1,
      rejected: 0,
      waitingForCancellation: 1,
      cancelled: 0,
      totalQuantity: 13,
    ),
    Data(
      stt: 2,
      employeeName: "Trần Thị B",
      completed: 7,
      inProgress: 4,
      underRepair: 2,
      waitingForRepair: 3,
      waitingForApproval: 2,
      rejected: 1,
      waitingForCancellation: 0,
      cancelled: 1,
      totalQuantity: 20,
    ),
    Data(
      stt: 3,
      employeeName: "Lê Văn C",
      completed: 10,
      inProgress: 2,
      underRepair: 0,
      waitingForRepair: 1,
      waitingForApproval: 0,
      rejected: 1,
      waitingForCancellation: 1,
      cancelled: 1,
      totalQuantity: 15,
    ),
    Data(
      stt: 4,
      employeeName: "Lê Văn D",
      completed: 10,
      inProgress: 2,
      underRepair: 0,
      waitingForRepair: 1,
      waitingForApproval: 0,
      rejected: 1,
      waitingForCancellation: 1,
      cancelled: 1,
      totalQuantity: 15,
    ),
    Data(
      stt: 5,
      employeeName: "Lê Văn E",
      completed: 10,
      inProgress: 2,
      underRepair: 0,
      waitingForRepair: 1,
      waitingForApproval: 0,
      rejected: 1,
      waitingForCancellation: 1,
      cancelled: 1,
      totalQuantity: 15,
    ),
    Data(
      stt: 6,
      employeeName: "Lê Văn F",
      completed: 10,
      inProgress: 2,
      underRepair: 0,
      waitingForRepair: 1,
      waitingForApproval: 0,
      rejected: 1,
      waitingForCancellation: 1,
      cancelled: 1,
      totalQuantity: 15,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(
                  child: SizedBox(width: 200, child: renderCustomer(context))),
              const SizedBox(
                width: 6,
              ),
              FittedBox(
                  child: SizedBox(width: 140, child: renderEmployeed(context))),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text(
                        localization?.translate('numerical_order') ?? "STT",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
                DataColumn(
                    label: Text(
                        localization?.translate("full_name") ?? "Họ và tên",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
                DataColumn(
                    label: Text(
                  localization?.translate('completed') ?? "Hoàn thành",
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                )),
                DataColumn(
                    label: Text(
                        localization?.translate('processing') ??
                            "Đang thực hiện",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue))),
                DataColumn(
                    label: Text(
                        localization?.translate('editing') ?? "Đang sửa",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
                DataColumn(
                    label: Text(
                        localization?.translate('waiting_repair') ?? "Chờ sửa",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange))),
                DataColumn(
                    label: Text(
                        localization?.translate('waiting_approval') ??
                            "Chờ duyệt",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange))),
                DataColumn(
                    label: Text(
                        localization?.translate('refused_consideration') ??
                            "Từ chối xét duyệt",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red))),
                DataColumn(
                    label: Text(
                        localization?.translate('waiting_cancel') ?? "Chờ hủy",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange))),
                DataColumn(
                    label: Text(localization?.translate('canceled') ?? "Đã hủy",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red))),
                DataColumn(
                    label: Text(
                        localization?.translate('total_quantity') ??
                            "Tổng số lượng",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
              ],
              rows: sampleData.map((data) {
                return DataRow(cells: [
                  DataCell(Center(
                      child: Text(data.stt.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)))),
                  DataCell(Center(
                      child: Text(data.employeeName ?? "",
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)))),
                  DataCell(Center(
                    child: Text(
                      data.completed.toString(),
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.green),
                    ),
                  )),
                  DataCell(Center(
                      child: Text(data.inProgress.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue)))),
                  DataCell(Center(
                      child: Text(data.underRepair.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)))),
                  DataCell(Center(
                      child: Text(data.waitingForRepair.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange)))),
                  DataCell(Center(
                      child: Text(data.waitingForApproval.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange)))),
                  DataCell(Center(
                      child: Text(data.rejected.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red)))),
                  DataCell(Center(
                      child: Text(data.waitingForCancellation.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange)))),
                  DataCell(Center(
                      child: Text(data.cancelled.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red)))),
                  DataCell(Center(
                      child: Text(data.totalQuantity.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
