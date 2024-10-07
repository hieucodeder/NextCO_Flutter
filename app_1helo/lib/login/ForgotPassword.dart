import 'package:app_1helo/navigation/AppScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      print('Logging in with username: $username and password: $password');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
    }
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Forgotpassword()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          '',
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          Positioned.fill(
            child: Image.asset(
              'resources/bgr1_login.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'resources/bgr2_login.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 90),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 5),
                  Center(
                    child: Image.asset(
                      'resources/logo_login.png',
                      width: 61,
                      height: 38,
                    ),
                  ),
                  const SizedBox(height: 100),
                  Text(
                    'QUÊN MẬT KHẨU',
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF064265),
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Vui lòng nhập tài khoản và email để lấy lại mật khẩu',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF064265),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 61,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tài khoản',
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 14,
                                      color: const Color(0xFF064265),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '*',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    child: TextField(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                          hintText: 'Tài khoản',
                                          hintStyle:
                                              GoogleFonts.robotoCondensed(
                                            fontSize: 14,
                                            color: const Color(0xFF064265),
                                          ),
                                          border: const OutlineInputBorder(),
                                          prefixIcon: const Icon(
                                            Icons.account_circle_outlined,
                                            size: 24,
                                            color: const Color(0xFF064265),
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 62,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Email',
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 14,
                                      color: const Color(0xFF064265),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '*',
                                    style: GoogleFonts.robotoCondensed(
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                child: TextField(
                                  style: const TextStyle(color: Colors.black),
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: GoogleFonts.robotoCondensed(
                                        fontSize: 14,
                                        color: const Color(0xFF064265),
                                      ),
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        size: 24,
                                        color: const Color(0xFF064265),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: _forgotPassword,
                              child: Text(
                                'Đã nhớ ra mật khẩu?',
                                style: GoogleFonts.robotoCondensed(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF064265),
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(0xFF064265)),
                              ),
                            ),
                            TextButton(
                              onPressed: _forgotPassword,
                              child: Text(
                                'Đăng nhập ngay',
                                style: GoogleFonts.robotoCondensed(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF064265),
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(0xFF064265)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          margin: const EdgeInsetsDirectional.symmetric(
                              horizontal: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF064265),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(16),
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
                                    child: Icon(Icons
                                        .keyboard_double_arrow_right_outlined)),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Gửi',
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
