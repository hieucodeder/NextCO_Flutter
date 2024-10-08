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
        color: Colors.white,
        child: Container(
          constraints: const BoxConstraints.expand(),
          margin: const EdgeInsets.only(top: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 3),
                child: SvgPicture.asset('resources/Layer_1.svg'),
              ),
              const SizedBox(
                height: 10,
              ),
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 3),
                child: Text(
                  'Phần mềm quản lý chứng nhận xuất xứ hàng hóa',
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff064265)),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                margin: const EdgeInsets.only(top: 160),
                child: Stack(
                  children: [
                    Positioned(
                      child: Image.asset(
                        'resources/bgr1.png',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 400,
                      ),
                    ),
                    Positioned(
                      child: Image.asset(
                        'resources/bgr2.png',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 400,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
