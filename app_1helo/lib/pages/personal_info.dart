import 'package:app_1helo/model/account.dart';
import 'package:app_1helo/provider/navigationProvider.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:app_1helo/service/authservice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final AuthService _authService = AuthService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController foneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  int? gender;

  @override
  void initState() {
    super.initState();
    _fetchAccountInfo();
  }

  Future<void> _fetchAccountInfo() async {
    Account? account = await _authService.getAccountInfo();

    if (account != null && mounted) {
      nameController.text = account.fullName ?? '';
      accountController.text = account.userName ?? '';
      // Định dạng ngày sinh sang DateTime
      if (account.dateOfBirth != null && account.dateOfBirth!.isNotEmpty) {
        DateTime parsedDate = DateTime.parse(account.dateOfBirth!);
        String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
        dateController.text = formattedDate;
      } else {
        dateController.text = '';
      }
      emailController.text = account.email ?? '';
      foneController.text = account.phoneNumber ?? '';
      descriptionController.text = account.firstName ?? '';

      setState(() {
        gender = account.gender;
      });
    } else {}
  }

  final colorsRed = GoogleFonts.robotoCondensed(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  final _text = GoogleFonts.robotoCondensed(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final localization = AppLocalizations.of(context);

    return Container(
      constraints: const BoxConstraints.expand(),
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
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
                    Text(
                      localization?.translate('full_name') ?? 'Họ và tên',
                      style: _text,
                    )
                  ],
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), hintStyle: _text),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
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
                    Text(
                      localization?.translate('account') ?? 'Tài khoản',
                      style: _text,
                    )
                  ],
                ),
                TextField(
                  controller: accountController,
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), hintStyle: _text),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
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
                    Text(
                      localization?.translate('date_of_birth') ?? 'Ngày sinh',
                      style: _text,
                    )
                  ],
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), hintStyle: _text),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
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
                    Text(
                      localization?.translate('gender') ?? 'Giới tính',
                      style: _text,
                    )
                  ],
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), hintStyle: _text),
                  value: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 0, // Nam
                      child: Text(
                        'Nữ',
                        style: _text,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 1, // Nữ
                      child: Text(
                        'Nam',
                        style: _text,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
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
                    Text(
                      'Email',
                      style: _text,
                    )
                  ],
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), hintStyle: _text),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
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
                    Text(
                      localization?.translate('phone_number') ??
                          'Số điện thoại',
                      style: _text,
                    )
                  ],
                ),
                TextField(
                  controller: foneController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), hintStyle: _text),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              localization?.translate('describe') ?? 'Mô tả',
              style: _text,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), hintStyle: _text),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
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
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor:
                //         Provider.of<Providercolor>(context).selectedColor,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         side: BorderSide.none),
                //   ),
                //   child: Text(
                //     'Lưu',
                //     style: GoogleFonts.robotoCondensed(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
