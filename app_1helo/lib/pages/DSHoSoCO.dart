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

  late Future<List<Data>> documents;
  DocumentService documentService = DocumentService();

  @override
  void initState() {
    super.initState();
    documents = documentService.fetchDocuments();
  }

//Date
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
          startDate = DateFormat('dd/MM/yyyy').format(startPicked);
          endDate = DateFormat('dd/MM/yyyy').format(endPicked);
          _controller.text = '$startDate - $endDate';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            child: GestureDetector(
              onTap: _selectDateRange,
              child: Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black26),
                ),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _controller,
                    readOnly: true,
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
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black26),
                    color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      label: Text(
                        'Số hồ sơ, tờ khai xuất, tình trạng',
                        style: GoogleFonts.robotoCondensed(fontSize: 14),
                      ),
                      labelStyle: GoogleFonts.robotoCondensed(),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide.none),
                      suffixIcon: const Row(
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
                      contentPadding: const EdgeInsets.all(5)),
                ),
              )),
              const SizedBox(
                width: 10,
              ),
              Container(
                  width: 90,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Provider.of<Providercolor>(context).selectedColor,
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Thêm mới',
                        style: GoogleFonts.robotoCondensed(color: Colors.white),
                      )))
            ],
          ),
          FutureBuilder<List<Data>>(
            future: documents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No documents found"));
              }

              final documentList = snapshot.data!;

              return Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                radius: const Radius.circular(10),
                thickness: 8,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('STT')),
                      DataColumn(label: Text('Mã định danh')),
                      DataColumn(label: Text('Form C/O')),
                      DataColumn(label: Text('Ngày tạo')),
                      DataColumn(label: Text('Số tờ khai xuất - DKVC')),
                      DataColumn(label: Text('Số Invoice')),
                      DataColumn(label: Text('Khách hàng')),
                      DataColumn(label: Text('Nhân viên')),
                      DataColumn(label: Text('Trạng thái')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: documentList.map((doc) {
                      return DataRow(cells: [
                        DataCell(Text(doc.rowNumber?.toString() ?? '')),
                        DataCell(Text(
                          doc.coDocumentId?.toString() ?? '',
                          style: GoogleFonts.robotoCondensed(
                              fontWeight: FontWeight.w700, color: Colors.blue),
                        )),
                        DataCell(Text(doc.coFormId ?? '')),
                        DataCell(Text(doc.createdDate ?? '')),
                        DataCell(Text(
                          doc.numberTkx?.join(', ') ?? '',
                          style: GoogleFonts.robotoCondensed(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        )),
                        DataCell(Text(doc.numberTkxWithShippingTerms
                                ?.map((e) => e.invoiceNumber ?? '')
                                .join(', ') ??
                            '')),
                        DataCell(Text(doc.customerName ?? '')),
                        DataCell(Text(doc.employeeName ?? '')),
                        DataCell(Text(doc.statusName ?? '',
                            style: GoogleFonts.robotoCondensed(
                                fontWeight: FontWeight.w700,
                                color: Colors.orange))),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () {},
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.replay_outlined,
                                  size: 24,
                                  color: Colors.blue,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.document_scanner_outlined,
                                  size: 24,
                                )),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 24,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
