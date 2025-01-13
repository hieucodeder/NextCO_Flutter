import 'package:app_1helo/model/account.dart';
import 'package:app_1helo/provider/provider_color.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:app_1helo/service/authservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerCustom extends StatefulWidget {
  final Function(int) onItemSelected;
  const DrawerCustom({super.key, required this.onItemSelected});

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final selectedColor = Provider.of<Providercolor>(context).selectedColor;
    final localization = AppLocalizations.of(context);
    return Drawer(
      backgroundColor: selectedColor,
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
                      icon: Icons.dashboard_outlined,
                      title: localization?.translate('dashboard') ??
                          'Bảng điều khiển',
                      onTap: () => widget.onItemSelected(0),
                    ),
                    _buildExpansionTile(
                      title: localization?.translate('managing_recordsdr') ??
                          'Quản lý hồ sơ C/O',
                      icon: Icons.backup_table,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: localization?.translate('list_documentsdr') ??
                              'Danh sách hồ sơ C/O',
                          onTap: () => widget.onItemSelected(3),
                        ),
                      ],
                    ),
                    _buildExpansionTile(
                      title: localization?.translate('material_managementdr') ??
                          'Quản lý nguyên vật liệu',
                      icon: Icons.layers_outlined,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: localization?.translate('material') ??
                              'Nguyên liệu',
                          onTap: () => widget.onItemSelected(8),
                        ),
                      ],
                    ),
                    _buildExpansionTile(
                      title: localization?.translate('statistical_reportdr') ??
                          'Báo cáo thống kê',
                      icon: Icons.dashboard_outlined,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title:
                              localization?.translate('product_inventorydr') ??
                                  'Báo cáo tồn sản phẩm',
                          onTap: () => widget.onItemSelected(12),
                        ),
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title:
                              localization?.translate('material_inventorydr') ??
                                  'Báo cáo tồn NVL',
                          onTap: () => widget.onItemSelected(13),
                        )
                      ],
                    ),
                    _buildExpansionTile(
                      title: localization?.translate('product_managementdr') ??
                          'Quản lý sản phẩm',
                      icon: Icons.view_compact_alt_outlined,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: localization
                                  ?.translate('product_informationdr') ??
                              'Thông tin sản phẩm',
                          onTap: () => widget.onItemSelected(7),
                        ),
                      ],
                    ),
                    _buildExpansionTile(
                      title: localization?.translate('technical_supportdr') ??
                          'Hỗ trợ kỹ thuật',
                      icon: Icons.space_dashboard_outlined,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: localization
                                  ?.translate('software_informationdr') ??
                              'Thông tin sử dụng phần mềm',
                          onTap: () => widget.onItemSelected(10),
                        ),
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: localization
                                  ?.translate('payment_informationdr') ??
                              'Thông tin thanh toán',
                          onTap: () => widget.onItemSelected(11),
                        ),
                      ],
                    ),
                    _buildExpansionTile(
                      title: localization
                              ?.translate('system_catalog_managementdr') ??
                          'Quản trị hệ thống và danh mục',
                      icon: Icons.space_dashboard_outlined,
                      children: [
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title: localization?.translate('user_managementdr') ??
                              'Quản lý người dùng',
                          onTap: () => widget.onItemSelected(6),
                        ),
                        _buildListTile(
                          icon: Icons.description_outlined,
                          title:
                              localization?.translate('customer_managemetdr') ??
                                  'Quản lý khách hàng',
                          onTap: () => widget.onItemSelected(9),
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
            onPressed: () => widget.onItemSelected(3),
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
    final localization = AppLocalizations.of(context);
    final colors = [
      const Color(0xff042E4D),
      const Color(0xff004225),
      const Color(0xff6b240c)
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Text(localization?.translate('colors') ?? 'Colors',
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
