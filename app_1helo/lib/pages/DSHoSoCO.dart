import 'package:app_1helo/model/documentss.dart';
import 'package:app_1helo/model/dropdownCustomer.dart';
import 'package:app_1helo/model/dropdownEmployee.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:app_1helo/service/document_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Dshosoco extends StatefulWidget {
  const Dshosoco({Key? key}) : super(key: key);

  @override
  State<Dshosoco> createState() => _DshosocoState();
}

class _DshosocoState extends State<Dshosoco> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  DocumentService documentService = DocumentService();
  List<Data> documentLits = [];
  List<Data> _filteredData = [];
  final TextEditingController _searchControllerDocuments =
      TextEditingController();
  List<Data> _searchResults = [];
  bool _isSearching = false;
  bool isLoading = false;
  bool hasMoreData = true;
  int pageSize = 10;
  int currentPage = 1;
  int itemsPerPage = 10;
  String? _employeedId;
  String? _customerId;
  final List<int> itemsPerPageOptions = [10, 20, 30];

  dropdownEmployee? selectedDropdownEmployee;
  List<dropdownEmployee> _filtereddropdownEmployee = [];
  EmployeeCustomer? selectedDropdownCustomer;
  List<EmployeeCustomer> _filtereddropdownCustomer = [];

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initializeData() async {
    try {
      await Future.wait([
        fetchInitialDocuments(),
        _fetchData(),
      ]);
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  Future<void> _searchDocuments(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }
    List<Data> results = await documentService.searchDocuments(searchQuery);
    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

  void _changePage(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
    });
  }

  Future<void> fetchInitialDocuments() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    List<Data> initialDocument =
        await documentService.fetchAllDocuments(currentPage, itemsPerPage);

    if (mounted) {
      setState(() {
        documentLits = initialDocument;
        isLoading = false;
        if (initialDocument.length < itemsPerPage) {
          hasMoreData = false;
        }
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _loadMoreDocuments();
    }
  }

  Future<void> _loadMoreDocuments() async {
    if (isLoading || !hasMoreData) return;

    setState(() => isLoading = true);
    currentPage++;
    List<Data> moreProducts =
        await documentService.fetchAllDocuments(currentPage, pageSize);

    if (mounted) {
      setState(() {
        documentLits.addAll(moreProducts);
        isLoading = false;
        if (moreProducts.length < pageSize) {
          hasMoreData = false;
        }
      });
    }
  }

  String? _selectedStatus;
  String? startDate;
  String? endDate;
  final TextEditingController _controller = TextEditingController();

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
          startDate = DateFormat('yyyy-MM-dd').format(startPicked);
          endDate = DateFormat('yyyy-MM-dd').format(endPicked);
          _controller.text = '$startDate - $endDate';
        });

        await _updateDocumentsByDateRange();
      }
    }
  }

  Future<void> _updateDocumentsByDateRange() async {
    try {
      final DateTime parsedStartDate =
          DateFormat('yyyy-MM-dd').parse(startDate!);
      final DateTime parsedEndDate = DateFormat('yyyy-MM-dd').parse(endDate!);

      final List<Data> documents =
          await documentService.searchDocumentsByDateRange(
        parsedStartDate,
        parsedEndDate,
      );

      setState(() {
        documentLits = documents;
      });
    } catch (error) {
      print('Error searching documents by date range: ${error.toString()}');
    }
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

    try {
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

      List<Data> reportData = await documentService.fetchDocuments(
        currentPage,
        itemsPerPage,
        employeedId,
        customerId,
      );
      if (mounted) {
        setState(() {
          documentLits = reportData;
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

  Color _getStatusColor(String? statusName) {
    switch (statusName) {
      case 'Chờ hủy':
        return Colors.orange;
      case 'Chờ duyệt':
        return Colors.orange;
      case 'Hoàn thành':
        return Colors.green;
      case 'Đang thực hiện':
        return Colors.black;
      case 'Đang sửa':
        return Colors.black;
      case 'Chờ sửa':
        return Colors.black;
      case 'Từ chối xét duyệt':
        return Colors.red;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // List of status options
  final List<String> _statusList = [
    'Chờ hủy',
    'Chờ duyệt',
    'Hoàn thành',
    'Đang thực hiện',
    'Đang sửa',
    'Chờ sửa',
    'Từ chối xét duyệt',
    'Đã hủy',
  ];
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

  Widget renderCustomerDropdown() {
    List<String> customerNames = _filtereddropdownCustomer
        .map((u) => u.customerName ?? '')
        .toSet()
        .toList();
    customerNames.insert(0, 'Tất cả khách hàng');

    return buildDropdown(
      items: customerNames,
      selectedItem: selectedDropdownCustomer?.customerName,
      hint: 'Tất cả khách hàng',
      onChanged: (String? newValue) {
        setState(() {
          selectedDropdownCustomer = newValue == 'Tất cả khách hàng'
              ? null
              : _filtereddropdownCustomer.firstWhere(
                  (u) => u.customerName == newValue,
                  orElse: () => _filtereddropdownCustomer[0],
                );

          _customerId = selectedDropdownCustomer?.customerId;
        });

        _fetchData(customerId: _customerId, employeedId: _employeedId);
      },
    );
  }

  Widget renderUserDropdown() {
    List<String> userNames =
        _filtereddropdownEmployee.map((u) => u.label ?? '').toSet().toList();
    userNames.insert(0, 'Tất cả nhân viên');

    return buildDropdown(
      items: userNames,
      selectedItem: selectedDropdownEmployee?.label,
      hint: 'Tất cả nhân viên',
      onChanged: (String? newValue) {
        setState(() {
          selectedDropdownEmployee = newValue == 'Tất cả nhân viên'
              ? null
              : _filtereddropdownEmployee.firstWhere(
                  (u) => u.label == newValue,
                  orElse: () => _filtereddropdownEmployee[0],
                );

          _employeedId = selectedDropdownEmployee?.value;
        });
        _fetchData(customerId: _customerId, employeedId: _employeedId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Data> displayList = (_isSearching ? _searchResults : documentLits)
      ..sort((a, b) => (a.rowNumber ?? 0).compareTo(b.rowNumber ?? 0));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(
                  child: SizedBox(width: 200, child: renderCustomerDropdown())),
              const SizedBox(
                width: 10,
              ),
              FittedBox(
                  child: SizedBox(width: 160, child: renderUserDropdown())),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(
                child: GestureDetector(
                  onTap: _selectDateRange,
                  child: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black38),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: TextField(
                              controller: _controller,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Chọn ngày bắt đầu và kết thúc',
                                hintStyle: GoogleFonts.robotoCondensed(
                                  fontSize: 14,
                                  color: Colors.black38,
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
                          width: 15,
                          thickness: 1,
                          color: Colors.black38,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: _selectDateRange,
                            child: const Icon(Icons.calendar_today,
                                size: 24, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              FittedBox(
                child: Container(
                  width: 160,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black38),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _searchControllerDocuments,
                    onChanged: (value) {
                      setState(() {
                        // Trigger a rebuild on search input change
                      });
                    },
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
                          _searchDocuments(_searchControllerDocuments.text);
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
            ],
          ),
          const SizedBox(
            height: 10,
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
                                  columns: _buildDataTableColumns(),
                                  rows: displayList
                                      .map((doc) => _buildDataRow(doc))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        )),
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
                          fetchInitialDocuments();
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
                          fetchInitialDocuments();
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
                        child: Text('$value/trang'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          itemsPerPage = newValue;
                          currentPage = 1;
                        });
                        fetchInitialDocuments();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> _buildDataTableColumns() {
    const columnTitles = [
      'STT',
      'Mã định danh',
      'Form C/O',
      'Ngày tạo',
      'Số tờ khai xuất-DKVC',
      'Số Invoice',
      'Khách hàng',
      'Nhân viên',
      'Trạng thái',
    ];

    return columnTitles.asMap().entries.map((entry) {
      final index = entry.key;
      final title = entry.value;

      if (title == 'Trạng thái') {
        // Thêm DropdownButton cho cột "Trạng thái"
        return DataColumn(
          label: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.robotoCondensed(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  hint: const Text('Lọc'),
                  value: _selectedStatus,
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  underline: const SizedBox(),
                  items: _statusList.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: _getStatusColor(status),
                            radius: 5,
                          ),
                          const SizedBox(width: 8),
                          Text(status),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value; // Cập nhật trạng thái đã chọn
                      // Apply filter logic to show only matching data rows
                      _filterDataByStatus();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      } else {
        // Các cột khác không thay đổi
        return DataColumn(
          label: Center(
            child: Text(
              title,
              style: GoogleFonts.robotoCondensed(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }
    }).toList();
  }

  void _filterDataByStatus() {
    setState(() {
      if (_selectedStatus != null) {
        _filteredData = documentLits.where((item) {
          return item.statusName == _selectedStatus;
        }).toList();
      } else {
        _filteredData = List.from(documentLits); // If no filter, show all data
      }
    });
  }

  DataRow _buildDataRow(Data doc) {
    return DataRow(cells: [
      DataCell(
        Center(child: Text(doc.rowNumber?.toString() ?? '')),
        placeholder: false,
        showEditIcon: false,
      ),
      DataCell(
        Center(
          child: Text(
            doc.coDocumentId?.toString() ?? '',
            style: GoogleFonts.robotoCondensed(
              fontWeight: FontWeight.w700,
              color: Colors.blue,
            ),
          ),
        ),
      ),
      DataCell(Center(child: Center(child: Text(doc.coFormId ?? '')))),
      DataCell(
        Center(
          child: Text(
            doc.createdDate != null
                ? DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(doc.createdDate!))
                : 'N/A',
          ),
        ),
      ),
      DataCell(
        Center(
          child: Text(
            doc.numberTkx?.join(', ') ?? '',
            style: GoogleFonts.robotoCondensed(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      DataCell(Center(
        child: Text(doc.numberTkxWithShippingTerms
                ?.map((e) => e.invoiceNumber ?? '')
                .join(', ') ??
            ''),
      )),
      DataCell(Center(child: Text(doc.customerName ?? ''))),
      DataCell(Center(child: Text(doc.employeeName ?? ''))),
      DataCell(
        Center(
          child: Text(
            doc.statusName ?? '',
            style: GoogleFonts.robotoCondensed(
              color: _getStatusColor(doc.statusName), // Áp dụng màu trạng thái
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ]);
  }
}
