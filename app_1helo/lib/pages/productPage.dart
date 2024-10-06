import 'package:app_1helo/model/productss.dart';
import 'package:app_1helo/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  void initState() {
    super.initState();
    fetchInitialProducts();
    _scrollController.addListener(_onScroll);
  }

  // Fetch initial products
  Future<void> fetchInitialProducts() async {
    setState(() => isLoading = true);
    List<Data> initialProducts = await productService.fetchProducts(currentPage, pageSize);
    setState(() {
      productList = initialProducts;
      isLoading = false;
      if (initialProducts.length < pageSize) {
        hasMoreData = false; // No more products to load
      }
    });
  }

  // Load more products when scrolled to the bottom
  Future<void> _loadMoreProducts() async {
    if (isLoading || !hasMoreData) return;

    setState(() => isLoading = true);
    currentPage++;
    List<Data> moreProducts = await productService.fetchProducts(currentPage, pageSize);
    setState(() {
      productList.addAll(moreProducts);
      isLoading = false;
      if (moreProducts.length < pageSize) {
        hasMoreData = false; // No more products to load
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
      _loadMoreProducts();
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
      color: Colors.black12,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Search bar
            Container(
              width: 300,
              height: 40,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Mã sản phẩm',
                          hintStyle: GoogleFonts.robotoCondensed()),
                    ),
                  ),
                  const Icon(Icons.search),
                ],
              ),
            ),
            const SizedBox(height: 10),
            
            // Product List Data Table
            Expanded(
              child: FutureBuilder<void>(
                future: fetchInitialProducts(),
                builder: (context, snapshot) {
                  if (isLoading && productList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (productList.isEmpty) {
                    return const Center(child: Text("No products found"));
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
                            DataColumn(label: Text('Mã HS')),
                            DataColumn(label: Text('Mã sản phẩm')),
                            DataColumn(label: Text('Thông tin sản phẩm')),
                            DataColumn(label: Text('Định mức')),
                            DataColumn(label: Text('Thông số trong QTSX')),
                            DataColumn(label: Text('Tổng SP chưa làm C/O')),
                            DataColumn(label: Text('Đơn vị tính')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: productList.map((doc) {
                            return DataRow(cells: [
                              DataCell(Text(doc.rowNumber?.toString() ?? '')),
                              DataCell(Text(
                                doc.hsCode ?? '',
                                style: GoogleFonts.robotoCondensed(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue),
                              )),
                              DataCell(Text(doc.productId ?? '')),
                              DataCell(Text(doc.productName ?? '')),
                              DataCell(Text(doc.normId ?? '')),
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
