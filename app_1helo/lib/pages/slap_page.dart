import 'package:app_1helo/login/login_page.dart';
import 'package:flutter/material.dart';

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
            children: [
              Center(
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(seconds: 3),
                  child: Image.asset('resources/logo_slap.png'),
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
