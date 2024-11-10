import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Chatbox extends StatefulWidget {
  const Chatbox({super.key});

  @override
  State<Chatbox> createState() => _ChatboxState();
}

class _ChatboxState extends State<Chatbox> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse(
          'https://smartchat.aiacademy.edu.vn/chatbot-embed.js?chatbotCode=08b76cc3-ab34-4bd9-9e82-6577d47387a8'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbox'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
