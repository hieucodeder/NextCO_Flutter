import 'package:app_1helo/model/customers.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/appLocalizations%20.dart';
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
  CustomerService customerService = CustomerService();
  bool isLoading = false;
  int currentPage = 1;
  int pageSize = 10;
  List<Data> customerList = [];
  bool hasMoreData = true;

  int itemsPerPage = 10;
  final List<int> itemsPerPageOptions = [10, 20, 30];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController taxCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Data> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchInitialCustomers();
    // _scrollController.addListener(_onScroll);
  }

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

  Future<void> fetchInitialCustomers() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    List<Data> initialCustomers =
        await customerService.fetchCustomer(currentPage, itemsPerPage);

    if (mounted) {
      setState(() {
        customerList = initialCustomers;
        isLoading = false;
        if (initialCustomers.length < itemsPerPage) {
          hasMoreData = false;
        }
      });
    }
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

  final _textxData = GoogleFonts.robotoCondensed(
      fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500);
  final _textTitile = GoogleFonts.robotoCondensed(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    List<Data> displayList = (_isSearching ? _searchResults : customerList)
      ..sort((a, b) => (a.rowNumber ?? 0).compareTo(b.rowNumber ?? 0));
    final localization = AppLocalizations.of(context);
    return Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(10),
        color: Colors.grey[200],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black38)),
                    child: TextField(
                      // autofocus: true,
                      controller: _searchController,
                      style: GoogleFonts.robotoCondensed(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: localization?.translate('search_customer') ??
                            'Nhập KH, tên KH, mã số thuế ...',
                        hintStyle: GoogleFonts.robotoCondensed(
                            fontSize: 15,
                            color: Colors.black38,
                            fontWeight: FontWeight.w500),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
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
                                color: Colors.black38,
                              ),
                              Icon(
                                Icons.search_outlined,
                                size: 24,
                                color: Colors.black38,
                              ),
                            ],
                          ),
                        ),
                      ),
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
                              localization?.translate('data_null') ??
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
                                          label: Text(
                                        localization?.translate(
                                                'numerical_order') ??
                                            'STT',
                                        style: _textTitile,
                                        textAlign: TextAlign.center,
                                      )),
                                      DataColumn(
                                          label: Text(
                                              localization?.translate(
                                                      'customer_code') ??
                                                  'Mã khách hàng',
                                              style: _textTitile,
                                              textAlign: TextAlign.center)),
                                      DataColumn(
                                          label: Text(
                                              localization?.translate(
                                                      'customer_name') ??
                                                  'Tên khách hàng',
                                              style: _textTitile,
                                              textAlign: TextAlign.center)),
                                      DataColumn(
                                        label: Text(
                                            localization?.translate(
                                                    'phone_number') ??
                                                'Số điện thoại',
                                            style: _textTitile,
                                            textAlign: TextAlign.center),
                                      ),
                                      DataColumn(
                                          label: Text(
                                              localization
                                                      ?.translate('tax_code') ??
                                                  'Mã số thuế',
                                              style: _textTitile,
                                              textAlign: TextAlign.center)),
                                      DataColumn(
                                          label: Text(
                                              localization
                                                      ?.translate('address') ??
                                                  'Địa chỉ',
                                              style: _textTitile,
                                              textAlign: TextAlign.center)),
                                    ],
                                    rows: displayList.map((doc) {
                                      return DataRow(cells: [
                                        DataCell(Container(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            doc.rowNumber?.toString() ?? '',
                                            style: _textxData,
                                          ),
                                        )),
                                        DataCell(InkWell(
                                          onTap: () {
                                            showCustomerDetailsDialog(
                                                context,
                                                doc.customerName ?? '',
                                                doc.phoneNumber ?? '',
                                                doc.taxCode ?? '',
                                                doc.address ?? '');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              doc.customerId ?? '',
                                              style:
                                                  GoogleFonts.robotoCondensed(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.blue,
                                                      fontSize: 14),
                                            ),
                                          ),
                                        )),
                                        DataCell(Text(
                                          doc.customerName?.toString() ?? '',
                                          style: _textxData,
                                        )),
                                        DataCell(Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              doc.phoneNumber ?? '',
                                              style: _textxData,
                                            ))),
                                        DataCell(Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              doc.taxCode ?? '',
                                              style: _textxData,
                                            ))),
                                        DataCell(Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              doc.address ?? '',
                                              style: _textxData,
                                            ))),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          )),
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
                            fetchInitialCustomers();
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
                            fetchInitialCustomers();
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
                              '$value/${localization?.translate('page') ?? 'trang'}',
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
                          fetchInitialCustomers();
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

void showCustomerDetailsDialog(BuildContext context, String customerName,
    String phone, String taxId, String address) {
  TextEditingController customerNameController =
      TextEditingController(text: customerName);
  TextEditingController phoneController = TextEditingController(text: phone);
  TextEditingController taxIdController = TextEditingController(text: taxId);
  TextEditingController addressController =
      TextEditingController(text: address);
  final textStyleDiaLog = GoogleFonts.robotoCondensed(
      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
  final localization = AppLocalizations.of(context);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            localization?.translate('customer_details') ??
                'Chi tiết khách hàng',
          ),
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '*',
                        style: GoogleFonts.robotoCondensed(color: Colors.red),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        localization?.translate('customer_name') ??
                            'Tên khách hàng',
                        style: textStyleDiaLog,
                      ),
                    ],
                  ),
                  TextField(
                    controller: customerNameController,
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
                  Row(
                    children: [
                      Text(
                        '*',
                        style: GoogleFonts.robotoCondensed(color: Colors.red),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        localization?.translate('phone_number') ??
                            'Số điện thoại',
                        style: textStyleDiaLog,
                      ),
                    ],
                  ),
                  TextField(
                    controller: phoneController,
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
                  Row(
                    children: [
                      Text(
                        '*',
                        style: GoogleFonts.robotoCondensed(color: Colors.red),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        localization?.translate('tax_code') ?? 'Mã số thuế',
                        style: textStyleDiaLog,
                      ),
                    ],
                  ),
                  TextField(
                    controller: taxIdController,
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
                  Row(
                    children: [
                      Text(
                        '*',
                        style: GoogleFonts.robotoCondensed(color: Colors.red),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        localization?.translate('address') ?? 'Địa chỉ',
                        style: textStyleDiaLog,
                      ),
                    ],
                  ),
                  TextField(
                    controller: addressController,
                    readOnly: true,
                    maxLines: 3,
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
                        localization?.translate('close') ?? 'Đóng',
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
