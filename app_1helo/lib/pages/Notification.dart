import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Body'),
        Center(
          child: Lottie.network(
              'https://lottie.host/19e2d0ec-02e5-411b-8185-0b4d8d9e2b14/FFKlAoxudo.json'),
        ),
      ],
    );
  }
}
