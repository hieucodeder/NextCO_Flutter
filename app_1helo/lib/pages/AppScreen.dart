import 'package:app_1helo/charPage/columnCharPage.dart';
import 'package:app_1helo/navigation/BottomNavigation.dart';
import 'package:app_1helo/pages/AccoutPage.dart';
import 'package:app_1helo/pages/Changepassword.dart';
import 'package:app_1helo/pages/ChatBox.dart';
import 'package:app_1helo/pages/PayPage.dart';
import 'package:app_1helo/pages/customerPage.dart';
import 'package:app_1helo/pages/DSHoSoCO.dart';
import 'package:app_1helo/navigation/Drawer.dart';
import 'package:app_1helo/pages/funtionsPage.dart';
import 'package:app_1helo/pages/PersonalInfo.dart';
import 'package:app_1helo/pages/home_page.dart';
import 'package:app_1helo/pages/materialResportPage.dart';
import 'package:app_1helo/pages/materialsPage.dart';
import 'package:app_1helo/pages/productPage.dart';
import 'package:app_1helo/pages/productReportPage.dart';
import 'package:app_1helo/pages/staffPage.dart';
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
  String _appBarTitle = "BÁO CÁO HOẠT ĐỘNG NEXTCO";
  int _currenIndex = 0;

  void _changeCurrentIndex(int index) {
    setState(() {
      _currenIndex = index;
      _updateAppBarTitle(index);
    });
  }

  void _updateAppBarTitle(int index) {
    switch (index) {
      case 0:
        _appBarTitle = "BÁO CÁO HOẠT ĐỘNG NEXTCO";
        break;
      case 1:
        _appBarTitle = "CHỨC NĂNG NEXT NEXTCO";
        break;
      case 2:
        _appBarTitle = "CÁ NHÂN";
        break;
      case 3:
        _appBarTitle = "DANH SÁCH HỒ SƠ NEXTCO";
        break;
      case 4:
        _appBarTitle = "THÔNG TIN CÁ NHÂN";
        break;
      case 5:
        _appBarTitle = "ĐỔI MẬT KHẨU";
        break;
      case 6:
        _appBarTitle = "QUẢN LÝ NGƯỜI DÙNG";
        break;
      case 7:
        _appBarTitle = "DANH SÁCH SẢN PHẨM";
        break;
      case 8:
        _appBarTitle = "QUẢN LÝ NGUYÊN VẬT LIỆU";
        break;
      case 9:
        _appBarTitle = "DANH SÁCH KHÁCH HÀNG";
        break;
      case 10:
        _appBarTitle = "THÔNG TIN SỬ DỤNG PHẦN MỀM";
        break;
      case 11:
        _appBarTitle = "THÔNG TIN THANH TOÁN";
        break;
      case 12:
        _appBarTitle = "BÁO CÁO TỒN SẢN PHẨM ";
        break;
      case 13:
        _appBarTitle = "BÁO CÁO TỒN NGUYÊN VẬT LIỆU ";
        break;
      default:
        _appBarTitle = "BÁO CÁO HOẠT ĐỘNG NEXTCO";
    }
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage(onSelectPage: _changeCurrentIndex);
      case 1:
        return NotificationPage(onSelectPage: _changeCurrentIndex);
      case 2:
        return AcountPage(onSelectPage: _changeCurrentIndex);
      case 3:
        return const Dshosoco();
      case 4:
        return PersonalInfo(onSelectPage: _changeCurrentIndex);
      case 5:
        return Changepassword(onSelectPage: _changeCurrentIndex);
      case 6:
        return const Staffpage();
      case 7:
        return const ProductPage();
      case 8:
        return const Materialspage();
      case 9:
        return const Clientpage();
      case 10:
        return Columncharpage(onSelectPage: _changeCurrentIndex);
      case 11:
        return Paypage(onSelectPage: _changeCurrentIndex);
      case 12:
        return const Productreportpage();
      case 13:
        return Materialresportpage(onSelectPage: _changeCurrentIndex);
      default:
        return HomePage(onSelectPage: _changeCurrentIndex);
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
    return Scaffold(
      drawer: DrawerCustom(onSelectPage: _changeCurrentIndex),
      appBar: AppBar(
        title: Text(
          _appBarTitle,
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              fontSize: 16,
              color: Color(0xfff064265),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  const PopupMenuItem(
                    value: 'all',
                    child: Text('Tất cả'),
                  ),
                  const PopupMenuItem(
                    value: 'unread',
                    child: Text('Chưa đọc'),
                  ),
                ],
              ).then((value) {
                if (value == 'all') {
                } else if (value == 'unread') {}
              });
            },
            icon: const Icon(Icons.notifications_none_outlined, size: 24),
            color: const Color(0xFF064265),
          ),
        ],
        iconTheme: const IconThemeData(
          color: Color(0xFF064265),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _getPage(_currenIndex),
      bottomNavigationBar: BottomNavigation(
        changCurrentIndex: _changeCurrentIndex,
      ),
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
                    print('Button 3 Pressed');
                  },
                  tooltip: 'Button 3',
                  backgroundColor:
                      Provider.of<Providercolor>(context).selectedColor,
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
                  backgroundColor:
                      Provider.of<Providercolor>(context).selectedColor,
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
                  backgroundColor:
                      Provider.of<Providercolor>(context).selectedColor,
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
              backgroundColor:
                  Provider.of<Providercolor>(context).selectedColor,
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
