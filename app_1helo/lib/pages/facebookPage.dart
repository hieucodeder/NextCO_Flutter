import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FacebookPage extends StatefulWidget {
  const FacebookPage({super.key});

  @override
  State<FacebookPage> createState() => _FacebookPageState();
}

class _FacebookPageState extends State<FacebookPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint("Loading progress: $progress%");
          },
          onPageStarted: (String url) {
            debugPrint("Page started loading: $url");
          },
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Resource error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint("Blocked navigation to: ${request.url}");
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.facebook.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook Page'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
