import 'package:app_1helo/model/bodylogin.dart';
import 'package:app_1helo/pages/AppScreen.dart';
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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang xử lý dữ liệu...')),
      );

      final String username = _usernameController.text.trim();
      final String password = _passwordController.text.trim();

      final Bodylogin loginData =
          Bodylogin(username: username, password: password);

      try {
        Map<String, dynamic>? response = await _authService.login(loginData);

        if (response != null) {
          showLoginSnackbar(context);
        } else {
          setState(() {
            _errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại.';
          });
          showLoginErrorSnackbar(context);
        }
      } catch (error) {
        setState(() {
          _errorMessage = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
        });
        showLoginErrorSnackbar(context);
      }
    } else {
      showValidationErrorSnackbar(context, 'Vui lòng điền đầy đủ thông tin.');
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
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Stack(fit: StackFit.expand, children: [
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
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: -270,
                    top: 10,
                    height: 650,
                    child: Image.asset(
                      'resources/bgr2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 50),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'resources/logonextco.png',
                width: 150,
                height: 70,
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
                  const SizedBox(height: 70),
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
                  SizedBox(
                    width: (MediaQuery.of(context).size.width),
                    height: 250,
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
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập tài khoản';
                                }
                                return null;
                              },
                              style: const TextStyle(color: Colors.black),
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: 'Tài khoản',
                                hintStyle: GoogleFonts.robotoCondensed(
                                    fontSize: 14,
                                    color: const Color(0xFF064265)),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(
                                  Icons.account_box_outlined,
                                  size: 24,
                                  color: const Color(0xFF064265),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
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
                                    TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Vui lòng nhập mật khẩu';
                                        }
                                        return null;
                                      },
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: _passwordController,
                                      obscureText: !_isPasswordVisible,
                                      decoration: InputDecoration(
                                        hintText: 'Mật khẩu',
                                        hintStyle: GoogleFonts.robotoCondensed(
                                          fontSize: 14,
                                          color: const Color(0xFF064265),
                                        ),
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                          size: 24,
                                          color: Color(0xFF064265),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: const Color(0xFFDFE2E2),
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          },
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 12),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
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
                                                      decoration: TextDecoration
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: Expanded(
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

// Thông báo check thông tin tài khoản, mật khẩu
void showValidationErrorSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    backgroundColor: Colors.white,
    content: Text(
      message,
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
