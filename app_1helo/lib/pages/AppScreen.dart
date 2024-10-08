import 'package:app_1helo/pages/Accout.dart';
import 'package:app_1helo/navigation/BottomNavigation.dart';
import 'package:app_1helo/pages/Changepassword.dart';
import 'package:app_1helo/pages/customerPage.dart';
import 'package:app_1helo/pages/DSHoSoCO.dart';
import 'package:app_1helo/navigation/Drawer.dart';
import 'package:app_1helo/pages/Notification.dart';
import 'package:app_1helo/pages/PersonalInfo.dart';
import 'package:app_1helo/pages/home_page.dart';
import 'package:app_1helo/pages/materialsPage.dart';
import 'package:app_1helo/pages/productPage.dart';
import 'package:app_1helo/pages/staffPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  String _appBarTitle = "BÁO CÁO HOẠT ĐỘNG TẠO HỒ SƠ C/O";
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
        _appBarTitle = "BÁO CÁO HOẠT ĐỘNG TẠO HỒ SƠ C/O";
        break;
      case 1:
        _appBarTitle = "THÔNG BÁO";
        break;
      case 2:
        _appBarTitle = "TÀI KHOẢN";
        break;
      case 3:
        _appBarTitle = "DANH SÁCH HỒ SƠ C/O";
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
      default:
        _appBarTitle = "BÁO CÁO HOẠT ĐỘNG TẠO HỒ SƠ C/O";
    }
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage(onSelectPage: _changeCurrentIndex);
      case 1:
        return const NotificationPage();
      case 2:
        return AcountPage(onSelectPage: _changeCurrentIndex);
      case 3:
        return const Dshosoco();
      case 4:
        return PersonalInfo(onSelectPage: _changeCurrentIndex);
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
      default:
        return HomePage(onSelectPage: _changeCurrentIndex);
    }
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
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
    );
  }
}
