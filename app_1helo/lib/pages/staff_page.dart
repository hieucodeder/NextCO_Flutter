// ignore_for_file: non_constant_identifier_names, empty_catches

import 'package:app_1helo/model/dropdown_customer.dart';
import 'package:app_1helo/model/user.dart';
import 'package:app_1helo/provider/provider_color.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:app_1helo/service/authservice.dart';
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
  int pageSize = 10;
  int itemsPerPage = 10;
  final List<int> itemsPerPageOptions = [10, 20, 30];
  final ScrollController _scrollController = ScrollController();

  late Future<List<DataUser>> users;
  UserService userService = UserService();
  final _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchControllerBranch = TextEditingController();
  final TextEditingController _searchControllerRoom = TextEditingController();

  List<DataUser> _searchResults = [];
  List<DataUser> _filteredUsersRoom = [];
  List<DataUser> _filteredUsersBranch = [];
  List<DataUser> _staffList = [];
  List<EmployeeCustomer> _filteredEmployeeCustomer = [];
  EmployeeCustomer? selectedEmployeeCustomer;
  DataUser? selectedBranchUser;
  DataUser? selectedRoomUser;
  bool _isSearching = false;
  bool isDropDownVisible = false;
  bool isLoading = false;
  bool hasMoreData = true;
  String? _customerId;
  String? BranchStaff;
  String? RoomStaff;

  @override
  void initState() {
    super.initState();
    fetchInitialStaff();
    _fetchBranchData();
    _fetchRoomData();
    _fetchData();
    fetchCustomerInfo();
  }

  Future<void> fetchInitialStaff() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    List<DataUser> initialStaff =
        await userService.fetchUsers(currentPage, itemsPerPage);

    if (mounted) {
      setState(() {
        _staffList = initialStaff;
        isLoading = false;
        if (initialStaff.length < itemsPerPage) {
          hasMoreData = false;
        }
      });
    }
  }

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

  Future<void> fetchCustomerInfo() async {
    try {
      List<EmployeeCustomer>? customers =
          await _authService.getEmployeeCustomerInfo();
      if (mounted) {
        setState(() {
          _filteredEmployeeCustomer = customers ?? [];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _filteredEmployeeCustomer = [];
        });
      }
    }
  }

  Future<void> _fetchData({String? customerId}) async {
    if (mounted) {
      setState(() {
        isLoading = true;
        _isSearching = true;
        _staffList.clear();
        currentPage = 1;
        hasMoreData = true;
      });
    }

    await fetchCustomerInfo();

    try {
      // Tìm kiếm dữ liệu người dùng
      final branchName = selectedBranchUser?.branchName ?? BranchStaff;
      final departmentName = selectedRoomUser?.departmentName ?? RoomStaff;

      final userResponse = await userService.fetchUserData(
        currentPage,
        pageSize,
        branchName,
        departmentName,
        customerId,
      );

      if (!mounted) return;

      // Cập nhật giao diện sau khi lấy dữ liệu thành công
      setState(() {
        _isSearching = false;
        isLoading = false;
        _staffList = userResponse?.data ?? [];
        if ((userResponse?.data ?? []).length < itemsPerPage) {
          hasMoreData = false;
        }
      });
    } catch (e) {
      // Xử lý lỗi và cập nhật trạng thái
      if (mounted) {
        setState(() {
          isLoading = false;
          _isSearching = false;
          hasMoreData = false;
        });
      }
    }
  }

  Future<void> _fetchRoomData() async {
    try {
      List<DataUser> staff =
          await userService.fetchUsers(currentPage, pageSize);
      if (mounted) {
        setState(() {
          _staffList = staff;
          _filteredUsersRoom = staff;
        });
      }
    } catch (e) {}
  }

  Future<void> _fetchBranchData() async {
    try {
      List<DataUser> staff =
          await userService.fetchUsers(currentPage, pageSize);
      if (mounted) {
        setState(() {
          _staffList = staff;
          _filteredUsersBranch = staff;
        });
      }
    } catch (e) {}
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
        border: Border.all(width: 1, color: Colors.black38),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: width,
      height: 40,
      child: DropdownButton<String>(
        hint: Text(
          hint,
          style: const TextStyle(fontSize: 14, color: Colors.black),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
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
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        }).toList(),
      ),
    );
  }

  List<String> getUniqueNames(
      List<DataUser> items, String Function(DataUser) nameSelector) {
    return items
        .map(nameSelector)
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }

  Widget renderUserDropdownBranch(BuildContext context) {
    final localization = AppLocalizations.of(context);
    List<String> branchNames =
        getUniqueNames(_filteredUsersBranch, (user) => user.branchName ?? '');
    String allBranch =
        localization?.translate('all_branch') ?? 'Tất cả chi nhánh';
    branchNames.insert(0, allBranch);

    return buildDropdown(
      items: branchNames,
      selectedItem: selectedBranchUser?.branchName,
      hint: allBranch,
      width: 170,
      onChanged: (String? newValue) {
        setState(() {
          selectedBranchUser = newValue == allBranch
              ? null
              : _filteredUsersBranch.firstWhere(
                  (user) => user.branchName == newValue,
                  orElse: () => _filteredUsersBranch[0],
                );
          _searchControllerBranch.text = selectedBranchUser?.branchName ?? '';
          _fetchData();
        });
      },
    );
  }

  Widget renderDropdownRooms(BuildContext context) {
    final localization = AppLocalizations.of(context);
    List<String> departmentNames =
        getUniqueNames(_filteredUsersRoom, (user) => user.departmentName ?? '');
    String allDepartment =
        localization?.translate('all_department') ?? 'Tất cả phòng ban';
    departmentNames.insert(0, allDepartment);

    return buildDropdown(
      items: departmentNames,
      selectedItem: selectedRoomUser?.departmentName,
      hint: allDepartment,
      width: 160,
      onChanged: (String? newValue) {
        setState(() {
          selectedRoomUser = newValue == allDepartment
              ? null
              : _filteredUsersRoom.firstWhere(
                  (user) => user.departmentName == newValue,
                  orElse: () => _filteredUsersRoom[0],
                );
          _searchControllerRoom.text = selectedRoomUser?.departmentName ?? '';
          _fetchData();
        });
      },
    );
  }

  Widget renderCustomer(BuildContext context) {
    final localization = AppLocalizations.of(context);
    List<String> customerNames = _filteredEmployeeCustomer
        .map((u) => u.customerName ?? '')
        .toSet()
        .toList();
    String allCustomer =
        localization?.translate('all_customers') ?? 'Tất cả khách hàng';
    customerNames.insert(0, allCustomer);

    return buildDropdown(
      items: customerNames,
      selectedItem: selectedEmployeeCustomer?.customerName,
      hint: allCustomer,
      onChanged: (String? newValue) {
        setState(() {
          selectedEmployeeCustomer = newValue == allCustomer
              ? null
              : _filteredEmployeeCustomer.firstWhere(
                  (u) => u.customerName == newValue,
                  orElse: () => _filteredEmployeeCustomer[0],
                );
          _customerId = selectedEmployeeCustomer?.customerId;
        });
        _fetchData(customerId: _customerId);
      },
    );
  }

  final _textxData = GoogleFonts.robotoCondensed(
      fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500);
  final _textTitile = GoogleFonts.robotoCondensed(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    List<DataUser> displayList = (_isSearching ? _searchResults : _staffList)
      ..sort((a, b) => (a.rowNumber ?? 0).compareTo(b.rowNumber ?? 0));
    final localization = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(
                  child: SizedBox(width: 180, child: renderCustomer(context))),
              const SizedBox(
                width: 6,
              ),
              FittedBox(
                child: SizedBox(
                  width: 180,
                  child: renderDropdownRooms(context),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(
                child: Container(
                  width: 180,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.black38),
                      color: Colors.white),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: localization?.translate('search_user') ??
                          'Tên tài khoản ...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      hintStyle: GoogleFonts.robotoCondensed(
                          fontSize: 15, color: Colors.black38),
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
              const SizedBox(
                width: 6.0,
              ),
              FittedBox(
                child: SizedBox(
                  width: 180,
                  child: renderUserDropdownBranch(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: displayList.isEmpty && _isSearching
                ? const Center(child: CircularProgressIndicator())
                : displayList.isEmpty
                    ? Center(
                        child: Text(
                          localization?.translate('data_null') ??
                              "Dữ liệu tìm kiếm không có!!!",
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            color: Provider.of<Providercolor>(context)
                                .selectedColor,
                          ),
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
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization?.translate('account') ??
                                              'Tài khoản',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization
                                                  ?.translate('full_name') ??
                                              'Họ và tên',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization
                                                  ?.translate('phone_number') ??
                                              'Số điện thoại',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization?.translate('email') ??
                                              'Email',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization?.translate('position') ??
                                              'Chức vụ',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization?.translate('branch') ??
                                              'Chi nhánh',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization
                                                  ?.translate('departments') ??
                                              'Phòng ban',
                                          style: _textTitile)),
                                  DataColumn(
                                      label: Text(
                                          localization?.translate(
                                                  'decentralization') ??
                                              'Phân quyền',
                                          style: _textTitile)),
                                  // DataColumn(label: Text('Action')),
                                ],
                                rows: displayList.map((doc) {
                                  return DataRow(cells: [
                                    DataCell(Center(
                                        child: Text(
                                      doc.rowNumber?.toString() ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                      child: Text(
                                        doc.userName?.toString() ?? '',
                                        style: GoogleFonts.robotoCondensed(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Colors.blue),
                                      ),
                                    )),
                                    DataCell(Center(
                                        child: Text(
                                      doc.fullName ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                        child: Text(
                                      doc.phoneNumber ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                      child: Text(
                                        doc.email ?? '',
                                        style: GoogleFonts.robotoCondensed(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Colors.blue),
                                      ),
                                    )),
                                    DataCell(Center(
                                        child: Text(
                                      doc.positionName ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                        child: Text(
                                      doc.branchName ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                        child: Text(
                                      doc.departmentName ?? '',
                                      style: _textxData,
                                    ))),
                                    DataCell(Center(
                                        child: Text(
                                      doc.roleGroup ?? '',
                                      style: _textxData,
                                    ))),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
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
                          fetchInitialStaff();
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
                  child: Text(
                    '$currentPage',
                    style: _textxData,
                  ),
                ),
                IconButton(
                  onPressed: hasMoreData
                      ? () {
                          setState(() {
                            currentPage += 1;
                          });
                          fetchInitialStaff();
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
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
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
                        fetchInitialStaff();
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
