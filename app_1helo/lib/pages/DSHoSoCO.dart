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
  late Future<List<Data>> documents;
  DocumentService documentService = DocumentService();
  List<Data> allDocuments = [];
  final TextEditingController _searchControllerDocuments =
      TextEditingController();
  List<Data> _searchResults = [];
  bool _isSearching = false;

  int currentPage = 1;
  int itemsPerPage = 20;
  final List<int> itemsPerPageOptions = [10, 20, 30, 50];

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

  @override
  void initState() {
    super.initState();
    documents = documentService.fetchDocuments().then((docs) {
      allDocuments = docs;
      return docs;
    });
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
        // Set the start and end date in the correct format
        setState(() {
          startDate = DateFormat('yyyy-MM-dd').format(startPicked);
          endDate = DateFormat('yyyy-MM-dd').format(endPicked);
          _controller.text = '$startDate - $endDate';
        });

        // Trigger search after the dates are selected
        await _searchDocumentsByDateRange();
      }
    }
  }

  List<Data> _filterDocuments(String query) {
    if (query.isEmpty) return allDocuments;

    return allDocuments.where((doc) {
      final documentIdMatch = doc.coDocumentId != null &&
          doc.coDocumentId
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());

      final customerNameMatch = doc.customerName != null &&
          doc.customerName!.toLowerCase().contains(query.toLowerCase());

      final employeeNameMatch = doc.employeeName != null &&
          doc.employeeName!.toLowerCase().contains(query.toLowerCase());

      return documentIdMatch || customerNameMatch || employeeNameMatch;
    }).toList();
  }

  Future<void> _searchDocumentsByDateRange() async {
    if (startDate != null && endDate != null) {
      try {
        // Call the search method in your service and pass the parsed dates
        List<Data> filteredDocuments =
            await documentService.searchDocumentsByDateRange(
          DateTime.parse(startDate!), // Parse startDate
          DateTime.parse(endDate!), // Parse endDate
        );

        // Update the state with the fetched documents
        setState(() {
          allDocuments = filteredDocuments;
        });

        if (filteredDocuments.isEmpty) {
          print('No documents found in the selected date range.');
        }
      } catch (error) {
        print('Error searching documents by date range: $error');
      }
    } else {
      print('Start date or end date is null');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                border: Border.all(color: Colors.black26),
              ),
              child: AbsorbPointer(
                child: TextField(
                  controller: _controller,
                  // readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Chọn Ngày Bắt Đầu và Kết Thúc',
                    labelStyle: GoogleFonts.robotoCondensed(fontSize: 14),
                    border: InputBorder.none,
                    suffixIcon: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        VerticalDivider(
                          width: 20,
                          thickness: 1,
                          color: Colors.black12,
                        ),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                    contentPadding: const EdgeInsets.all(5),
                  ),
                ),
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
                    border: Border.all(width: 1, color: Colors.black26),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    autofocus: true,
                    controller: _searchControllerDocuments,
                    onChanged: (value) {
                      setState(() {
                        // Trigger a rebuild on search input change
                      });
                    },
                    decoration: InputDecoration(
                      label: Text(
                        'Số hồ sơ, tờ khai xuất, tình trạng',
                        style: GoogleFonts.robotoCondensed(fontSize: 16),
                      ),
                      labelStyle: GoogleFonts.robotoCondensed(),
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
                              color: Colors.black12,
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
              Container(
                width: 90,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Add new document action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Provider.of<Providercolor>(context).selectedColor,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Thêm mới',
                    style: GoogleFonts.robotoCondensed(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                  border: Border.all(width: 1, color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]),
              padding: const EdgeInsets.all(10),
              child: FutureBuilder<List<Data>>(
                future: documents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_isSearching && _searchResults.isEmpty) {
                    return Center(
                      child: Text(
                        "Dữ liệu tìm kiếm không có!!!",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            color: Provider.of<Providercolor>(context)
                                .selectedColor),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No documents found"));
                  }

                  final documentList = _isSearching
                      ? _searchResults
                      : _filterDocuments(_searchController.text);

                  return SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]),
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
                            columns: [
                              DataColumn(
                                  label: Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text('STT',
                                        textAlign: TextAlign.center)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text('Mã định danh',
                                        textAlign: TextAlign.center)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text('Form C/O',
                                        textAlign: TextAlign.center)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text('Ngày tạo',
                                        textAlign: TextAlign.center)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text('Số tờ khai xuất-DKVC',
                                        textAlign: TextAlign.center)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text('Số Invoice',
                                        textAlign: TextAlign.center)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text('Khách hàng',
                                        textAlign: TextAlign.center)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text('Nhân viên',
                                        textAlign: TextAlign.center)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text('Trạng thái',
                                        textAlign: TextAlign.center)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text('Action',
                                        textAlign: TextAlign.center)),
                              )),
                            ],
                            rows: documentList.map((doc) {
                              return DataRow(cells: [
                                DataCell(Container(
                                    padding: const EdgeInsets.all(16),
                                    child:
                                        Text(doc.rowNumber?.toString() ?? ''))),
                                DataCell(Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    doc.coDocumentId?.toString() ?? '',
                                    style: GoogleFonts.robotoCondensed(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )),
                                DataCell(Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(doc.coFormId ?? ''))),
                                DataCell(Text(doc.createdDate ?? '')),
                                DataCell(Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    doc.numberTkx?.join(', ') ?? '',
                                    style: GoogleFonts.robotoCondensed(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                                DataCell(Text(doc.numberTkxWithShippingTerms
                                        ?.map((e) => e.invoiceNumber ?? '')
                                        .join(', ') ??
                                    '')),
                                DataCell(Text(doc.customerName ?? '')),
                                DataCell(Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(doc.employeeName ?? ''))),
                                DataCell(Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      doc.statusName ?? '',
                                      style: GoogleFonts.robotoCondensed(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ))),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // Add your edit action here
                                        },
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 22,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Add your delete action here
                                        },
                                        icon: const Icon(
                                          Icons.replay_rounded,
                                          size: 22,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Add your edit action here
                                        },
                                        icon: const Icon(
                                          Icons.file_open_outlined,
                                          size: 22,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Add your edit action here
                                        },
                                        icon: const Icon(
                                          Icons.delete_outlined,
                                          size: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
                      ? () => _changePage(currentPage - 1)
                      : null,
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
                  onPressed: () => _changePage(currentPage + 1),
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
          ),
          
        ],
      ),
    );
  }
}
