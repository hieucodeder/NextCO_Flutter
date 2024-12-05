import 'package:app_1helo/model/dropdownCustomer.dart';
import 'package:app_1helo/model/productss.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:app_1helo/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int itemsPerPage = 10;
  final List<int> itemsPerPageOptions = [10, 20, 30];
  int currentPage = 1;
  int pageSize = 10;

  List<Data> productList = [];
  List<Data> _searchResults = [];

  final _authService = AuthService();
  ProductService productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSearching = false;
  bool isLoading = false;
  bool hasMoreData = true;

  EmployeeCustomer? selectedDropdownCustomer;
  List<EmployeeCustomer> _filtereddropdownCustomer = [];
  String? _customerId;
  @override
  void initState() {
    super.initState();
    fetchInitialProducts();
    _fetchData();
  }

  Future<void> _searchProducts(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }
    List<Data> results = await productService.searchProducts(searchQuery);
    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

  Future<void> fetchInitialProducts() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    List<Data> initialProducts = await productService.fetchProducts(
        currentPage, itemsPerPage, _customerId);

    if (mounted) {
      setState(() {
        productList = initialProducts;
        isLoading = false;
        if (initialProducts.length < itemsPerPage) {
          hasMoreData = false;
        }
      });
    }
  }

  // Future<void> _loadMoreProducts() async {
  //   if (isLoading || !hasMoreData) return;

  //   setState(() => isLoading = true);
  //   currentPage++;
  //   List<Data> moreProducts =
  //       await productService.fetchProducts(currentPage, pageSize, _customerId);

  //   if (mounted) {
  //     setState(() {
  //       productList.addAll(moreProducts);
  //       isLoading = false;
  //       if (moreProducts.length < pageSize) {
  //         hasMoreData = false;
  //       }
  //     });
  //   }
  // }

  // void _onScroll() {
  //   if (_scrollController.position.pixels ==
  //           _scrollController.position.maxScrollExtent &&
  //       !isLoading) {
  //     _loadMoreProducts();
  //   }
  // }

  // @override
  // void dispose() {
  //   _scrollController.removeListener(_onScroll);
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  Future<void> _fetchData({
    String? customerId,
  }) async {
    if (mounted) {
      setState(() {
        isLoading = true;
        productList.clear();
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

      List<Data> reportData = await productService.fetchProducts(
        currentPage,
        itemsPerPage,
        customerId,
      );
      if (mounted) {
        setState(() {
          productList = reportData;
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

  final _textxData = GoogleFonts.robotoCondensed(
      fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500);
  final _textTitile = GoogleFonts.robotoCondensed(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    List<Data> displayList = (_isSearching ? _searchResults : productList)
      ..sort((a, b) => (a.rowNumber ?? 0).compareTo(b.rowNumber ?? 0));
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(
                child: SizedBox(width: 200, child: renderCustomerDropdown()),
              ),
              const SizedBox(
                width: 10,
              ),
              FittedBox(
                child: Container(
                  width: 160,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black38),
                    color: Colors.white,
                  ),
                  child: TextField(
                    // autofocus: true,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Mã sản phẩm, mã HS',
                      hintStyle: GoogleFonts.robotoCondensed(
                          fontSize: 15, color: Colors.black38),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _searchProducts(_searchController.text);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VerticalDivider(
                              width: 20,
                              color: Colors.black38,
                              thickness: 1,
                            ),
                            Icon(
                              Icons.search_outlined,
                              size: 24,
                              color: Colors.black38,
                            ),
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
          const SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayList.isEmpty
                    ? Center(
                        child: Text("Dữ liệu tìm kiếm không có!!!",
                            style: GoogleFonts.robotoCondensed(
                                fontSize: 16,
                                color: Provider.of<Providercolor>(context)
                                    .selectedColor)),
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
                                      label: Text('Mã HS', style: _textTitile)),
                                  DataColumn(
                                      label: Text('Mã sản phẩm',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text('Thông tin sản phẩm',
                                          style: _textTitile)),
                                  DataColumn(
                                      label:
                                          Text('Định mức', style: _textTitile)),
                                  DataColumn(
                                      label: Text('Thông số trong QTSX',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text('Tổng SP chưa làm C/O',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text('Đơn vị tính',
                                          style: _textTitile)),
                                  // DataColumn(label: Text('Action')),
                                ],
                                rows: displayList.map((doc) {
                                  return DataRow(cells: [
                                    DataCell(Center(
                                        child: Text(
                                      doc.rowNumber?.toString() ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(InkWell(
                                      onTap: () {
                                        showProductDetailsDialog(
                                            context,
                                            doc.productName ?? '',
                                            doc.hsCode ?? '',
                                            doc.productCode ?? '',
                                            doc.unit ?? '');
                                      },
                                      child: Center(
                                        child: Text(
                                          doc.hsCode ?? '',
                                          style: GoogleFonts.robotoCondensed(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color: Colors.blue),
                                        ),
                                      ),
                                    )),
                                    DataCell(Center(
                                        child: Text(
                                      doc.productCode ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                        child: Text(doc.productName ?? '',
                                            style: _textxData))),
                                    DataCell(Center(
                                      child: Text(
                                          doc.productExpenseId?.toString() ??
                                              '',
                                          style: _textxData),
                                    )),
                                    DataCell(Center(
                                      child: Text(
                                          doc.productExpenseId?.toString() ??
                                              '',
                                          style: _textxData),
                                    )),
                                    DataCell(Center(
                                        child: Text(doc.customerName ?? '',
                                            style: _textxData))),
                                    DataCell(Center(
                                        child: Text(doc.unit?.toString() ?? '',
                                            style: _textxData))),
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
                          fetchInitialProducts();
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
                          fetchInitialProducts();
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
                            '$value/trang',
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
                        fetchInitialProducts();
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

void showProductDetailsDialog(BuildContext context, String productsName,
    String CodeHS, String CodeProducts, String unit) {
  TextEditingController productsnameController =
      TextEditingController(text: productsName);
  TextEditingController CodeHSController = TextEditingController(text: CodeHS);
  TextEditingController productsController =
      TextEditingController(text: CodeProducts);
  TextEditingController unitController = TextEditingController(text: unit);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Chi tiết sản phẩm',
          ),
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Tên sản phẩm'),
                    ],
                  ),
                  TextField(
                    controller: productsnameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Mã HS'),
                    ],
                  ),
                  TextField(
                    controller: CodeHSController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Mã sản phẩm'),
                    ],
                  ),
                  TextField(
                    controller: productsController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Đơn vị tính'),
                    ],
                  ),
                  TextField(
                    controller: unitController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2,
                          color: Provider.of<Providercolor>(context)
                              .selectedColor),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Đóng',
                        style: GoogleFonts.robotoCondensed(
                            color: Provider.of<Providercolor>(context)
                                .selectedColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showDeleteProductDialog(BuildContext context, String customerName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Xóa sản phẩm',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        // backgroundColor: Provider.of<Providercolor>(context).selectedColor,
        content: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Bạn có muốn xóa sản phẩm ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: customerName,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const TextSpan(
                text: ' ?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 2,
                  color: Provider.of<Providercolor>(context).selectedColor),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'KHông',
                style: GoogleFonts.robotoCondensed(
                    color: Provider.of<Providercolor>(context).selectedColor),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Thêm logic lưu khách hàng
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Provider.of<Providercolor>(context).selectedColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide.none),
            ),
            child: Text(
              'Có',
              style: GoogleFonts.robotoCondensed(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
