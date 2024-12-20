import 'package:app_1helo/provider/navigationProvider.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  final TextStyle colorsRed = const TextStyle(color: Colors.red, fontSize: 16);
  @override
  Widget build(BuildContext context) {
        final navigationProvider = Provider.of<NavigationProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '*',
                      style: colorsRed,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('Mật khẩu hiện tại')
                  ],
                ),
                const TextField(
                  decoration: InputDecoration(
                      hintText: 'Mật khẩu hiện tại',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.remove_red_eye_outlined)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '*',
                      style: colorsRed,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('Mật khẩu mới')
                  ],
                ),
                const TextField(
                  decoration: InputDecoration(
                      hintText: 'Mật khẩu mới',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.remove_red_eye_outlined)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '*',
                      style: colorsRed,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('Xác nhận mật khẩu mới')
                  ],
                ),
                const TextField(
                  decoration: InputDecoration(
                      hintText: 'Xác nhận mật khẩu mới',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.remove_red_eye_outlined)),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 2,
                        color:
                            Provider.of<Providercolor>(context).selectedColor),
                  ),
                  child: TextButton(
                    onPressed: () {
                      navigationProvider.setCurrentIndex(2);
                    },
                    child: Text(
                      'Quay lại',
                      style: GoogleFonts.robotoCondensed(
                          color: Provider.of<Providercolor>(context)
                              .selectedColor),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Provider.of<Providercolor>(context).selectedColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide.none),
                  ),
                  child: Text(
                    'Lưu',
                    style: GoogleFonts.robotoCondensed(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
