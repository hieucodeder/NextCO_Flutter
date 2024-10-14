import 'package:app_1helo/model/user.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Staffpage extends StatefulWidget {
  const Staffpage({super.key});

  @override
  State<Staffpage> createState() => _StaffpageState();
}

class _StaffpageState extends State<Staffpage> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<Data>> users;
  UserService userService = UserService();
  final TextEditingController _searchController = TextEditingController();

  List<Data> _searchResults = [];
  bool _isSearching = false;

  Future<void> _searchUsers(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    List<Data> results = await userService.searchUser(searchQuery);
    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

  @override
  void initState() {
    super.initState();
    users = userService.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black26)),
                  padding: const EdgeInsets.all(7),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Tất cả chi nhánh',
                        hintStyle: GoogleFonts.robotoCondensed(fontSize: 14),
                        border: InputBorder.none,
                        suffixIcon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VerticalDivider(
                              width: 20,
                              thickness: 1,
                            ),
                            Icon(Icons.arrow_drop_down_rounded)
                          ],
                        )),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.black26),
                      color: Colors.white),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Tất cả phòng ban',
                        hintStyle: GoogleFonts.robotoCondensed(
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        suffixIcon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VerticalDivider(
                              width: 20,
                              thickness: 1,
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.black26),
                      color: Colors.white),
                  child: TextField(
                    autofocus: true,
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      label: Text(
                        'Tên tài khoản...',
                        style: GoogleFonts.robotoCondensed(fontSize: 16),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      hintStyle: GoogleFonts.robotoCondensed(fontSize: 14),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _searchUsers(_searchController.text);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VerticalDivider(
                              color: Colors.black26,
                              width: 20,
                              thickness: 1,
                            ),
                            Icon(
                              Icons.search_outlined,
                              size: 24,
                            )
                          ],
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        elevation: 5,
                        backgroundColor:
                            Provider.of<Providercolor>(context).selectedColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Thêm mới',
                      style: GoogleFonts.robotoCondensed(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                  border: Border.all(width: 1, color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]),
              padding: const EdgeInsets.all(10),
              child: FutureBuilder<List<Data>>(
                future: users,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
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
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Không tìm thấy user"));
                  }

                  final userList =
                      _isSearching ? _searchResults : snapshot.data!;

                  return SingleChildScrollView(
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
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('STT')),
                              DataColumn(label: Text('Tài khoản')),
                              DataColumn(label: Text('Họ và tên')),
                              DataColumn(label: Text('Số điện thoại')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Chức vụ')),
                              DataColumn(label: Text('Chi nhánh')),
                              DataColumn(label: Text('Phòng ban')),
                              DataColumn(label: Text('Phân quyền')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: userList.map((doc) {
                              return DataRow(cells: [
                                DataCell(Text(doc.rowNumber?.toString() ?? '')),
                                DataCell(Text(
                                  doc.userName?.toString() ?? '',
                                  style: GoogleFonts.robotoCondensed(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blue),
                                )),
                                DataCell(Text(
                                  doc.fullName?.toString() ?? '',
                                )),
                                DataCell(Text(doc.phoneNumber ?? '')),
                                DataCell(Text(
                                  doc.email ?? '',
                                  style: GoogleFonts.robotoCondensed(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blue),
                                )),
                                DataCell(Text(doc.positionName ?? '')),
                                DataCell(Text(doc.branchName ?? '')),
                                DataCell(Text(doc.departmentName ?? '')),
                                DataCell(Text(doc.roleGroup ?? '')),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          size: 24, color: Colors.orange),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.lock_open_outlined,
                                          size: 24,
                                          color: Colors.green,
                                        )),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 24,
                                          color: Colors.red,
                                        )),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.replay,
                                        size: 24,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
