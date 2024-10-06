import 'package:app_1helo/model/customers.dart';
import 'package:app_1helo/service/customer_service..dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    taxCodeController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _showAddCustomerDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm Khách Hàng'),
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                // String name = nameController.text;
                // String phone = phoneController.text;
                // String taxCode = taxCodeController.text;
                // String address = addressController.text;

                Navigator.of(context).pop();
              },
              child: const Text('Thêm'),
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
        color: Colors.black12,
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            label: Text(
                              'Nhập',
                              style: GoogleFonts.robotoCondensed(fontSize: 14),
                            ),
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          _showAddCustomerDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 38, 0, 255),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(10),
                          elevation: 30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Thêm mới',
                          style: GoogleFonts.robotoCondensed(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Data>>(
                future: customers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No documents found"));
                  }

                  final customerList = snapshot.data!;

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
                          DataColumn(label: Text('Mã khách hàng')),
                          DataColumn(label: Text('Tên khách hàng')),
                          DataColumn(label: Text('Số điện thoại')),
                          DataColumn(label: Text('Mã số thuế')),
                          DataColumn(label: Text('Địa chỉ')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: customerList.map((doc) {
                          return DataRow(cells: [
                            DataCell(Text(doc.rowNumber?.toString() ?? '')),
                            DataCell(Text(
                              doc.customerId ?? '',
                              style: GoogleFonts.robotoCondensed(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue),
                            )),
                            DataCell(Text(doc.customerName?.toString() ?? '')),
                            DataCell(Text(doc.phoneNumber ?? '')),
                            DataCell(Text(doc.taxCode ?? '')),
                            DataCell(Text(doc.address ?? '')),
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
                  );
                },
              ),
            ],
          ),
        ));
  }
}
