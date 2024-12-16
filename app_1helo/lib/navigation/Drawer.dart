import 'package:app_1helo/model/account.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerCustom extends StatefulWidget {
  final Function(int) onSelectPage;

  const DrawerCustom({Key? key, required this.onSelectPage}) : super(key: key);

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  final AuthService _authService = AuthService();
  int _currentIndex = 0;

  void _onTileTap(int index) {
    setState(() {
      _currentIndex = index;
      widget.onSelectPage(index);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Provider.of<Providercolor>(context).selectedColor,
      child: SafeArea(
        minimum: const EdgeInsets.only(left: 5, top: 27, right: 20),
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(color: Colors.black),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildListTile(
                      icon: Icons.dashboard,
                      title: 'Thống kê báo cáo',
                      onTap: () => _onTileTap(0),
                    ),
                    _buildExpansionTile(
                      title: 'Quản lý hồ sơ C/O',
                      icon: Icons.backup_table_outlined,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: 'Danh sách hồ sơ C/O',
                          onTap: () => _onTileTap(3),
                        ),
                      ],
                    ),
                    _buildExpansionTile(
                      title: 'Quản lý nguyên vật liệu',
                      icon: Icons.layers_outlined,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: 'Nguyên liệu',
                          onTap: () => _onTileTap(8),
                        ),
                      ],
                    ),
                    _buildExpansionTile(
                      title: 'Báo cáo thống kê',
                      icon: Icons.dashboard,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: 'Báo cáo tồn SP',
                          onTap: () => _onTileTap(8),
                        ),
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: 'Báo cáo tồn NVL',
                          onTap: () => _onTileTap(8),
                        )
                      ],
                    ),
                    _buildExpansionTile(
                      title: 'Quản lý sản phẩm',
                      icon: Icons.view_compact_alt_outlined,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: 'Thông tin sản phẩm',
                          onTap: () => _onTileTap(7),
                        ),
                      ],
                    ),
                    _buildExpansionTile(
                      title: 'Hỗ trợ kỹ thuật',
                      icon: Icons.space_dashboard_outlined,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: 'Thông tin sử dụng phần mềm',
                          onTap: () => _onTileTap(10),
                        ),
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: 'Thông tin thanh toán',
                          onTap: () => _onTileTap(11),
                        ),
                      ],
                    ),
                    _buildExpansionTile(
                      title: 'Quản trị hệ thống và danh mục',
                      icon: Icons.space_dashboard_outlined,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: 'Quản lý người dùng',
                          onTap: () => _onTileTap(6),
                        ),
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: 'Quản lý khách hàng',
                          onTap: () => _onTileTap(9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buildColorSelector(context),
            _buildUserAccount(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            iconSize: 23,
            onPressed: () => _onTileTap(0),
          ),
          SvgPicture.asset(
            'resources/logo.svg',
            width: 80,
            height: 30,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title,
          style:
              GoogleFonts.robotoCondensed(fontSize: 15, color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.robotoCondensed(fontSize: 15, color: Colors.white),
      ),
      childrenPadding: const EdgeInsets.only(left: 20.0),
      iconColor: Colors.white,
      collapsedIconColor: Colors.grey,
      children: children,
    );
  }

  Widget _buildColorSelector(BuildContext context) {
    final colors = [
      const Color(0xff042E4D),
      const Color(0xff004225),
      const Color(0xff6b240c)
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Text('Colors:',
              style: GoogleFonts.robotoCondensed(
                  fontSize: 15, color: Colors.white)),
          const SizedBox(width: 5),
          Wrap(
            children: colors.map((color) {
              return GestureDetector(
                onTap: () => Provider.of<Providercolor>(context, listen: false)
                    .changeColor(color),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Provider.of<Providercolor>(context).selectedColor ==
                          color
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : const SizedBox.shrink(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAccount() {
    return FutureBuilder<Account?>(
      future: _authService.getAccountInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final account = snapshot.data!;
          return ListTile(
            leading: SvgPicture.asset('resources/name.svg',
                height: 45, width: 40, fit: BoxFit.contain),
            title: Text(
              account.fullName ?? 'Không có tên đầy đủ',
              style: GoogleFonts.robotoCondensed(
                  color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(
              account.userName ?? 'Không có tên người dùng',
              style: GoogleFonts.robotoCondensed(
                  color: Colors.white, fontSize: 16),
            ),
          );
        } else {
          return const Center(child: Text('Không có dữ liệu'));
        }
      },
    );
  }
}
