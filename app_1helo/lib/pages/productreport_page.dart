// ignore_for_file: use_build_context_synchronously

import 'package:app_1helo/model/dropdown_customer.dart';
import 'package:app_1helo/model/prodcutreport_model.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:app_1helo/service/authservice.dart';
import 'package:app_1helo/service/product_report_service.dart';
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
  final List<int> itemsPerPageOptions = [10, 20, 30];
  int currentPage = 1;
  final int pageSize = 10;

  bool isLoading = false;
  bool hasMoreData = true;
  bool _isSearching = false;

  List<DataModel> productReportList = [];
  List<DataModel> _searchResults = [];

  List<EmployeeCustomer> _filteredEmployeeCustomer = [];
  EmployeeCustomer? selectedEmployeeCustomer;

  String? _customerid;
  String? search;
  String? startDate1;
  String? endDate1;

  final ProductReportService _productreportService = ProductReportService();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchInitialProductsResPort();
    _scrollController.addListener(_onScroll);
    _fetchData();
  }

  Future<void> fetchInitialProductsResPort() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    List<DataModel> initialProducts = await _productreportService
        .fetchProductsReport(currentPage, itemsPerPage, search, _customerid);

    if (mounted) {
      setState(() {
        productReportList = initialProducts;
        isLoading = false;
        if (initialProducts.length < itemsPerPage) {
          hasMoreData = false;
        }
      });
    }
  }

  Future<void> _searchProducts(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    List<DataModel> results = await _productreportService.fetchProductsReport(
        currentPage, pageSize, searchQuery, _customerid);
    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = true;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading &&
        hasMoreData) {
      _loadMoreProductsResPort();
    }
  }

  Future<void> _fetchData({
    String? customerId,
  }) async {
    if (mounted) {
      setState(() {
        isLoading = true;
        productReportList.clear();
        currentPage = 1;
        hasMoreData = true;
      });
    }

    try {
      List<EmployeeCustomer>? customers =
          await _authService.getEmployeeCustomerInfo();
      if (mounted) {
        setState(() {
          _filteredEmployeeCustomer = customers ?? [];
        });
      }

      List<DataModel> reportData = await _productreportService
          .fetchProductsReport(currentPage, pageSize, search, customerId);
      if (mounted) {
        setState(() {
          productReportList = reportData;
          if (reportData.length < itemsPerPage) {
            hasMoreData = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasMoreData = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreProductsResPort() async {
    if (isLoading || !hasMoreData) return;

    setState(() => isLoading = true);
    currentPage++;

    List<DataModel> moreProductsResPort = await _productreportService
        .fetchProductsReport(currentPage, pageSize, search, _customerid);

    if (mounted) {
      setState(() {
        productReportList.addAll(moreProductsResPort);
        isLoading = false;
        if (moreProductsResPort.length < pageSize) {
          hasMoreData = false;
        }
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

      List<DataModel> dateFilteredList =
          await _productreportService.fetchProductsReportDate(
        parsedStartDate,
        parsedEndDate,
      );

      if (mounted) {
        setState(() {
          productReportList = dateFilteredList;
        });
      }
    // ignore: empty_catches
    } catch (error) {}
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

    List<String> customerNames = _filteredEmployeeCustomer
        .map((u) => u.customerName ?? '')
        .toSet()
        .toList();

    String allCustomersLabel =
        localization?.translate('all_customers') ?? 'Tất cả khách hàng';
    customerNames.insert(0, allCustomersLabel);

    return buildDropdown(
      items: customerNames,
      selectedItem: selectedEmployeeCustomer?.customerName,
      hint: allCustomersLabel,
      onChanged: (String? newValue) {
        setState(() {
          selectedEmployeeCustomer = newValue == allCustomersLabel
              ? null
              : _filteredEmployeeCustomer.firstWhere(
                  (u) => u.customerName == newValue,
                  orElse: () => _filteredEmployeeCustomer[0],
                );

          _customerid = selectedEmployeeCustomer?.customerId;
        });
        _fetchData(customerId: _customerid);
      },
    );
  }

  final _textxData = GoogleFonts.robotoCondensed(
      fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500);
  final _textTitile = GoogleFonts.robotoCondensed(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    List<DataModel> displayList = _isSearching
        ? _searchResults
        : (startDate1 != null && endDate1 != null
            ? productReportList.where((data) {
                if (data.dateOfDeclaration != null) {
                  DateTime dataDate = DateTime.parse(data.dateOfDeclaration!);
                  DateTime parsedStartDate = DateTime.parse(startDate1!);
                  DateTime parsedEndDate = DateTime.parse(endDate1!);
                  return dataDate.isAfter(parsedStartDate) &&
                      dataDate.isBefore(parsedEndDate);
                }
                return false;
              }).toList()
            : productReportList);
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: TextField(
                        controller: _searchDate,
                        readOnly: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: localization?.translate('date') ??
                              'Chọn ngày bắt đầu và kết thúc',
                          hintStyle: GoogleFonts.robotoCondensed(
                            fontSize: 15,
                            color: Colors.black38,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  if (_searchDate.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _clearDateRange();
                      },
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
                    child:
                        const Icon(Icons.calendar_today, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(
                  child: SizedBox(
                      width: 200, child: renderCustomerDropdown(context))),
              const SizedBox(width: 10),
              FittedBox(
                child: Container(
                  width: 160,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black38),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText:
                          localization?.translate('search_productResport') ??
                              'Mã sản phẩm, tên sản phẩm',
                      hintStyle: GoogleFonts.robotoCondensed(
                          fontSize: 15, color: Colors.black38),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: StatefulBuilder(
                        builder: (context, setState) {
                          bool isPressed = false;

                          return GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                isPressed = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                isPressed = false;
                              });
                              _searchProducts(_searchController.text);
                            },
                            onTapCancel: () {
                              setState(() {
                                isPressed = false;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const VerticalDivider(
                                  width: 20,
                                  thickness: 1,
                                  color: Colors.black38,
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isPressed
                                        // ignore: dead_code
                                        ? Colors.grey[200]
                                        : Colors.transparent,
                                    shape: BoxShape.circle, // Làm nút tròn
                                  ),
                                  child: const Icon(Icons.search_outlined),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      contentPadding: const EdgeInsets.all(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: displayList.isEmpty && isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayList.isEmpty
                    ? Center(
                        child: Text(
                          localization?.translate('data_null') ??
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
                                columns: [
                                  DataColumn(
                                      label: Text('STT', style: _textTitile)),
                                  DataColumn(
                                      label: Text('Mã sản phẩm',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text('Tên sản phẩm',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text('Mã HS', style: _textTitile)),
                                  DataColumn(
                                      label:
                                          Text('Số TKX', style: _textTitile)),
                                  DataColumn(
                                      label: Text('Số lượng đã làm',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text('Số lượng tồn',
                                          style: _textTitile)),
                                ],
                                rows: displayList.map((doc) {
                                  return DataRow(cells: [
                                    DataCell(Center(
                                        child: Text(
                                      doc.rowNumber?.toString() ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                        child: Text(
                                      doc.productCode ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Text(doc.hsCode ?? '')),
                                    DataCell(Center(
                                        child: Text(
                                      doc.productName ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                      child: Text(
                                        doc.exportDeclarationNumber
                                                ?.toString() ??
                                            '',
                                        style: _textxData,
                                      ),
                                    )),
                                    DataCell(Center(
                                        child: Text(
                                      doc.coUsed?.toString() ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                      child: Text(
                                        doc.coAvailable?.toString() ?? '',
                                        style: _textxData,
                                      ),
                                    )),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: currentPage > 1
                      ? () {
                          setState(() {
                            currentPage -= 1;
                          });
                          fetchInitialProductsResPort();
                        }
                      : null,
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    '$currentPage',
                    style: _textxData,
                  ),
                ),
                IconButton(
                  onPressed: hasMoreData
                      ? () {
                          setState(() {
                            currentPage += 1;
                          });
                          fetchInitialProductsResPort();
                        }
                      : null,
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                ),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black12),
                  ),
                  child: DropdownButton<int>(
                    value: itemsPerPage,
                    items: itemsPerPageOptions.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            '$value/${localization?.translate('page') ?? 'trang'}',
                            style: _textTitile,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          itemsPerPage = newValue;
                          currentPage = 1;
                        });
                        fetchInitialProductsResPort();
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
