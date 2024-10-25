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
  int currentPage = 1;
  int itemsPerPage = 20;
  final List<int> itemsPerPageOptions = [10, 20, 30, 50];
  void _changePage(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
    });
  }

  final ScrollController _scrollController = ScrollController();
  late Future<List<DataUser>> users;
  UserService userService = UserService();
  final TextEditingController _searchController = TextEditingController();

  List<DataUser> _searchResults = [];
  List<DataUser> _filteredUsersRoom = [];
  List<DataUser> _filteredUsersBranch = [];
  List<DataUser> _staffList = [];
  DataUser? selectedUsers;
  TextEditingController _searchControllerBranch = TextEditingController();
  TextEditingController _searchControllerRoom = TextEditingController();
  bool _isSearching = false, isDropDownVisible = false;

  Future<void> _searchUsers(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    List<DataUser> results = await userService.searchUser(searchQuery);
    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

  @override
  void initState() {
    super.initState();
    users = userService.fetchUsers();
    _fetchStaffsData();
  }

  Future<void> _fetchStaffsData() async {
    try {
      List<DataUser> staff = await userService.fetchUsers();
      if (mounted) {
        setState(() {
          _staffList = staff;
          _filteredUsersRoom = staff;
          _filteredUsersBranch = staff;
        });
      }
    } catch (e) {
      print("Error fetching customer data: $e");
    }
  }

  void toggleDropDownVisibility() {
    setState(() {
      isDropDownVisible = !isDropDownVisible;
    });
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
        border: Border.all(
          width: 1,
          color: Colors.black38,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: width,
      height: 40,
      child: DropdownButton<String>(
        hint: Text(
          hint,
          style: const TextStyle(fontSize: 14, color: Colors.black),
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
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<String> getUniqueNames(
      List<dynamic> items, String Function(dynamic) nameSelector) {
    Set<String> seenNames = {};
    return items
        .map(nameSelector)
        .where((name) => seenNames.add(name ?? ''))
        .toList();
  }

  Widget renderUserDropdownBranch() {
    List<String> branchNames =
        getUniqueNames(_filteredUsersBranch, (user) => user.branchName ?? '');

    return buildDropdown(
      items: branchNames,
      selectedItem: _filteredUsersBranch
              .any((user) => user.branchName == selectedUsers?.branchName)
          ? selectedUsers?.branchName
          : null,
      hint: 'Tất cả chi nhánh',
      width: 170,
      onChanged: (String? newValue) {
        setState(() {
          selectedUsers = _filteredUsersBranch.firstWhere(
            (user) => user.branchName == newValue,
            orElse: () => _filteredUsersBranch[0],
          );
          _searchControllerBranch.text = selectedUsers?.branchName ?? '';
        });
      },
    );
  }

  Widget renderDropdownUser() {
    List<String> departmentNames =
        getUniqueNames(_filteredUsersRoom, (user) => user.departmentName ?? '');

    return buildDropdown(
      items: departmentNames,
      selectedItem: selectedUsers?.departmentName,
      hint: 'Tất cả phòng ban',
      width: 160,
      onChanged: (String? newValue) {
        setState(() {
          selectedUsers = _filteredUsersRoom.firstWhere(
            (user) => user.departmentName == newValue,
            orElse: () => _filteredUsersRoom[0],
          );
          _searchControllerRoom.text = selectedUsers?.departmentName ?? '';
        });
      },
    );
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
              Expanded(child: renderUserDropdownBranch()),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: renderDropdownUser(),
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
                      border: Border.all(width: 1, color: Colors.black38),
                      color: Colors.white),
                  child: TextField(
                    // autofocus: true,
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Tên tài khoản ...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      hintStyle: GoogleFonts.robotoCondensed(
                          fontSize: 14, color: Colors.black38),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _searchUsers(_searchController.text);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VerticalDivider(
                              color: Colors.black38,
                              width: 20,
                              thickness: 1,
                            ),
                            Icon(
                              Icons.search_outlined,
                              size: 24,
                              color: Colors.black38,
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
              child: FutureBuilder<List<DataUser>>(
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
                                  doc.positionName?.toString() ?? '',
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
