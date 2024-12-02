import 'package:app_1helo/model/dropdownCustomer.dart';
import 'package:app_1helo/model/dropdownEmployee.dart';
import 'package:app_1helo/model/tableEmployeedModel.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:app_1helo/service/document_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Tableemployeedpage extends StatefulWidget {
  const Tableemployeedpage({super.key});

  @override
  State<Tableemployeedpage> createState() => TableemployeedpageState();
}

class TableemployeedpageState extends State<Tableemployeedpage> {
  EmployeeCustomer? selectedDropdownCustomer;
  List<EmployeeCustomer> _filtereddropdownCustomer = [];
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  bool isLoading = false;
  bool hasMoreData = true;
  List<Data> documentLits = [];
  int pageSize = 10;
  int currentPage = 1;
  int itemsPerPage = 10;
  String? _employeedId;
  String? _customerId;
  final List<int> itemsPerPageOptions = [10, 20, 30];
  dropdownEmployee? selectedDropdownEmployee;
  List<dropdownEmployee> _filtereddropdownEmployee = [];

  DocumentService documentService = DocumentService();
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _searchCustomers(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }
  }

  Future<void> _fetchData({
    String? customerId,
    String? employeedId,
  }) async {
    if (mounted) {
      setState(() {
        isLoading = true;
        documentLits.clear();
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

    List<dropdownEmployee>? employees = await _authService.getEmployeeInfo();
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
          style: const TextStyle(fontSize: 13, color: Colors.black),
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
              style: const TextStyle(fontSize: 13, color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget renderEmployeed() {
    List<String> customerNames =
        _filtereddropdownEmployee.map((c) => c.label ?? '').toSet().toList();
    customerNames.insert(0, 'Tất cả nhân viên');

    return buildDropdown(
      items: customerNames,
      selectedItem: selectedDropdownEmployee?.label,
      hint: 'Tất cả nhân viên',
      width: 180,
      onChanged: (String? newValue) {
        setState(() {
          selectedDropdownEmployee = newValue == 'Tất cả nhân viên'
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

  Widget renderCustomer() {
    List<String> customerNames = _filtereddropdownCustomer
        .map((c) => c.customerName ?? '')
        .toSet()
        .toList();
    customerNames.insert(0, 'Tất cả khách hàng');

    return buildDropdown(
      items: customerNames,
      selectedItem: selectedDropdownCustomer?.customerName,
      hint: 'Tất khách hàng',
      width: 180,
      onChanged: (String? newValue) {
        setState(() {
          selectedDropdownCustomer = newValue == 'Tất cả khách hàng'
              ? null
              : _filtereddropdownCustomer.firstWhere(
                  (c) => c.customerName == newValue,
                  orElse: () => _filtereddropdownCustomer[0],
                );
          _customerId = selectedDropdownCustomer?.customerId;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(child: SizedBox(width: 200, child: renderCustomer())),
              const SizedBox(
                width: 6,
              ),
              FittedBox(child: SizedBox(width: 140, child: renderEmployeed())),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text("STT",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
                DataColumn(
                    label: Text("Họ tên",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
                DataColumn(
                    label: Text(
                  "Hoàn thành",
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                )),
                DataColumn(
                    label: Text("Đang thực hiện",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue))),
                DataColumn(
                    label: Text("Đang sửa",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
                DataColumn(
                    label: Text("Chờ sửa",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange))),
                DataColumn(
                    label: Text("Chờ duyệt",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange))),
                DataColumn(
                    label: Text("Từ chối xét duyệt",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red))),
                DataColumn(
                    label: Text("Chờ hủy",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange))),
                DataColumn(
                    label: Text("Đã hủy",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red))),
                DataColumn(
                    label: Text("Tổng số lượng",
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)))),
                  DataCell(Center(
                      child: Text(data.employeeName ?? "",
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)))),
                  DataCell(Center(
                    child: Text(
                      data.completed.toString(),
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.green),
                    ),
                  )),
                  DataCell(Center(
                      child: Text(data.inProgress.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue)))),
                  DataCell(Center(
                      child: Text(data.underRepair.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)))),
                  DataCell(Center(
                      child: Text(data.waitingForRepair.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange)))),
                  DataCell(Center(
                      child: Text(data.waitingForApproval.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange)))),
                  DataCell(Center(
                      child: Text(data.rejected.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red)))),
                  DataCell(Center(
                      child: Text(data.waitingForCancellation.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange)))),
                  DataCell(Center(
                      child: Text(data.cancelled.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red)))),
                  DataCell(Center(
                      child: Text(data.totalQuantity.toString(),
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
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
