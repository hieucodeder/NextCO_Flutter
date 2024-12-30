import 'package:app_1helo/pages/login_page.dart';
import 'package:app_1helo/provider/locale_provider.dart';
import 'package:app_1helo/provider/navigationProvider.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AcountPage extends StatefulWidget {
  const AcountPage({super.key});

  @override
  State<AcountPage> createState() => _AcountPageState();
}

class _AcountPageState extends State<AcountPage> {
  final styleText = GoogleFonts.robotoCondensed(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
  final List<Map<String, dynamic>> languages = [
    {'locale': const Locale('vi'), 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
    {'locale': const Locale('en'), 'name': 'English', 'flag': '🇺🇸'},
  ];
  Locale? selectedLocale;
  @override
  void initState() {
    super.initState();
    selectedLocale = languages.first['locale']; // Đặt mặc định
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final localization = AppLocalizations.of(context);

        return AlertDialog(
          title: Text(
              localization?.translate('select_language') ?? 'Chọn ngôn ngữ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              return ListTile(
                leading: Text(
                  language['flag'],
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(language['name']),
                onTap: () {
                  setState(() {
                    selectedLocale = language['locale'];
                  });
                  // Thay đổi ngôn ngữ toàn ứng dụng
                  context.read<LocaleProvider>().setLocale(language['locale']);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final localization = AppLocalizations.of(context);
    final currentLocale = context.watch<LocaleProvider>().locale;
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_box,
                size: 24,
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  navigationProvider.setCurrentIndex(4);
                },
                child: Text(
                    localization?.translate('personal_infoac') ??
                        'Thông tin cá nhân',
                    style: styleText),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.search,
                size: 24,
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  navigationProvider.setCurrentIndex(5);
                },
                child: Text(
                    localization?.translate('change_passwordac') ??
                        'Đổi mật khẩu',
                    style: styleText),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.language,
                size: 24,
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: _showLanguageDialog,
                child: Row(
                  children: [
                    Text(
                      localization?.translate('languege') ?? "Ngôn ngữ: ",
                      style: styleText,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      languages.firstWhere(
                        (language) => language['locale'] == currentLocale,
                        orElse: () => languages.first,
                      )['name'],
                      style: styleText,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.black),
          Row(
            children: [
              const Icon(Icons.logout_outlined, size: 24),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                  onPressed: () {
                    _showAlertDialog(context);
                  },
                  child: Text(localization?.translate('log_out') ?? 'Đăng xuất',
                      style: styleText))
            ],
          )
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    final localization = AppLocalizations.of(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
                // margin: const EdgeInssets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Provider.of<Providercolor>(context).selectedColor),
                child: Center(
                  child: Text(
                    localization?.translate('notification') ?? 'Thông báo!',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                )),
            content: Text(localization?.translate('question') ??
                'Bạn có muốn đăng xuất tài khoản không?'),
            actions: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                        width: 1,
                        color:
                            Provider.of<Providercolor>(context).selectedColor)),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      localization?.translate('cancle') ?? 'Hủy',
                      style: TextStyle(
                          color: Provider.of<Providercolor>(context)
                              .selectedColor),
                    )),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Provider.of<Providercolor>(context).selectedColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide.none),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text(
                    localization?.translate('confirm') ?? 'Xác nhận',
                    style: const TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }
}
