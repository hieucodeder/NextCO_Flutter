import 'package:app_1helo/model/customers.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/customer_service..dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Clientpage extends StatefulWidget {
  const Clientpage({super.key});

  @override
  State<Clientpage> createState() => _ClientpageState();
}

class _ClientpageState extends State<Clientpage> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<Data>> customers;
  CustomerService customerService = CustomerService();

  @override
  void initState() {
    super.initState();
    customers = customerService.fetchCustomer();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController taxCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Data> _searchResults = [];
  bool _isSearching = false;

  Future<void> _searchCustomers(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    List<Data> results = await customerService.searchCustomers(searchQuery);
    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    taxCodeController.dispose();
    addressController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showAddCustomerDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Provider.of<Providercolor>(context).selectedColor,
              ),
              child: Center(
                child: Text(
                  'Thêm mới khách hàng',
                  style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              )),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên khách hàng',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: taxCodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Mã thuế',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
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
                  'Hủy',
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
                'Lưu',
                style: GoogleFonts.robotoCondensed(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  final style = const TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black26)),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      label: Text(
                        'Nhập',
                        style: GoogleFonts.robotoCondensed(fontSize: 14),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _searchCustomers(_searchController.text);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VerticalDivider(
                              width: 20,
                              thickness: 1,
                              color: Colors.black26,
                            ),
                            Icon(
                              Icons.search_outlined,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 90,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    _showAddCustomerDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Provider.of<Providercolor>(context).selectedColor,
                    elevation: 5,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Thêm mới',
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Data>>(
              future: customers,
              builder: (context, snapshot) {
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
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Đã xảy ra lỗi"));
                } else if (snapshot.hasData) {
                  List<Data> displayList =
                      _isSearching ? _searchResults : snapshot.data!;
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
                            DataColumn(label: Text('Mã khách hàng')),
                            DataColumn(label: Text('Tên khách hàng')),
                            DataColumn(label: Text('Số điện thoại')),
                            DataColumn(label: Text('Mã số thuế')),
                            DataColumn(label: Text('Địa chỉ')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: displayList.map((doc) {
                            return DataRow(cells: [
                              DataCell(Text(doc.rowNumber?.toString() ?? '')),
                              DataCell(Text(
                                doc.customerId ?? '',
                                style: GoogleFonts.robotoCondensed(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue),
                              )),
                              DataCell(
                                  Text(doc.customerName?.toString() ?? '')),
                              DataCell(Text(doc.phoneNumber ?? '')),
                              DataCell(Text(doc.taxCode ?? '')),
                              DataCell(Text(doc.address ?? '')),
                              DataCell(IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 24,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // Thêm logic xóa khách hàng tại đây
                                },
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
