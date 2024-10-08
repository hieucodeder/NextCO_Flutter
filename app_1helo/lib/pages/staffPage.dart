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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black26)),
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Tất cả chi nhánh',
                        hintStyle: GoogleFonts.robotoCondensed(fontSize: 16),
                        border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.black26),
                      color: Colors.white),
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Tất cả phòng ban',
                        hintStyle: GoogleFonts.robotoCondensed(
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                  ),
                ),
              )
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.black26),
                      color: Colors.white),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      label: Text(
                        'Tên tài khoản...',
                        style: GoogleFonts.robotoCondensed(fontSize: 14),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      hintStyle: GoogleFonts.robotoCondensed(fontSize: 14),
                      suffixIcon: const Row(
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
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 100,
                  height: 40,
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
          FutureBuilder<List<Data>>(
            future: users,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No documents found"));
              }

              final userList = snapshot.data!;

              return Expanded(
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
              );
            },
          ),
        ],
      ),
    );
  }
}
