import 'package:app_1helo/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  void _forgotPassword() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
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
      resizeToAvoidBottomInset: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
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
            margin: const EdgeInsets.symmetric(vertical: 80),
            child: Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset('resources/logonextco.svg',
                  width: 100, height: 46),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            constraints: const BoxConstraints.expand(),
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 200,
                  ),
                  Text(
                    'QUÊN MẬT KHẨU',
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.w700,
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
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF064265),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    child: Column(
                      children: [
                        SizedBox(
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
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Vui lòng nhập tài khoản';
                                        }
                                        return null;
                                      },
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color.fromARGB(
                                              237, 250, 248, 248),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          hintText: 'Tài khoản',
                                          hintStyle:
                                              GoogleFonts.robotoCondensed(
                                            fontSize: 14,
                                            color: const Color(0xFF064265),
                                          ),
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
                        SizedBox(
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 42,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập tài khoản';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(color: Colors.black),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          237, 250, 248, 248),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      hintText: 'Email',
                                      hintStyle: GoogleFonts.robotoCondensed(
                                        fontSize: 14,
                                        color: const Color(0xFF064265),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
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
                            onPressed: () {},
                            child: SizedBox(
                              height: 30,
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
