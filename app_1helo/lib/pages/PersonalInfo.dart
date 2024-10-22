import 'package:app_1helo/model/account.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  final Function(int) onSelectPage;
  const PersonalInfo({super.key, required this.onSelectPage});

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

    if (account != null) {
      nameController.text = account.fullName ?? '';
      accountController.text = account.userName ?? '';
      // Định dạng ngày sinh sang DateTime
      if (account.dateOfBirth != null && account.dateOfBirth!.isNotEmpty) {
        DateTime parsedDate = DateTime.parse(account.dateOfBirth!);
        String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
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
    } else {
      print('Không lấy được thông tin tài khoản');
    }
  }

  final TextStyle colorsRed = const TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      margin: const EdgeInsets.all(10),
      child: Expanded(
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
                      const Text('Họ và tên')
                    ],
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Họ và tên',
                      border: OutlineInputBorder(),
                    ),
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
                      const Text('Tài khoản')
                    ],
                  ),
                  TextField(
                    controller: accountController,
                    readOnly: true,
                    enabled: false,
                    decoration: const InputDecoration(
                      hintText: 'Tài khoản',
                      border: OutlineInputBorder(),
                    ),
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
                      const Text('Ngày sinh')
                    ],
                  ),
                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      hintText: 'Ngày sinh',
                      border: OutlineInputBorder(),
                    ),
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
                      const Text('Giới tính')
                    ],
                  ),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      hintText: 'Giới tính',
                      border: OutlineInputBorder(),
                    ),
                    value: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 0, // Nam
                        child: Text('Nữ'),
                      ),
                      DropdownMenuItem(
                        value: 1, // Nữ
                        child: Text('Nam'),
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
                      const Text('Email')
                    ],
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
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
                      const Text('Số điện thoại')
                    ],
                  ),
                  TextField(
                    controller: foneController,
                    decoration: const InputDecoration(
                      hintText: 'Số điện thoại',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Mô tả'),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
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
                          color: Provider.of<Providercolor>(context)
                              .selectedColor),
                    ),
                    child: TextButton(
                      onPressed: () {
                        widget.onSelectPage(2);
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
            ],
          ),
        ),
      ),
    );
  }
}
