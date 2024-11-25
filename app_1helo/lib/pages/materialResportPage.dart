import 'package:app_1helo/model/dropdownCustomer.dart';
import 'package:app_1helo/model/materialReportModel.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:app_1helo/service/materialResportService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Materialresportpage extends StatefulWidget {
  final Function(int) onSelectPage;
  const Materialresportpage({super.key, required this.onSelectPage});

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
      List<Data> initialMaterialResPort = await _materialresportservice
          .fetchMateriaDataAlllsReport(currentPage, itemsPerPage);

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
      print("Error fetching data: $e");
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
    } catch (error) {
      print('Error searching documents by date range: ${error.toString()}');
    }
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

    return buildDropdown(
      items: customerName,
      selectedItem: selectedemployeeCustomer?.customerName,
      hint: 'Chọn khách hàng',
      onChanged: (String? newvalue) {
        setState(() {
          selectedemployeeCustomer = newvalue == 'Chọn khách hàng'
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

  @override
  Widget build(BuildContext context) {
    List<Data> displayList = (isSearching
        ? _searchResults
        : allMaterialsResport)
      ..sort((a, b) => (a.rowNumber ?? 0).compareTo(b.rowNumber ?? 0));
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
                    child: TextField(
                      controller: _controller1,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Chọn ngày bắt đầu và kết thúc',
                        hintStyle: GoogleFonts.robotoCondensed(
                          fontSize: 14,
                          color: Colors.black38,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(5),
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
            children: [
              Expanded(child: renderCustomerDrop()),
              const SizedBox(width: 10),
              Container(
                width: 140,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.black38),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      // Trigger a rebuild on search input change
                    });
                  },
                  controller: _searchController,
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
                                    'STT',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Mã NVL',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Tên NVL',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Số TKN/VAT',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'STT TKN/VAT',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'SL đã làm C/O',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Khả dụng',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Số lượng tồn',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ],
                                rows: displayList.map((doc) {
                                  return DataRow(cells: [
                                    DataCell(
                                        Text(doc.rowNumber?.toString() ?? '')),
                                    DataCell(Text(doc.materialCode ?? '')),
                                    DataCell(Text(doc.materialName ?? '')),
                                    DataCell(
                                        Text(doc.importDeclarationVat ?? '')),
                                    DataCell(
                                        Text(doc.sortOrder?.toString() ?? '')),
                                    DataCell(Text(
                                        doc.coAvailable?.toString() ?? '')),
                                    DataCell(
                                        Text(doc.coUsing?.toString() ?? '')),
                                    DataCell(
                                        Text(doc.quantity?.toString() ?? '')),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  child: Text(
                    '$currentPage',
                    style: const TextStyle(color: Colors.black),
                  ),
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
                const SizedBox(width: 8),
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
                        child: Text('$value/trang'),
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
