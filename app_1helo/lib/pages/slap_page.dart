import 'package:app_1helo/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SlapPage extends StatefulWidget {
  const SlapPage({super.key});

  @override
  State<SlapPage> createState() => _SlapPageState();
}

class _SlapPageState extends State<SlapPage> with TickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 3),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'resources/bgr1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Image.asset(
                          'resources/bgr2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              margin: const EdgeInsets.symmetric(vertical: 160),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(seconds: 3),
                    child: SvgPicture.asset(
                      'resources/logonextco.svg',
                      fit: BoxFit.contain,
                      width: 180,
                      height: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(seconds: 3),
                    child: Text(
                      'Phần mềm quản lý chứng nhận xuất xứ hàng hóa',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff064265),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
