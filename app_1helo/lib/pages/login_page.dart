import 'package:app_1helo/model/acount.dart';
import 'package:app_1helo/model/bodylogin.dart';
import 'package:app_1helo/model/user.dart';
import 'package:app_1helo/pages/Accout.dart';
import 'package:app_1helo/navigation/AppScreen.dart';
import 'package:app_1helo/pages/ForgotPassword.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  final AuthService _authService = AuthService();

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final Bodylogin loginData =
        Bodylogin(username: username, password: password);

    Map<String, dynamic>? response = await _authService.login(loginData);

    if (response != null) {
      // Acount account = response['account'];
      // String token = response['token'];
      showLoginSnackbar(context);
    } else {
      setState(() {
        _errorMessage = 'Login failed. Please try again.';
      });
      print('Login failed');
      showLoginErrorSnackbar(context);
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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(alignment: Alignment.center, children: [
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
          Container(
            padding: const EdgeInsets.only(top: 100),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'resources/logo_login.png',
                width: 61,
                height: 38,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 50),
                  Text(
                    'ĐĂNG NHẬP',
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF064265),
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Đăng nhập để tiếp tục',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF064265),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: (MediaQuery.of(context).size.width),
                    height: 178,
                    child: Container(
                      width: (MediaQuery.of(context).size.width),
                      height: 62,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Tài khoản',
                                style: GoogleFonts.robotoCondensed(
                                    fontSize: 14,
                                    color: const Color(0xFF064265),
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '*',
                                style: GoogleFonts.robotoCondensed(
                                    fontSize: 14,
                                    color: const Color(0xffF5222D),
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                child: TextField(
                                  style: const TextStyle(color: Colors.black),
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                      hintText: 'nextco',
                                      hintStyle: GoogleFonts.robotoCondensed(
                                          fontSize: 14,
                                          color: const Color(0xFF064265)),
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(
                                        Icons.account_circle_outlined,
                                        size: 24,
                                        color: const Color(0xFF064265),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Mật khẩu',
                                        style: GoogleFonts.robotoCondensed(
                                            fontSize: 14,
                                            color: const Color(0xFF064265)),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '*',
                                        style: GoogleFonts.robotoCondensed(
                                            fontSize: 14, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: TextField(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          controller: _passwordController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                              hintText: '******',
                                              hintStyle:
                                                  GoogleFonts.robotoCondensed(
                                                      fontSize: 14,
                                                      color: const Color(
                                                          0xFF064265)),
                                              border:
                                                  const OutlineInputBorder(),
                                              prefixIcon: const Icon(
                                                Icons.lock,
                                                size: 24,
                                                color: const Color(0xFF064265),
                                              )),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        margin:
                                            const EdgeInsets.only(right: 252),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            TextButton(
                                              onPressed: _forgotPassword,
                                              child: Text(
                                                'Quên mật khẩu',
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xFF064265),
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            const Color(
                                                                0xFF064265)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
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
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

void showLoginErrorSnackbar(BuildContext context) {
  final snackBar = SnackBar(
    backgroundColor: Colors.white,
    content: Text(
      'Sai tài khoản hoặc mật khẩu.',
      style: GoogleFonts.robotoCondensed(color: Colors.black),
    ),
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: 'Đóng',
      textColor: Colors.black,
      onPressed: () {},
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showLoginSnackbar(BuildContext context) {
  var snackBar = SnackBar(
    backgroundColor: Colors.white,
    content: Text(
      'Đăng nhập thành công. Đang chuyển hướng....',
      style: GoogleFonts.robotoCondensed(color: Colors.black),
    ),
    duration: const Duration(seconds: 1),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  Future.delayed(const Duration(seconds: 1), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AppScreen()),
    );
  });
}
