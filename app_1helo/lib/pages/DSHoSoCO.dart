import 'package:app_1helo/model/documentss.dart';
import 'package:app_1helo/provider/providerColor.dart';
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
  final TextEditingController _searchControllerDocuments =
      TextEditingController();
  List<Data> _searchResults = [];
  bool _isSearching = false;
  bool isLoading = false;
  bool hasMoreData = true;
  int pageSize = 10;
  int currentPage = 1;
  int itemsPerPage = 10;
  final List<int> itemsPerPageOptions = [10, 20, 30];

  @override
  void initState() {
    super.initState();
    fetchInitialDocuments();
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
        await documentService.fetchDocuments(currentPage, itemsPerPage);

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
        await documentService.fetchDocuments(currentPage, pageSize);

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

  @override
  Widget build(BuildContext context) {
    List<Data> displayList = _isSearching ? _searchResults : documentLits;
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
                    child: TextField(
                      controller: _controller,
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
                  if (_controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: _clearDateRange,
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
                          padding: const EdgeInsets.all(5),
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            radius: const Radius.circular(10),
                            thickness: 8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              child: DataTable(
                                columns: _buildDataTableColumns(),
                                rows: displayList
                                    .map((doc) => _buildDataRow(doc))
                                    .toList(),
                              ),
                            ),
                          ),
                        )),
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

    return columnTitles.map((title) {
      return DataColumn(
        label: Text(title, textAlign: TextAlign.center),
      );
    }).toList();
  }

  DataRow _buildDataRow(Data doc) {
    return DataRow(cells: [
      DataCell(Text(doc.rowNumber?.toString() ?? '')),
      DataCell(
        Text(
          doc.coDocumentId?.toString() ?? '',
          style: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.w700,
            color: Colors.blue,
          ),
        ),
      ),
      DataCell(Text(doc.coFormId ?? '')),
      DataCell(
        Text(
          doc.createdDate != null
              ? DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(doc.createdDate!))
              : 'N/A',
        ),
      ),
      DataCell(
        Text(
          doc.numberTkx?.join(', ') ?? '',
          style: GoogleFonts.robotoCondensed(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      DataCell(Text(doc.numberTkxWithShippingTerms
              ?.map((e) => e.invoiceNumber ?? '')
              .join(', ') ??
          '')),
      DataCell(Text(doc.customerName ?? '')),
      DataCell(Text(doc.employeeName ?? '')),
      DataCell(
        Text(
          doc.statusName ?? '',
          style: GoogleFonts.robotoCondensed(
            color: Colors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ]);
  }
}
