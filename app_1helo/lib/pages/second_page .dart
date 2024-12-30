// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  final String domain;

  // Constructor to accept domain value
  const SecondPage({super.key, required this.domain});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    // Access domain using widget.domain
    final domain = widget.domain;

    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: Text('Domain: $domain'),
      ),
    );
  }
}
