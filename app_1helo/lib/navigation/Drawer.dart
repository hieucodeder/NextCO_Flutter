import 'package:app_1helo/model/account.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:app_1helo/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerCustom extends StatefulWidget {
  final Function(int) onSelectPage;

  const DrawerCustom({super.key, required this.onSelectPage});

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

final styleText =
    GoogleFonts.robotoCondensed(fontSize: 15, color: Colors.white);

class _DrawerCustomState extends State<DrawerCustom> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // width: double.infinity,
      backgroundColor: Provider.of<Providercolor>(context).selectedColor,
      child: SafeArea(
        minimum: const EdgeInsets.only(left: 5, top: 27, right: 20),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              // padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    iconSize: 23,
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSelectPage(0);
                    },
                  ),
                  SizedBox(
                    width: 80,
                    height: 30,
                    child: Image.asset(
                      'resources/Layer_1.png',
                      fit: BoxFit.contain,
                      width: 50,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black),
            ListTile(
              leading: Image.asset('resources/Dashboard_fill.png'),
              title: Text('Thống kê báo cáo', style: styleText),
              onTap: () {
                Navigator.pop(context);
                widget.onSelectPage(0);
              },
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      
                      // height: MediaQuery.of(context).size.height - 135,
                      child: Column(
                        children: [
                          ExpansionTile(
                            collapsedBackgroundColor:
                                const Color(0xfffafafa).withOpacity(0.1),
                            backgroundColor:
                                const Color(0xfffafafa).withOpacity(0.3),
                            title: Text(
                              'Quản lý hồ sơ C/O',
                              style: styleText,
                            ),
                            leading: const Icon(
                              Icons.abc,
                              color: Colors.white,
                            ),
                            childrenPadding: const EdgeInsets.only(
                                left: 4, right: 4, top: 8, bottom: 8),
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.abc,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  'Danh sách hồ sơ C/O',
                                  style: styleText,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.onSelectPage(3);
                                },
                              ),
                            ],
                          ),
                          ExpansionTile(
                            leading: const Icon(
                              Icons.indeterminate_check_box_outlined,
                              color: Colors.white,
                            ),
                            title: Text(
                              'Quản lý nguyên vật liệu',
                              style: styleText,
                            ),
                            childrenPadding: const EdgeInsets.only(left: 20.0),
                            children: [
                              ListTile(
                                leading: const Icon(Icons.settings,
                                    color: Colors.white),
                                title: Text('Nguyên Liệu', style: styleText),
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.onSelectPage(8);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings,
                                    color: Colors.white),
                                title: Text('Tờ khai nhập', style: styleText),
                                onTap: () {
                                  print("Sub item 2 tapped");
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings,
                                    color: Colors.white),
                                title: Text('Hóa đơn VAT', style: styleText),
                                onTap: () {
                                  print("Sub item 2 tapped");
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                title: Text('Quản lý tờ khai AMA',
                                    style: styleText),
                                onTap: () {
                                  print("Sub item 2 tapped");
                                },
                              ),
                            ],
                          ),
                          ExpansionTile(
                            leading: const Icon(
                              Icons.indeterminate_check_box_outlined,
                              color: Colors.white,
                            ),
                            title: Text('Quản lý sản phẩm', style: styleText),
                            childrenPadding: const EdgeInsets.only(left: 20.0),
                            children: [
                              ListTile(
                                leading: const Icon(Icons.settings,
                                    color: Colors.white),
                                title: Text('Thông tin sản phẩm',
                                    style: styleText),
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.onSelectPage(7);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings,
                                    color: Colors.white),
                                title: Text('Tờ khai xuất', style: styleText),
                                onTap: () {
                                  print("Sub item 2 tapped");
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings,
                                    color: Colors.white),
                                title: Text('Tờ khai xuất dự kiến',
                                    style: styleText),
                                onTap: () {
                                  print("Sub item 2 tapped");
                                },
                              ),
                            ],
                          ),
                          ExpansionTile(
                            leading: const Icon(
                              Icons.indeterminate_check_box_outlined,
                              color: Colors.white,
                            ),
                            title: Text('Quản lý tồn', style: styleText),
                            childrenPadding: const EdgeInsets.only(left: 20.0),
                            children: [
                              ExpansionTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title: Text('Thực hiện chốt tồn',
                                    style: styleText),
                                childrenPadding:
                                    const EdgeInsets.only(left: 20.0),
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.safety_check,
                                        color: Colors.white),
                                    title:
                                        Text('Chốt tồn NVL', style: styleText),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.safety_check,
                                        color: Colors.white),
                                    title: Text('Chốt tồn sản phẩm',
                                        style: styleText),
                                  )
                                ],
                              ),
                              ExpansionTile(
                                leading: const Icon(Icons.abc),
                                title:
                                    Text('Theo dõi chốt tồn', style: styleText),
                                childrenPadding:
                                    const EdgeInsets.only(left: 20),
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.safety_check,
                                        color: Colors.white),
                                    title: Text('Theo dõi chốt tồn NVL',
                                        style: styleText),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.safety_check,
                                        color: Colors.white),
                                    title: Text('Theo dõi chố tồn sản phẩm',
                                        style: styleText),
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                leading: const Icon(Icons.settings,
                                    color: Colors.white),
                                title: Text('Cập nhật tồn', style: styleText),
                                childrenPadding:
                                    const EdgeInsets.only(left: 20),
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.safety_check,
                                        color: Colors.white),
                                    title: Text('Cập nhật tồn thủ công',
                                        style: styleText),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.safety_check,
                                        color: Colors.white),
                                    title: Text('Cập nhật tồn tiêu hủy',
                                        style: styleText),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.safety_check,
                                        color: Colors.white),
                                    title: Text('Lịch sử cập nhật tồn',
                                        style: styleText),
                                  )
                                ],
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings,
                                    color: Colors.white),
                                title:
                                    Text('Cập nhật chốt tồn', style: styleText),
                                onTap: () {
                                  print("Sub item 2 tapped");
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                title: Text('Lịch sử cập nhật tồn',
                                    style: styleText),
                                onTap: () {
                                  print("Sub item 2 tapped");
                                },
                              ),
                            ],
                          ),
                          ExpansionTile(
                            leading: const Icon(Icons.abc, color: Colors.white),
                            title: Text('Báo cáo thống kê', style: styleText),
                            childrenPadding: const EdgeInsets.only(left: 20),
                            children: [
                              ExpansionTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title:
                                    Text('Báo cao tồn C/O', style: styleText),
                                childrenPadding:
                                    const EdgeInsets.only(left: 20),
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.abc,
                                        color: Colors.white),
                                    title: Text('Báo cáo tồn NVL',
                                        style: styleText),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.abc,
                                        color: Colors.white),
                                    title: Text('Báo cáo tồn SP',
                                        style: styleText),
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title: Text('Báo cáo tồn hải quan',
                                    style: styleText),
                                childrenPadding:
                                    const EdgeInsets.only(left: 20),
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.abc,
                                        color: Colors.white),
                                    title: Text('Báo cáo tồn NVL',
                                        style: styleText),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.abc,
                                        color: Colors.white),
                                    title: Text('Báo cáo tồn SP',
                                        style: styleText),
                                  )
                                ],
                              )
                            ],
                          ),
                          ExpansionTile(
                            leading: const Icon(Icons.abc, color: Colors.white),
                            title: Text('Hỗ trợ kỹ thuật', style: styleText),
                            childrenPadding: const EdgeInsets.only(left: 20),
                            children: [
                              ListTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title: Text('Yêu cầu hỗ trợ', style: styleText),
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title: Text('Thông tin kích hoạt',
                                    style: styleText),
                              )
                            ],
                          ),
                          ExpansionTile(
                            leading: const Icon(Icons.abc, color: Colors.white),
                            title: Text('Quản lý hệ thống và danh mục',
                                style: styleText),
                            childrenPadding: const EdgeInsets.only(left: 20),
                            children: [
                              ListTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title:
                                    Text('Quản lý chi nhánh', style: styleText),
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title:
                                    Text('Quản lý phòng ban', style: styleText),
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title: Text('Quản lý người dùng',
                                    style: styleText),
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title: Text('Quản lý khách hàng',
                                    style: styleText),
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title:
                                    Text('Quản lý tính năng', style: styleText),
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title: Text('Quản lý nhóm quyền',
                                    style: styleText),
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title: Text('Quản lý đơn vị tính',
                                    style: styleText),
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title: Text('Quản lý quy tắc cụ thể hàng hóa',
                                    style: styleText),
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.abc, color: Colors.white),
                                title: Text('Quản lý nguồn đồng bộ dữ liệu',
                                    style: styleText),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    'Colors:',
                    style: GoogleFonts.robotoCondensed(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Wrap(
                      children: List<Widget>.generate(3, (int index) {
                    final colors = [
                      const Color(0xff042E4D),
                      const Color(0xff004225),
                      const Color(0xff6b240c)
                    ];
                    return Card(
                      margin: const EdgeInsets.all(4),
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          side: const BorderSide(
                              color: Colors.white, width: 1.0)),
                      color: colors[index],
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<Providercolor>(context, listen: false)
                              .changeColor(colors[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 1.0),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: colors[index],
                            child: Provider.of<Providercolor>(context)
                                        .selectedColor ==
                                    colors[index]
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  }))
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder<Account?>(
              future: _authService.getAccountInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Có lỗi xảy ra: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  final account = snapshot.data!;
                  final fullName = account.fullName ?? 'Không có tên đầy đủ';
                  final userName =
                      account.userName ?? 'Không có tên người dùng';

                  return Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50,
                          child: Image.asset(
                            'resources/icon.png',
                            fit: BoxFit.contain,
                            height: 45,
                            width: 40,
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName,
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                userName,
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('Không có dữ liệu'));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
