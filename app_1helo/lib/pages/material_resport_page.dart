// ignore_for_file: empty_catches

import 'package:app_1helo/model/dropdown_customer.dart';
import 'package:app_1helo/model/materialreport_model.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:app_1helo/service/authservice.dart';
import 'package:app_1helo/service/material_resport_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Materialresportpage extends StatefulWidget {
  const Materialresportpage({super.key});

  @override
  State<Materialresportpage> createState() => _MaterreportpageState();
}

class _MaterreportpageState extends State<Materialresportpage> {
  int itemsPerPage = 10;
  final List<int> itemsPerPageOptions = [10, 20, 30];

  int currentPage = 1;
  final int pageSize = 10;

  bool isLoading = false;
  bool isSearching = false;
  bool hasMoreData = true;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  List<Data> allMaterialsResport = [];
  List<Data> _searchResults = [];
  List<EmployeeCustomer> _filteredEmployeeCustomer = [];
  EmployeeCustomer? selectedemployeeCustomer;

  String? _customerid;
  String? search;
  String? startDate1;
  String? endDate1;

  final Materialresportservice _materialresportservice =
      Materialresportservice();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    fetchInitialMaterials();
    _scrollController.addListener(_onScroll);
    _fetchData();
  }

  Future<void> fetchInitialMaterials() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    try {
      List<Data> initialMaterialResPort =
          await _materialresportservice.fetchMateriaDataAlllsReport(
              currentPage, itemsPerPage, search, _customerid);

      if (mounted) {
        setState(() {
          allMaterialsResport = initialMaterialResPort;
          isLoading = false;
          if (initialMaterialResPort.length < itemsPerPage) {
            hasMoreData = false;
          }
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreMaterialResport() async {
    if (isLoading || !hasMoreData) return;

    setState(() => isLoading = true);
    currentPage++;

    List<Data> moreMaterialResport = await _materialresportservice
        .fetchMaterialsReport(search, _customerid, currentPage, pageSize);

    if (mounted) {
      setState(() {
        allMaterialsResport.addAll(moreMaterialResport);
        if (moreMaterialResport.length < pageSize) {
          hasMoreData = false;
        }
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _loadMoreMaterialResport();
    }
  }

  Future<void> _searchMaterialResPort(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        isSearching = false;
      });
      return;
    }

    List<Data> results = await _materialresportservice.fetchMaterialsReport(
        searchQuery, _customerid, currentPage, pageSize);
    if (!mounted) return;

    setState(() {
      _searchResults = results;
      isSearching = true;
    });
  }

  Future<void> _fetchData({
    String? customerId,
  }) async {
    if (mounted) {
      setState(() {
        isLoading = true;
        allMaterialsResport.clear();
        // currentPage = 1;
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

      List<Data> reportData = await _materialresportservice
          .fetchMaterialsReport(search, customerId, pageSize, currentPage);
      if (mounted) {
        setState(() {
          allMaterialsResport = reportData;
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

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _controller.dispose();
    _controller1.dispose();
    super.dispose();
  }

  void _selectDateRange() async {
    if (!mounted) return;

    final DateTime? startPicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (startPicked != null) {
      final DateTime? endPicked = await showDatePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialDate: startPicked.add(const Duration(days: 1)),
        firstDate: startPicked,
        lastDate: DateTime(2101),
      );

      if (endPicked != null && mounted) {
        setState(() {
          startDate1 = DateFormat('yyyy-MM-dd').format(startPicked);
          endDate1 = DateFormat('yyyy-MM-dd').format(endPicked);
          _controller1.text = '$startDate1 - $endDate1';
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
          await _materialresportservice.fetchMaterialsReportDate(
        parsedStartDate,
        parsedEndDate,
      );

      setState(() {
        allMaterialsResport = dateFilteredList;
        allMaterialsResport = dateFilteredList;
      });
    } catch (error) {}
  }

  Widget buildDropdown({
    required List<String> items,
    required String? selectedItem,
    required String hint,
    required Function(String?) onChanged,
    double width = 170,
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

  Widget renderCustomerDrop(BuildContext context) {
    final localization = AppLocalizations.of(context);

    List<String> customerName = _filteredEmployeeCustomer
        .map((u) => u.customerName ?? '')
        .toSet()
        .toList();

    String allCustomersLabel =
        localization?.translate('all_customers') ?? 'Tất cả khách hàng';
    customerName.insert(0, allCustomersLabel);

    return buildDropdown(
      items: customerName,
      selectedItem: selectedemployeeCustomer?.customerName,
      hint: allCustomersLabel,
      onChanged: (String? newvalue) {
        setState(() {
          selectedemployeeCustomer = newvalue == allCustomersLabel
              ? null
              : _filteredEmployeeCustomer.firstWhere(
                  (u) => u.customerName == newvalue,
                  orElse: () => _filteredEmployeeCustomer[0],
                );
          _customerid = selectedemployeeCustomer?.customerId;
        });
        _fetchData(customerId: _customerid);
      },
    );
  }

  void _clearDateRange() {
    setState(() {
      startDate1 = null;
      endDate1 = null;
      _controller1.clear();
    });
  }

  final _textxData = GoogleFonts.robotoCondensed(
      fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500);
  final _textTitile = GoogleFonts.robotoCondensed(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    List<Data> displayList = (isSearching
        ? _searchResults
        : allMaterialsResport)
      ..sort((a, b) => (a.rowNumber ?? 0).compareTo(b.rowNumber ?? 0));
    final localization = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        controller: _controller1,
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
                  if (_controller1.text.isNotEmpty)
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
                  child:
                      SizedBox(width: 200, child: renderCustomerDrop(context))),
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
                    // onChanged: (value) {
                    //   setState(() {
                    //     // Trigger a rebuild on search input change
                    //   });
                    // },
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText:
                          localization?.translate('search_materialResport') ??
                              'Số hồ sơ, tờ khai xuất, tình trạng',
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
                              _searchMaterialResPort(_searchController.text);
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
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: isLoading
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
                                      label: Text(
                                          localization?.translate(
                                                  'numerical_order') ??
                                              'STT',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization?.translate(
                                                  'code_material') ??
                                              'Mã NVL',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization?.translate(
                                                  'name_material') ??
                                              'Tên NVL',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization?.translate(
                                                  'number_TKN/VAT') ??
                                              'Số TKN/VAT',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization?.translate(
                                                  'number_TKN/VAT') ??
                                              'STT trong TKN/VAT',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization?.translate(
                                                  'inventory_number') ??
                                              'Số lượng tồn',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization?.translate(
                                                  'number_createCO') ??
                                              'SL đã làm C/O',
                                          style: _textTitile)),
                                  DataColumn(
                                      label:
                                          Text('Khả dụng', style: _textTitile)),
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
                                      doc.materialCode ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                        child: Text(
                                      doc.materialName ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                        child: Text(
                                      doc.importDeclarationVat ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                        child: Text(
                                      doc.sortOrder?.toString() ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                      child: Text(
                                        doc.coAvailable?.toString() ?? '',
                                        style: _textxData,
                                      ),
                                    )),
                                    DataCell(Center(
                                        child: Text(
                                      doc.coUsing?.toString() ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                        child: Text(
                                      doc.quantity?.toString() ?? '',
                                      style: _textxData,
                                    ))),
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
                          fetchInitialMaterials();
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
                  child: Text('$currentPage', style: _textxData),
                ),
                IconButton(
                  onPressed: hasMoreData
                      ? () {
                          setState(() {
                            currentPage += 1;
                          });
                          fetchInitialMaterials();
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
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
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
                        fetchInitialMaterials();
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
