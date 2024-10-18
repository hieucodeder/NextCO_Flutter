import 'package:flutter/material.dart';

class Logologin extends StatefulWidget {
  const Logologin({super.key});

  @override
  State<Logologin> createState() => _LogologinState();
}

class _LogologinState extends State<Logologin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            color: Colors.white,
          ),
          Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  width: double.infinity,
                  height: 300,
                  color: Colors.white24,
                  child: const Column(
                    children: [
                      Image(
                        image: AssetImage('resources/logo_co.png'),
                        width: 200,
                      ),
                      Text(
                        'ĐĂNG NHẬP',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 28),
                      ),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
