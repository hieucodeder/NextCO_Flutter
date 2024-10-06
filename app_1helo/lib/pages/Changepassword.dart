import 'package:flutter/material.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: const TextField(
            decoration: InputDecoration(
                label: Text('Nhập tài khoản'), border: OutlineInputBorder()),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: const TextField(
            decoration: InputDecoration(
                label: Text('Nhập mật khẩu hiện tại'),
                border: OutlineInputBorder()),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: const TextField(
            decoration: InputDecoration(
                label: Text('Nhập mật khẩu mới'), border: OutlineInputBorder()),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 130),
          child: Row(
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Hủy'),
              ),
              TextButton(onPressed: () {}, child: Text('Lưu'))
            ],
          ),
        )
      ],
    );
  }
}
