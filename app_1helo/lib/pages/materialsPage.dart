import 'package:app_1helo/model/dropdownCustomer.dart';
import 'package:app_1helo/model/materials.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/authService.dart';
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
  int itemsPerPage = 10;
  final List<int> itemsPerPageOptions = [10, 20, 30];

  final ScrollController _scrollController = ScrollController();
  List<Data> materialList = [];
  bool isLoading = false;
  int currentPage = 1;
  final int pageSize = 10;
  final _authService = AuthService();
  MaterialService materialService = MaterialService();
  bool hasMoreData = true;
  final TextEditingController _searchController = TextEditingController();
  List<Data> _searchResults = [];
  bool _isSearching = false;
  String? _customerId;

  EmployeeCustomer? selectedDropdownCustomer;
  List<EmployeeCustomer> _filtereddropdownCustomer = [];
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
    _fetchData();
  }

  Future<void> fetchInitialMaterials() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    List<Data> initialMaterial = await materialService.fetchMaterials(
        currentPage, itemsPerPage, _customerId);

    if (!mounted) return;

    setState(() {
      materialList = initialMaterial;
      isLoading = false;
      if (initialMaterial.length < itemsPerPage) {
        hasMoreData = false;
      }
    });
  }

  Future<void> _loadMoreMaterial() async {
    if (isLoading || !hasMoreData) return;

    setState(() => isLoading = true);
    currentPage++;
    List<Data> moreMaterial = await materialService.fetchMaterials(
        currentPage, pageSize, _customerId);

    if (!mounted) return;

    setState(() {
      materialList.addAll(moreMaterial);
      isLoading = false;
      if (moreMaterial.length < pageSize) {
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

  Future<void> _fetchData({
    String? customerId,
  }) async {
    if (mounted) {
      setState(() {
        isLoading = true;
        materialList.clear();
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

      List<Data> reportData = await materialService.fetchMaterials(
        currentPage,
        itemsPerPage,
        customerId,
      );
      if (mounted) {
        setState(() {
          materialList = reportData;
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
        _fetchData(customerId: _customerId);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Data> displayList = (_isSearching ? _searchResults : materialList)
      ..sort((a, b) => (a.rowNumber ?? 0).compareTo(b.rowNumber ?? 0));
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: renderCustomerDropdown()),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 160,
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
            ],
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
                    : Container(
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
                                    'Mã nguyên vật liệu',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Tên nguyên vật liệu',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'ĐVT',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Tổng tồn',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Tổng chiếm giữ',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Tổng khả dụng',
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
                                    DataCell(
                                        Text(doc.coUsing?.toString() ?? '')),
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
