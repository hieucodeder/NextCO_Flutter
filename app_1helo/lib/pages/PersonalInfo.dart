import 'package:flutter/material.dart';

class PersonalInfo extends StatefulWidget {
  final Function(int) onSelectPage;
  const PersonalInfo({super.key, required this.onSelectPage});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  TextEditingController nameController =
      TextEditingController(text: 'Nguyễn Văn A');
  TextEditingController accountController = TextEditingController(text: 'demo');
  TextEditingController dateController =
      TextEditingController(text: '01/11/1999');
  TextEditingController emailController =
      TextEditingController(text: 'demo@gmail.com');
  TextEditingController foneController =
      TextEditingController(text: '0999999999');
  TextEditingController MotaController = TextEditingController(text: 'Mô tả');
  String? gender = 'Nam';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Họ và tên',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: accountController,
              readOnly: true,
              enabled: false,
              decoration: const InputDecoration(
                  labelText: 'Tài khoản',
                  border: OutlineInputBorder(),
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                  labelText: 'Ngày sinh',
                  border: OutlineInputBorder(),
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  labelText: 'Giới tính',
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )),
              value: gender,
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'Nam',
                  child: Text('Nam'),
                ),
                DropdownMenuItem(
                  value: 'Nữ',
                  child: Text('Nữ'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: foneController,
              decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: MotaController,
              decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                  suffix: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.all(10),
                      elevation: 30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {
                      widget.onSelectPage(2);
                    },
                    child: const Text('Quay lại'),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 33, 159, 243),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(10),
                      elevation: 30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      // side: const BorderSide(
                      //     width: 2, color: Color.fromARGB(255, 255, 59, 85))
                    ),
                    onPressed: () {},
                    child: const Text('Lưu'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
