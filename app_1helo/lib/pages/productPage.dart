import 'package:app_1helo/model/productss.dart';
import 'package:app_1helo/provider/providerColor.dart';
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
  int itemsPerPage = 20;
  final List<int> itemsPerPageOptions = [10, 20, 30, 50];
  void _changePage(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
    });
  }

  final ScrollController _scrollController = ScrollController();
  List<Data> productList = [];
  bool isLoading = false;
  int currentPage = 1;
  final int pageSize = 10;
  ProductService productService = ProductService();
  bool hasMoreData = true;
  final TextEditingController _searchController = TextEditingController();
  List<Data> _searchResults = [];
  bool _isSearching = false;

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

  @override
  void initState() {
    super.initState();
    fetchInitialProducts();
    _scrollController.addListener(_onScroll);
  }

  Future<void> fetchInitialProducts() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    List<Data> initialProducts =
        await productService.fetchProducts(currentPage, pageSize);

    if (mounted) {
      setState(() {
        productList = initialProducts;
        isLoading = false;
        if (initialProducts.length < pageSize) {
          hasMoreData = false;
        }
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    if (isLoading || !hasMoreData) return;

    setState(() => isLoading = true);
    currentPage++;
    List<Data> moreProducts =
        await productService.fetchProducts(currentPage, pageSize);

    if (mounted) {
      setState(() {
        productList.addAll(moreProducts);
        isLoading = false;
        if (moreProducts.length < pageSize) {
          hasMoreData = false;
        }
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Data> displayList = _isSearching ? _searchResults : productList;
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(10),
      color: Colors.grey[200],
      child: Column(
        children: [
          Container(
            width: double.infinity,
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
                hintText: 'Mã sản phẩm',
                hintStyle: GoogleFonts.robotoCondensed(
                    fontSize: 14, color: Colors.black38),
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
                            color: Colors.grey[100],
                            border: Border.all(width: 1, color: Colors.black12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x005c6566).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]),
                        padding: const EdgeInsets.all(8),
                        child: Container(
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
                                  columns: const [
                                    DataColumn(label: Text('STT')),
                                    DataColumn(label: Text('Mã HS')),
                                    DataColumn(label: Text('Mã sản phẩm')),
                                    DataColumn(
                                        label: Text('Thông tin sản phẩm')),
                                    DataColumn(label: Text('Định mức')),
                                    DataColumn(
                                        label: Text('Thông số trong QTSX')),
                                    DataColumn(
                                        label: Text('Tổng SP chưa làm C/O')),
                                    DataColumn(label: Text('Đơn vị tính')),
                                    DataColumn(label: Text('Action')),
                                  ],
                                  rows: displayList.map((doc) {
                                    return DataRow(cells: [
                                      DataCell(Text(
                                          doc.rowNumber?.toString() ?? '')),
                                      DataCell(InkWell(
                                        onTap: () {
                                          showProductDetailsDialog(
                                              context,
                                              doc.productName ?? '',
                                              doc.hsCode ?? '',
                                              doc.productCode ?? '',
                                              doc.unit ?? '');
                                        },
                                        child: Text(
                                          doc.hsCode ?? '',
                                          style: GoogleFonts.robotoCondensed(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue),
                                        ),
                                      )),
                                      DataCell(Text(doc.productCode ?? '')),
                                      DataCell(Text(doc.productName ?? '')),
                                      DataCell(
                                          Text(doc.productExpenseId ?? '')),
                                      DataCell(
                                          Text(doc.productExpenseId ?? '')),
                                      DataCell(Text(doc.customerName ?? '')),
                                      DataCell(
                                          Text(doc.unit?.toString() ?? '')),
                                      DataCell(IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 24,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          showDeleteProductDialog(
                                              context, doc.productName ?? '');
                                        },
                                      )),
                                    ]);
                                  }).toList(),
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
        content: Column(
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
                    const SizedBox(
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
                    const SizedBox(
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
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
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
                        color:
                            Provider.of<Providercolor>(context).selectedColor),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Hủy',
                      style: GoogleFonts.robotoCondensed(
                          color: Provider.of<Providercolor>(context)
                              .selectedColor),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
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
                    'Lưu',
                    style: GoogleFonts.robotoCondensed(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
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
