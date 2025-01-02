import 'package:app_1helo/model/dropdown_employee.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:app_1helo/service/authservice.dart';
import 'package:flutter/material.dart';
import 'package:app_1helo/service/statistics_service.dart';
import 'package:app_1helo/model/statistics.dart';
import 'package:google_fonts/google_fonts.dart';

class TableEmployeedPage extends StatefulWidget {
  final String employeeId;

  const TableEmployeedPage({
    required this.employeeId,
    required GlobalKey<TableEmployeedPageState> key,
  }) : super(key: key);

  @override
  TableEmployeedPageState createState() => TableEmployeedPageState();
}

class TableEmployeedPageState extends State<TableEmployeedPage> {
  List<Statuses>? statuses;
  bool isLoading = true;
  DropdownEmployee? selectedDropdownEmployee;
  List<DropdownEmployee> _filtereddropdownEmployee = [];
  String? _employeedId;
  final _authService = AuthService();
  @override
  void initState() {
    super.initState();
    _fetchStatistics();
    _fetchData();
  }

//Refres
  Future<void> refreshTabletData() async {
    setState(() {
      isLoading = true;
    });

    {
      setState(() {
        _fetchStatistics();
      });
    }
  }

  Future<void> _fetchStatistics() async {
    final fetchedStatuses = await StatisticsService().fetchStatistics();
    if (mounted) {
      setState(() {
        statuses = fetchedStatuses;
        isLoading = false;
      });
    }
  }

  Future<void> _fetchData({String? employeedId}) async {
    List<DropdownEmployee>? employees = await _authService.getEmployeeInfo();
    if (mounted) {
      setState(() {
        _filtereddropdownEmployee = employees ?? [];
      });
    }

    if (mounted) {
      setState(() {
        isLoading = false; // Dừng trạng thái tải
      });
    }
  }

  Widget buildDropdown({
    required List<String> items,
    required String? selectedItem,
    required String hint,
    required ValueChanged<String?> onChanged,
    double width = 200,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.black38),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: width,
      height: 40,
      child: DropdownButton<String>(
        hint: Text(
          hint,
          style: GoogleFonts.robotoCondensed(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
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
              style: GoogleFonts.robotoCondensed(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget renderEmployeed(BuildContext context) {
    final localization = AppLocalizations.of(context);

    // Lấy danh sách tên nhân viên từ _filtereddropdownEmployee
    List<String> employeeNames = _filtereddropdownEmployee
        .map((employee) => employee.label ?? '')
        .toSet()
        .toList();

    // Thêm mục "Tất cả nhân viên" vào danh sách
    String allEmployeesLabel =
        localization?.translate('all_employeed') ?? 'Tất cả nhân viên';
    employeeNames.insert(0, allEmployeesLabel);

    return buildDropdown(
      items: employeeNames, // Danh sách tên nhân viên
      selectedItem: selectedDropdownEmployee?.label ??
          allEmployeesLabel, // Tùy chọn hiện tại
      hint: allEmployeesLabel, // Gợi ý mặc định
      width: 180, // Độ rộng của dropdown
      onChanged: (String? newValue) {
        setState(() {
          if (newValue == allEmployeesLabel) {
            // Nếu chọn "Tất cả nhân viên"
            selectedDropdownEmployee = null;
            _employeedId = null;
          } else {
            // Tìm nhân viên tương ứng theo nhãn được chọn
            selectedDropdownEmployee = _filtereddropdownEmployee.firstWhere(
              (employee) => employee.label == newValue,
              orElse: () => _filtereddropdownEmployee[0],
            );
            _employeedId = selectedDropdownEmployee?.value;
          }
        });

        // Gọi lại _fetchData để cập nhật dữ liệu
        _fetchData(employeedId: _employeedId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final textStyle = GoogleFonts.robotoCondensed(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    );

    final Map<String, Color> statusColors = {
      "Từ chối xét duyệt": Colors.red,
      "Đã được duyệt hủy": Colors.red,
      "Đang chờ duyệt hủy": Colors.orange,
      "Chờ duyệt": Colors.orange,
      "Hoàn thành": Colors.green,
      "Đang thực hiện": Colors.black,
      "Đang chờ duyệt sửa": Colors.black,
      "Đã được duyệt sửa": Colors.black,
      "Tổng số lượng": Colors.black,
    };
    final Map<String, String> statusTranslations = {
      "Từ chối xét duyệt": localization?.translate('rejected') ?? "Rejected",
      "Đã được duyệt hủy":
          localization?.translate('approved_cancel') ?? "Approved Cancel",
      "Đang chờ duyệt hủy":
          localization?.translate('pending_cancel') ?? "Pending Cancel",
      "Chờ duyệt": localization?.translate('pending') ?? "Pending",
      "Hoàn thành": localization?.translate('completed') ?? "Completed",
      "Đang thực hiện": localization?.translate('in_progress') ?? "In Progress",
      "Đang chờ duyệt sửa":
          localization?.translate('pending_edit') ?? "Pending Edit",
      "Đã được duyệt sửa":
          localization?.translate('approved_edit') ?? "Approved Edit",
      "Tổng số lượng":
          localization?.translate('total_quantity') ?? "Total Quantity",
    };

    final Map<String, Color> statusColorsDarker =
        statusColors.map((key, color) {
      // Translate Vietnamese key to English
      final translatedKey = statusTranslations[key] ?? key;
      final hsl = HSLColor.fromColor(color);
      final darkerColor =
          hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0)).toColor();
      return MapEntry(translatedKey, darkerColor);
    });

    return Column(
      children: [
        FittedBox(child: SizedBox(width: 140, child: renderEmployeed(context))),
        SizedBox(
          width: double.infinity,
          height: 380,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : statuses == null || statuses!.isEmpty
                  ? Center(
                      child: Text(localization?.translate("no_data") ??
                          'No data found'))
                  : ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DataTable(
                              columns: [
                                DataColumn(
                                  label: Text(
                                    localization?.translate('status_name') ??
                                        'Status Name',
                                    style: textStyle,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    localization?.translate('quantity') ??
                                        'Quantity',
                                    style: textStyle,
                                  ),
                                ),
                              ],
                              // Xử lý các hàng trong DataTable
                              rows: statuses!.map((status) {
                                // Lấy tên trạng thái gốc
                                final originalStatusName =
                                    status.statusName ?? "";

                                // Dịch tên trạng thái sang tiếng Anh
                                final translatedStatusName =
                                    statusTranslations[originalStatusName] ??
                                        originalStatusName;

                                // Lấy màu từ statusColorsDarker dựa trên tên đã dịch
                                final statusColor =
                                    statusColorsDarker[translatedStatusName] ??
                                        Colors.black;

                                // Tạo DataRow cho DataTable
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Center(
                                        child: Text(
                                          translatedStatusName, // Hiển thị tên trạng thái đã dịch
                                          style: GoogleFonts.robotoCondensed(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: statusColor, // Màu tương ứng
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          "${status.quantity ?? 0}", // Hiển thị số lượng (nếu null thì mặc định là 0)
                                          style: GoogleFonts.robotoCondensed(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: statusColor, // Màu tương ứng
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ),
        ),
      ],
    );
  }
}
