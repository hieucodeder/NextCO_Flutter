import 'package:app_1helo/pages/login_page.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AcountPage extends StatefulWidget {
  final Function(int) onSelectPage;

  const AcountPage({super.key, required this.onSelectPage});

  @override
  State<AcountPage> createState() => _AcountPageState();
}

class _AcountPageState extends State<AcountPage> {
  final styleText =
      GoogleFonts.robotoCondensed(fontSize: 16, color: Colors.black);
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
                Icons.account_box_outlined,
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
                Icons.search_outlined,
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
              const Icon(Icons.logout_outlined, size: 24),
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
                // margin: const EdgeInssets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Provider.of<Providercolor>(context).selectedColor),
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
              Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                        width: 1,
                        color:
                            Provider.of<Providercolor>(context).selectedColor)),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Hủy',
                      style: TextStyle(
                          color: Provider.of<Providercolor>(context)
                              .selectedColor),
                    )),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Provider.of<Providercolor>(context).selectedColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide.none),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }
}