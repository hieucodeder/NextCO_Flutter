import 'package:app_1helo/pages/slap_page.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Providercolor()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App CO',
      theme: ThemeData(
        primaryColor: Provider.of<Providercolor>(context).selectedColor,
      ),
      debugShowCheckedModeBanner: false,
      home: const SlapPage(),
    );
  }
}
