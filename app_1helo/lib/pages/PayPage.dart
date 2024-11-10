import 'package:app_1helo/provider/providerColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class Paypage extends StatefulWidget {
  final Function(int) onSelectPage;
  const Paypage({super.key, required this.onSelectPage});
  @override
  _PaypageState createState() => _PaypageState();
}

class _PaypageState extends State<Paypage> {
  final String bankAccountNumber = "1348748888";
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> _downloadQrCode() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await screenshotController.captureAndSave(directory.path,
        fileName: "qr_code.png");
    if (imagePath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mã QR đã được tải về: $imagePath")),
      );
    }
  }

  void _copyBankAccountNumber() {
    Clipboard.setData(ClipboardData(text: bankAccountNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Số tài khoản đã được sao chép")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.0),
                    child: Image.asset(
                      'resources/vietcb.png',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: Positioned(
                    bottom: 40,
                    child: Column(
                      children: [
                        Text(
                          'CÔNG TY CỔ PHẦN CÔNG NGHỆ AI-TEKWORKS VIETNAM',
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1348748888',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bankAccountNumber,
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.black),
                  onPressed: _copyBankAccountNumber,
                ),
              ],
            ),
            Text(
              ' Vietcombank-chi nhánh Thăng Long',
              style: GoogleFonts.robotoCondensed(fontSize: 16),
            ),
            SizedBox(
              height: 30,
            ),
            Screenshot(
              controller: screenshotController,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Provider.of<Providercolor>(context).selectedColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'resources/QR.png',
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: _downloadQrCode,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Provider.of<Providercolor>(context).selectedColor,
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Tải mã QR",
                style: GoogleFonts.robotoCondensed(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
