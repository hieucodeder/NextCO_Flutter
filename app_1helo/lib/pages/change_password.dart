import 'package:app_1helo/provider/navigation_provider.dart';
import 'package:app_1helo/provider/provider_color.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
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
    final localization = AppLocalizations.of(context);

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
                    Text(localization?.translate('current_password') ??
                        'Mật khẩu hiện tại')
                  ],
                ),
                const TextField(
                  decoration: InputDecoration(
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
                    Text(localization?.translate('new_password') ??
                        'Mật khẩu mới')
                  ],
                ),
                const TextField(
                  decoration: InputDecoration(
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
                    Text(localization?.translate('confirm_new_password') ??
                        'Xác nhận mật khẩu mới')
                  ],
                ),
                const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.remove_red_eye_outlined)),
                ),
              ],
            ),
          ),
          SizedBox(
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
                      localization?.translate('back') ?? 'Quay lại',
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
                    localization?.translate('save') ?? 'Lưu',
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
