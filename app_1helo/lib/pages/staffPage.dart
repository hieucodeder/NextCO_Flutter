import 'package:app_1helo/model/user.dart';
import 'package:app_1helo/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      child: FutureBuilder<List<Data>>(
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
                          fontWeight: FontWeight.w700, color: Colors.blue),
                    )),
                    DataCell(Text(
                      doc.fullName?.toString() ?? '',
                    )),
                    DataCell(Text(doc.phoneNumber ?? '')),
                    DataCell(Text(
                      doc.email ?? '',
                      style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.w700, color: Colors.blue),
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
          );
        },
      ),
    );
  }
}
