import 'package:app_1helo/model/bodylogin.dart';
import 'package:app_1helo/pages/AppScreen.dart';
import 'package:app_1helo/pages/ForgotPassword.dart';
import 'package:app_1helo/service/api_config.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // List of domains
  final List<String> _domains = [
    "https://demo.nextco.vn",
    "test-api.example.com",
    "dev-api.example.com",
  ];

  @override
  void initState() {
    super.initState();
    _loadDomain();
  }

  String? _domain;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;

// Future<void> _login() async {
//   final phone = _usernameController.text.trim();
//   final password = _passwordController.text.trim();

//   if (phone.isEmpty || password.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
//     );
//     return;
//   }

//   try {
//     // Kiểm tra thông tin người dùng trong database
//     final user = await DatabaseHelper.instance.getUserByPhone(phone);
//     print("User data: $user"); // Log dữ liệu để kiểm tra

//     if (user != null && user['password'] == password) {
//       final String? domain = user['domain'];
//       if (domain != null && domain.isNotEmpty) {
//         setState(() {
//           _domain = domain;
//         });
//         ApiConfig.domain = domain; // Gán giá trị domain
//         print("Domain set in ApiConfig: ${ApiConfig.domain}");
//       } else {
//         print("Domain is null or empty for user: $phone");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Domain không hợp lệ")),
//         );
//         return;
//       }

//       // Hiển thị thông báo đăng nhập thành công
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Đăng nhập thành công!")),
//       );

//       // Chuyển sang màn hình chính
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()), // Thay đổi LoginPage thành HomePage nếu cần
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Số điện thoại hoặc mật khẩu không đúng")),
//       );
//     }
//   } catch (error) {
//     print("Error during login: $error"); // Log lỗi để kiểm tra
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Có lỗi xảy ra. Vui lòng thử lại!")),
//     );
//   }
// }

  // Load the domain from SharedPreferences
  _loadDomain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _domain = prefs.getString('selectedDomain') ??
          _domains[0]; // Set the default if no domain is saved
      if (!_domains.contains(_domain)) {
        _domain = _domains[0]; // Ensure the domain is valid
      }
      ApiConfig.domain = _domain; // Set domain for ApiConfig
    });
  }

  // Save selected domain to SharedPreferences
  _saveDomain(String? domain) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedDomain', domain ?? _domains[0]);
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang xử lý dữ liệu...')),
      );

      final String username = _usernameController.text.trim();
      final String password = _passwordController.text.trim();

      //   // Lấy domain từ ApiConfig
      //   print("Using domain: ${ApiConfig.domain}");
      // String domain = await fetchDomainForUsername(username);
      // print("Using domain: $domain");
      final Bodylogin loginData =
          Bodylogin(username: username, password: password);

      try {
        Map<String, dynamic>? response = await _authService.login(loginData);

        if (response != null) {
          showLoginSnackbar(context);
        } else {
          setState(() {});
          showLoginErrorSnackbar(context);
        }
      } catch (error) {
        setState(() {});
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
        resizeToAvoidBottomInset: true,
        body: Container(
            constraints: const BoxConstraints.expand(),
            color: Colors.white,
            child: Form(
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 70),
                        Text(
                          'ĐĂNG NHẬP',
                          style: GoogleFonts.robotoCondensed(
                            fontWeight: FontWeight.w700,
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
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF064265),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DropdownButton<String>(
                                hint: const Text("Select a domain"),
                                value: _domain,
                                items: _domains.map((domain) {
                                  return DropdownMenuItem<String>(
                                    value: domain,
                                    child: Text(domain),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _domain = value;
                                    _saveDomain(value);
                                    ApiConfig.domain = value;
                                  });
                                },
                              ),
                            ]),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width),
                          height: 200,
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
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          237, 250, 248, 248),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      hintText: 'Tài khoản',
                                      hintStyle: GoogleFonts.robotoCondensed(
                                          fontSize: 14,
                                          color: const Color(0xFF064265)),
                                      prefixIcon: const Icon(
                                        Icons.account_box_outlined,
                                        size: 24,
                                        color: Color(0xFF064265),
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                fontSize: 14,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Vui lòng nhập mật khẩu';
                                              }
                                              return null;
                                            },
                                            style: const TextStyle(
                                                color: Colors.black),
                                            controller: _passwordController,
                                            obscureText: !_isPasswordVisible,
                                            decoration: InputDecoration(
                                              hintText: 'Mật khẩu',
                                              hintStyle:
                                                  GoogleFonts.robotoCondensed(
                                                fontSize: 14,
                                                color: const Color(0xFF064265),
                                              ),
                                              filled: true,
                                              fillColor: const Color.fromARGB(
                                                  237, 250, 248, 248),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              prefixIcon: const Icon(
                                                Icons.lock_outline,
                                                size: 24,
                                                color: Color(0xFF064265),
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _isPasswordVisible
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color: const Color.fromARGB(
                                                      236, 85, 80, 80),
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
                                                      horizontal: 12),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 1.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 1.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
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
                                    child: Icon(
                                        Icons.keyboard_double_arrow_right)),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Đăng nhập',
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 230,
                            ),
                            SizedBox(
                              width: 130,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: _forgotPassword,
                                    child: Text(
                                      'Quên mật khẩu?',
                                      style: GoogleFonts.robotoCondensed(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF064265),
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              const Color(0xFF064265)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            )));
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
