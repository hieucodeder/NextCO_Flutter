import 'package:app_1helo/model/materials.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/material_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Materialspage extends StatefulWidget {
  const Materialspage({super.key});

  @override
  State<Materialspage> createState() => _MaterialspageState();
}

class _MaterialspageState extends State<Materialspage> {
  int currentPage1 = 1;
  int itemsPerPage = 20;
  final List<int> itemsPerPageOptions = [10, 20, 30, 50];
  void _changePage(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
    });
  }

  final ScrollController _scrollController = ScrollController();
  List<Data> materialList = [];
  bool isLoading = false;
  int currentPage = 1;
  final int pageSize = 10;
  MaterialService materialService = MaterialService();
  bool hasMoreData = true;
  final TextEditingController _searchController = TextEditingController();
  List<Data> _searchResults = [];
  bool _isSearching = false;

  Future<void> _searchMaterials(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    List<Data> results = await materialService.searchMaterials(searchQuery);

    if (!mounted) return;

    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Data> displayList = _isSearching ? _searchResults : materialList;
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.black26),
              color: Colors.white,
            ),
            child: TextField(
              // autofocus: true,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Mã NVL, Tên NVL...',
                hintStyle: GoogleFonts.robotoCondensed(
                    fontSize: 14, color: Colors.black38),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _searchMaterials(_searchController.text);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VerticalDivider(
                        width: 20,
                        thickness: 1,
                        color: Colors.black38,
                      ),
                      Icon(
                        Icons.search_outlined,
                        size: 24,
                        color: Colors.black38,
                      )
                    ],
                  ),
                ),
                contentPadding: const EdgeInsets.all(5),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                    : SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100],
                              border:
                                  Border.all(width: 1, color: Colors.black12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]),
                          padding: const EdgeInsets.all(10),
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
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('STT')),
                                      DataColumn(
                                          label: Text('Mã nguyên vật liệu')),
                                      DataColumn(
                                          label: Text('Tên nguyên vật liệu')),
                                      DataColumn(label: Text('ĐVT')),
                                      DataColumn(label: Text('Tổng tồn')),
                                      DataColumn(label: Text('Tổng chiếm giữ')),
                                      DataColumn(label: Text('Tổng khả dụng')),
                                    ],
                                    rows: displayList.map((doc) {
                                      return DataRow(cells: [
                                        DataCell(Text(
                                            doc.rowNumber?.toString() ?? '')),
                                        DataCell(Text(
                                          doc.materialCode ?? '',
                                          style: GoogleFonts.robotoCondensed(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.blue),
                                        )),
                                        DataCell(Text(doc.materialName ?? '')),
                                        DataCell(Text(doc.unit ?? '')),
                                        DataCell(Text(
                                            doc.coAvailable?.toString() ?? '')),
                                        DataCell(Text(
                                            doc.coUsing?.toString() ?? '')),
                                        DataCell(Text(
                                            doc.recordCount?.toString() ?? '')),
                                      ]);
                                    }).toList(),
                                  ),
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
          )
        ],
      ),
    );
  }
}
