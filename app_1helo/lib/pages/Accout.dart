import 'package:app_1helo/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AcountPage extends StatefulWidget {
  final Function(int) onSelectPage;

  const AcountPage({super.key, required this.onSelectPage});

  @override
  State<AcountPage> createState() => _AcountPageState();
}

class _AcountPageState extends State<AcountPage> {
  final styleText = GoogleFonts.robotoCondensed(fontSize: 16);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_box_sharp,
                size: 24,
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  widget.onSelectPage(4);
                },
                child: Text('Thông tin cá nhân', style: styleText),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(
                Icons.lock_outline,
                size: 24,
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  widget.onSelectPage(5);
                },
                child: Text('Đổi mật khẩu', style: styleText),
              ),
            ],
          ),
          const Divider(color: Colors.black),
          Row(
            children: [
              const Icon(Icons.logout, size: 24),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                  onPressed: () {
                    _showAlertDialog(context);
                  },
                  child: Text('Đăng xuất', style: styleText))
            ],
          )
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue),
                child: const Center(
                  child: Text(
                    'Thông báo!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                )),
            content: const Text('Bạn có muốn đăng xuất tài khoản không?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text('Xác nhận'))
            ],
          );
        });
  }
}
