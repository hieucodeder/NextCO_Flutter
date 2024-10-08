import 'package:app_1helo/model/materials.dart';
import 'package:app_1helo/service/material_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Materialspage extends StatefulWidget {
  const Materialspage({super.key});

  @override
  State<Materialspage> createState() => _MaterialspageState();
}

class _MaterialspageState extends State<Materialspage> {
  final ScrollController _scrollController = ScrollController();
  List<Data> materialList = [];
  bool isLoading = false;
  int currentPage = 1;
  final int pageSize = 10;
  MaterialService materialService = MaterialService();
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    fetchInitialMaterials();
    _scrollController.addListener(_onScroll);
  }

  Future<void> fetchInitialMaterials() async {
    setState(() => isLoading = true);
    List<Data> initialMaterial =
        await materialService.fetchMaterials(currentPage, pageSize);

    if (!mounted) return;

    setState(() {
      materialList = initialMaterial;
      isLoading = false;
      if (initialMaterial.length < pageSize) {
        hasMoreData = false;
      }
    });
  }

  Future<void> _loadMoreMaterial() async {
    if (isLoading || !hasMoreData) return;

    setState(() => isLoading = true);
    currentPage++;
    List<Data> moreProducts =
        await materialService.fetchMaterials(currentPage, pageSize);

    if (!mounted) return;

    setState(() {
      materialList.addAll(moreProducts);
      isLoading = false;
      if (moreProducts.length < pageSize) {
        hasMoreData = false;
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _loadMoreMaterial();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.black26),
                color: Colors.white,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Mã NV',
                  hintStyle: GoogleFonts.robotoCondensed(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
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
                  contentPadding: const EdgeInsets.all(5),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<void>(
                future: fetchInitialMaterials(),
                builder: (context, snapshot) {
                  if (isLoading && materialList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (materialList.isEmpty) {
                    return const Center(child: Text("No materials found"));
                  }

                  return Scrollbar(
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
                            DataColumn(label: Text('Mã nguyên vật liệu')),
                            DataColumn(label: Text('Tên nguyên vật liệu')),
                            DataColumn(label: Text('ĐVT')),
                            DataColumn(label: Text('Tổng tồn')),
                            DataColumn(label: Text('Tổng chiếm giữ')),
                            DataColumn(label: Text('Tổng khả dụng')),
                          ],
                          rows: materialList.map((doc) {
                            return DataRow(cells: [
                              DataCell(Text(doc.rowNumber?.toString() ?? '')),
                              DataCell(Text(
                                doc.materialId ?? '',
                                style: GoogleFonts.robotoCondensed(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue),
                              )),
                              DataCell(Text(doc.materialName ?? '')),
                              DataCell(Text(doc.unit ?? '')),
                              DataCell(Text(doc.coAvailable?.toString() ?? '')),
                              DataCell(Text(doc.coUsing?.toString() ?? '')),
                              DataCell(Text(doc.recordCount?.toString() ?? '')),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
