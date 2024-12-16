import 'package:app_1helo/SQLite/database_helper.dart';
import 'package:app_1helo/pages/home_page.dart';
import 'package:app_1helo/pages/login_page.dart';
import 'package:app_1helo/service/api_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Loginpagedomain extends StatefulWidget {
  const Loginpagedomain({super.key});

  @override
  _LoginpagedomainState createState() => _LoginpagedomainState();
}

class _LoginpagedomainState extends State<Loginpagedomain> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _domain;

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang xử lý dữ liệu...')),
      );
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      if (phone.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
        );
        return;
      }

      final user = await DatabaseHelper.instance.getUserByPhone(phone);
      print(user);
      if (user != null && user['password'] == password) {
        final String? domain = user['domain'];
        if (domain != null) {
          setState(() {
            _domain = domain;
          });
          ApiConfig.domain = domain;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('domain', domain);

          print("Domain set in ApiConfig: ${ApiConfig.domain}");
        } else {
          print("Domain is null for user: $phone");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Đăng nhập dữ liệu khách hàng thành công!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Số điện thoại hoặc mật khẩu không đúng")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 650,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 650,
                          child: Image.asset(
                            'resources/bgr1.png',
                            fit: BoxFit.cover,
                          )),
                      Positioned(
                        left: 0,
                        right: -270,
                        top: 10,
                        height: 650,
                        child: Image.asset(
                          'resources/bgr2.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 80),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset('resources/logonextco.svg',
                      width: 80, height: 46),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                constraints: const BoxConstraints.expand(),
                margin: const EdgeInsets.fromLTRB(0, 130, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ĐĂNG NHẬP DỮ LIỆU KHÁCH HÀNG',
                      style: GoogleFonts.robotoCondensed(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF064265),
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Vui lòng nhập số điện thoại và mật khẩu ',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF064265),
                      ),
                    ),
                    Text(
                      'để lấy dữ liệu khách hàng',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF064265),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Số điện thoại',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Mật khẩu
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mật khẩu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Nút Đăng nhập
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF064265),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(8),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 9, 105, 160),
                          ),
                        ),
                        onPressed: _login,
                        child: Row(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.keyboard_double_arrow_right)),
                            const Spacer(),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Đăng nhập',
                                style: GoogleFonts.robotoCondensed(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const Spacer()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
