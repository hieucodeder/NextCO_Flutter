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
                      // TextField(
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     backgroundColor: Colors.white,
                      //   ),
                      //   controller: _usernameController,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Tài khoản',
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                      // TextField(
                      //   style: const TextStyle(color: Colors.white),
                      //   controller: _usernameController,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Mật khẩu',
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
