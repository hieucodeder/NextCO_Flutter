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
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.black26),
              color: Colors.white,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Mã sản phẩm',
                hintStyle: GoogleFonts.robotoCondensed(),
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
                        color: Colors.black12,
                        thickness: 1,
                      ),
                      Icon(
                        Icons.search_outlined,
                        size: 24,
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
                    : Scrollbar(
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
                                DataColumn(label: Text('Thông tin sản phẩm')),
                                DataColumn(label: Text('Định mức')),
                                DataColumn(label: Text('Thông số trong QTSX')),
                                DataColumn(label: Text('Tổng SP chưa làm C/O')),
                                DataColumn(label: Text('Đơn vị tính')),
                                DataColumn(label: Text('Action')),
                              ],
                              rows: displayList.map((doc) {
                                return DataRow(cells: [
                                  DataCell(
                                      Text(doc.rowNumber?.toString() ?? '')),
                                  DataCell(Text(
                                    doc.hsCode ?? '',
                                    style: GoogleFonts.robotoCondensed(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue),
                                  )),
                                  DataCell(Text(doc.productCode ?? '')),
                                  DataCell(Text(doc.productName ?? '')),
                                  DataCell(Text(doc.productExpenseId ?? '')),
                                  DataCell(Text(doc.productExpenseId ?? '')),
                                  DataCell(Text(doc.customerName ?? '')),
                                  DataCell(Text(doc.unit?.toString() ?? '')),
                                  DataCell(IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 24,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {},
                                  )),
                                ]);
                              }).toList(),
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
        ],
      ),
    );
  }
}
