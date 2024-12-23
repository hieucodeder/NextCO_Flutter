import 'package:app_1helo/charPage/columnCharPage.dart';
import 'package:app_1helo/navigation/BottomNavigation.dart';
import 'package:app_1helo/pages/AccoutPage.dart';
import 'package:app_1helo/pages/Changepassword.dart';
import 'package:app_1helo/pages/ChatBox.dart';
import 'package:app_1helo/pages/PayPage.dart';
import 'package:app_1helo/pages/customerPage.dart';
import 'package:app_1helo/pages/DSHoSoCO.dart';
import 'package:app_1helo/navigation/Drawer.dart';
import 'package:app_1helo/pages/facebookPage.dart';
import 'package:app_1helo/pages/funtionsPage.dart';
import 'package:app_1helo/pages/PersonalInfo.dart';
import 'package:app_1helo/pages/home_page.dart';
import 'package:app_1helo/pages/materialResportPage.dart';
import 'package:app_1helo/pages/materialsPage.dart';
import 'package:app_1helo/pages/productPage.dart';
import 'package:app_1helo/pages/productReportPage.dart';
import 'package:app_1helo/pages/staffPage.dart';
import 'package:app_1helo/provider/navigationProvider.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const Funtionspage();
      case 2:
        return const AcountPage();
      case 3:
        return const Dshosoco();
      case 4:
        return const PersonalInfo();
      case 5:
        return const Changepassword();
      case 6:
        return const Staffpage();
      case 7:
        return const ProductPage();
      case 8:
        return const Materialspage();
      case 9:
        return const Clientpage();
      case 10:
        return const Columncharpage();
      case 11:
        return const Paypage();
      case 12:
        return const Productreportpage();
      case 13:
        return const Materialresportpage();
      default:
        return const HomePage();
    }
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return "BÁO CÁO HOẠT ĐỘNG NEXTCO";
      case 1:
        return "CHỨC NĂNG NEXTCO";
      case 2:
        return "CÁ NHÂN";
      case 3:
        return "DANH SÁCH HỒ SƠ C/O";
      case 4:
        return "THÔNG TIN CÁ NHÂN";
      case 5:
        return "ĐỔI MẬT KHẨU";
      case 6:
        return "QUẢN LÝ NGƯỜI DÙNG";
      case 7:
        return "DANH SÁCH SẢN PHẨM";
      case 8:
        return "QUẢN LÝ NGUYÊN VẬT LIỆU";
      case 9:
        return "DANH SÁCH KHÁCH HÀNG";
      case 10:
        return "THÔNG TIN SỬ DỤNG PHẦN MỀM";
      case 11:
        return "THÔNG TIN THANH TOÁN";
      case 12:
        return "BÁO CÁO TỒN SẢN PHẨM ";
      case 13:
        return "BÁO CÁO TỒN NGUYÊN VẬT LIỆU ";
      default:
        return "BÁO CÁO HOẠT ĐỘNG NEXTCO";
    }
  }

  bool isExpanded = false;

  void _toggleButtons() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final currentIndex = navigationProvider.currentIndex;
    final selectedColor = Provider.of<Providercolor>(context).selectedColor;
    // const totalPages = 14;
    // final validIndex =
    //     (currentIndex >= 0 && currentIndex < totalPages) ? currentIndex : 0;

    return Scaffold(
      drawer: DrawerCustom(
        onItemSelected: (index) {
          navigationProvider.setCurrentIndex(index);
          Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(currentIndex),
          style: GoogleFonts.robotoCondensed(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    value: 'unread',
                    child: Text(
                      'Chưa đọc',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'all',
                    child: Text(
                      'Tất cả',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ).then((value) {
                if (value == 'all') {
                } else if (value == 'unread') {}
              });
            },
            icon: const Icon(Icons.notifications_none_outlined, size: 24),
            color: Colors.white,
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: selectedColor,
      ),
      body: _getPage(currentIndex),
      bottomNavigationBar: BottomNavigation(
          currentIndex: currentIndex.clamp(0, 2),
          onTap: (index) {
            navigationProvider.setCurrentIndex(index);
          }),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Visibility(
            visible: isExpanded,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 150.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  heroTag: 'uniqueTagForButton3',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FacebookPage()));
                  },
                  tooltip: 'Button 3',
                  backgroundColor: selectedColor,
                  child: const Icon(
                    Icons.facebook_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isExpanded,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  heroTag: 'uniqueTagForButton2',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Chatbox()));
                  },
                  backgroundColor: selectedColor,
                  tooltip: 'Button 2',
                  child: const Icon(
                    Icons.zoom_out_map_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isExpanded,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  heroTag: 'uniqueTagForButton1',
                  onPressed: () {
                    print('Button 1 Pressed');
                  },
                  backgroundColor: selectedColor,
                  tooltip: 'Button 1',
                  child: const Icon(
                    Icons.phone_callback_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              onPressed: _toggleButtons,
              tooltip: 'Toggle',
              backgroundColor: selectedColor,
              child: Icon(
                isExpanded ? Icons.close : Icons.support_agent_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
