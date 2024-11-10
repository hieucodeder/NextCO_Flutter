import 'package:app_1helo/model/dropdownCustomer.dart';
import 'package:app_1helo/model/prodcutReportModel.dart';
import 'package:app_1helo/model/prodcutReportModel.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:app_1helo/service/productReport_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Productreportpage extends StatefulWidget {
  const Productreportpage({super.key});

  @override
  State<Productreportpage> createState() => _ProductreportpageState();
}

class _ProductreportpageState extends State<Productreportpage> {
  int itemsPerPage = 10;
  final List<int> itemsPerPageOptions = [10, 20, 30, 50];
  int currentPage = 1;
  final int pageSize = 10;

  bool isLoading = false;
  bool hasMoreData = true;
  bool _isSearching = false;

  List<Data> allProductReport = [];
  List<Data> displayList = [];
  List<Data> _searchResults = [];

  List<EmployeeCustomer> _filteredEmployeeCustomer = [];
  EmployeeCustomer? selectedEmployeeCustomer;

  String? customerid;
  String? search;
  String? startDate1;
  String? endDate1;

  ProductReportService _productreportService = ProductReportService();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchInitialProducts();
    _scrollController.addListener(_onScroll);
    _fetchCustomerData();
  }

  Future<void> fetchInitialProducts() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    List<Data> initialProducts = await _productreportService
        .fetchProductsReport(currentPage, pageSize, search, customerid);

    if (mounted) {
      setState(() {
        allProductReport = initialProducts;
        displayList = initialProducts;
        isLoading = false;
        hasMoreData = initialProducts.length == pageSize;
      });
    }
  }

  Future<void> _searchProducts(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
        displayList = allProductReport;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults.clear();
      currentPage = 1;
      hasMoreData = true;
    });

    List<Data> results = await _productreportService.fetchProductsReport(
        currentPage, pageSize, searchQuery, customerid);
    if (mounted) {
      setState(() {
        _searchResults = results;
        displayList = _searchResults;
        hasMoreData = results.length == pageSize;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading &&
        hasMoreData) {
      _loadMoreProducts();
    }
  }

  Future<void> _fetchCustomerData() async {
    setState(() => isLoading = true);

    try {
      List<EmployeeCustomer>? employees =
          await _authService.getEmployeeCustomerInfo();
      if (mounted) {
        setState(() {
          _filteredEmployeeCustomer = employees ?? [];
        });
      }
    } catch (e) {
      print('Error fetching customer data: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _fetchMaterialsReport(String? customerId) async {
    if (customerId == null) return;

    setState(() {
      allProductReport.clear();
      displayList.clear();
      currentPage = 1;
      hasMoreData = true;
    });

    List<Data> reportData = await _productreportService.fetchProductsReport(
        currentPage, pageSize, search, customerId);

    if (mounted) {
      setState(() {
        allProductReport = reportData;
        displayList = reportData;
        hasMoreData = reportData.length == pageSize;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    if (isLoading || !hasMoreData) return;

    setState(() => isLoading = true);
    currentPage++;

    List<Data> moreProducts = await _productreportService.fetchProductsReport(
        currentPage, pageSize, search, customerid);

    if (mounted) {
      setState(() {
        allProductReport.addAll(moreProducts);
        displayList.addAll(moreProducts);
        isLoading = false;
        hasMoreData = moreProducts.length == pageSize;
      });
    }
  }

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
          startDate1 = DateFormat('yyyy-MM-dd').format(startPicked);
          endDate1 = DateFormat('yyyy-MM-dd').format(endPicked);
          _searchDate.text = '$startDate1 - $endDate1';
        });

        await _updateDocumentsByDateRange();
      }
    }
  }

  Future<void> _updateDocumentsByDateRange() async {
    try {
      final DateTime parsedStartDate =
          DateFormat('yyyy-MM-dd').parse(startDate1!);
      final DateTime parsedEndDate = DateFormat('yyyy-MM-dd').parse(endDate1!);

      List<Data> dateFilteredList =
          await _productreportService.fetchProductsReportDate(
        parsedStartDate,
        parsedEndDate,
      );

      if (mounted) {
        setState(() {
          allProductReport = dateFilteredList;
          displayList = dateFilteredList;
        });
      }
    } catch (error) {
      print('Error searching documents by date range: ${error.toString()}');
    }
  }

  void _clearDateRange() {
    if (mounted) {
      setState(() {
        startDate1 = null;
        endDate1 = null;
        _searchDate.clear();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _searchDate.dispose();
    super.dispose();
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
        color: Colors.white,
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
        onChanged: onChanged,
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

  Widget renderCustomerDrop() {
    List<String> customerName = _filteredEmployeeCustomer
        .map((u) => u.customerName ?? '')
        .toSet()
        .toList();

    if (selectedEmployeeCustomer == null &&
        _filteredEmployeeCustomer.isNotEmpty) {
      selectedEmployeeCustomer = _filteredEmployeeCustomer[0];
      customerid = selectedEmployeeCustomer?.customerId;
      _fetchMaterialsReport(customerid);
    }

    return buildDropdown(
      items: customerName,
      selectedItem: selectedEmployeeCustomer?.customerName,
      hint: 'Chọn khách hàng',
      onChanged: (String? newvalue) {
        setState(() {
          selectedEmployeeCustomer = newvalue == 'Chọn khách hàng'
              ? null
              : _filteredEmployeeCustomer.firstWhere(
                  (u) => u.customerName == newvalue,
                  orElse: () => _filteredEmployeeCustomer[0],
                );
          customerid = selectedEmployeeCustomer?.customerId;
          _fetchMaterialsReport(customerid);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Data> displayList = _isSearching
        ? _searchResults
        : (startDate1 != null && endDate1 != null
            ? allProductReport.where((data) {
                if (data.dateOfDeclaration != null) {
                  DateTime dataDate = DateTime.parse(data.dateOfDeclaration!);
                  DateTime parsedStartDate = DateTime.parse(startDate1!);
                  DateTime parsedEndDate = DateTime.parse(endDate1!);
                  return dataDate.isAfter(parsedStartDate) &&
                      dataDate.isBefore(parsedEndDate);
                }
                return false;
              }).toList()
            : allProductReport);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.grey[200],
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
                      controller: _searchDate,
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
                  if (_searchDate.text.isNotEmpty)
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
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black38),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Số hồ sơ, tờ khai xuất, tình trạng',
                      hintStyle: GoogleFonts.robotoCondensed(
                          fontSize: 14, color: Colors.black38),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _searchProducts(_searchController.text);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VerticalDivider(
                              width: 20,
                              thickness: 1,
                              color: Colors.black38,
                            ),
                            Icon(Icons.search_outlined)
                          ],
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              renderCustomerDrop(),
            ],
          ),
          Expanded(
            child: displayList.isEmpty && isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayList.isEmpty
                    ? Center(
                        child: Text(
                          "Dữ liệu tìm kiếm không có!!!",
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
                              color: Provider.of<Providercolor>(context)
                                  .selectedColor),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[100],
                            border: Border.all(width: 1, color: Colors.black12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x005c6566).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]),
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            radius: const Radius.circular(10),
                            thickness: 8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('STT')),
                                    DataColumn(label: Text('Mã sản phẩm')),
                                    DataColumn(label: Text('Tên sản phẩm')),
                                    DataColumn(label: Text('Mã HS')),
                                    DataColumn(label: Text('Số TKX')),
                                    DataColumn(label: Text('Số lượng đã làm')),
                                    DataColumn(label: Text('Số lượng tồn')),
                          
                                  ],
                                  rows: displayList.map((doc) {
                                    return DataRow(cells: [
                                      DataCell(Text(
                                          doc.rowNumber?.toString() ?? '')),
                              
                                      DataCell(Text(doc.productCode ?? '')),
                                      DataCell(Text(doc.hsCode ?? '')),
                                      DataCell(Text(doc.productName ?? '')),
                                      DataCell(Text(doc.exportDeclarationNumber
                                              ?.toString() ??
                                          '')),
                                      DataCell(
                                          Text(doc.coUsed?.toString() ?? '')),
                                      DataCell(Text(
                                          doc.coAvailable?.toString() ?? '')),
                                  
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: currentPage > 1 ? () => (currentPage - 1) : null,
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.black12,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 3.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    '$currentPage',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                IconButton(
                  onPressed: () => (currentPage + 1),
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Colors.black12,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.black12)),
                  child: DropdownButton<int>(
                    value: itemsPerPage,
                    items: itemsPerPageOptions.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value/trang'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        itemsPerPage = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
