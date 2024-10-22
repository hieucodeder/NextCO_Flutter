import 'dart:async';
import 'dart:math';
import 'package:app_1helo/charPage/LineCharPage.dart';
import 'package:app_1helo/charPage/PieChartPage.dart';
import 'package:app_1helo/service/customer_service..dart';
import 'package:app_1helo/service/document_service.dart';
import 'package:app_1helo/service/material_service.dart';
import 'package:app_1helo/service/product_service.dart';
import 'package:app_1helo/service/user_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final Function(int) onSelectPage;

  const HomePage({super.key, required this.onSelectPage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int? totalItems;
  int? totalDocuments;
  int? totalProduct;
  int? totalMaterial;
  int? totalUser;
  bool isLoading = true;
  String randomNumber = '';

  final CustomerService customerService = CustomerService();
  final DocumentService documentsService = DocumentService();
  final ProductService productService = ProductService();
  final MaterialService materialService = MaterialService();
  final UserService userService = UserService();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    initNumber();
    startRandomNumber();
    fetchAllData();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initNumber() {
    totalItems = -1;
    totalDocuments = -1;
    totalProduct = -1;
    totalMaterial = -1;
    totalUser = -1;
  }

  void startRandomNumber() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      if (mounted) {
        setState(() {
          randomNumber = (Random().nextInt(100) + 1).toString();
        });
      }
    });
  }

  void randomNumberFunc(int range) {
    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      if (mounted) {
        setState(() {
          randomNumber = (Random().nextInt(100) + 1).toString();
        });
      }
    });
  }

  Future<void> fetchAllData() async {
    await Future.wait([
      _fetchData(() => customerService.fetchTotalItems(),
          (result) => totalItems = result),
      _fetchData(() => documentsService.fetchTotalItemsDocuments(),
          (result) => totalDocuments = result),
      _fetchData(() => productService.fetchTotalItemsProducts(),
          (result) => totalProduct = result),
      _fetchData(() => materialService.fetchTotalItemsMaterials(),
          (result) => totalMaterial = result),
      _fetchData(() => userService.fetchTotalItemsUsers(),
          (result) => totalUser = result),
    ]);

    if (mounted) {
      setState(() {
        isLoading = false;
        timer?.cancel();
      });
    }
  }

  Future<void> _fetchData(
      Future<int?> Function() fetchFunction, Function(int?) updateState) async {
    int? result = await fetchFunction();
    if (mounted) {
      setState(() {
        updateState(result);
      });
    }
  }

  Text customNumberResult(String text, Color? color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  String formatNumber(int? number) {
    if (number == null) {
      return '-';
    } else {
      return NumberFormat('#,##0', 'en_US').format(number);
    }
  }

  Text renderNumberResult(
      int? result, Color color, bool isLoading, String romdomNumber) {
    return result == null
        ? customNumberResult('-', Colors.red)
        : customNumberResult(
            isLoading ? randomNumber : formatNumber(result),
            color,
          );
  }

  final styleText = GoogleFonts.robotoCondensed(
      textStyle: const TextStyle(
          fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400));
  final stylesNumber = GoogleFonts.robotoCondensed(
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.onSelectPage(9);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xfff9f0ff),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x005c6566).withOpacity(0.3),
                              blurRadius: 8,
                            )
                          ]),
                      width: (MediaQuery.of(context).size.width - 50) / 2,
                      height: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                renderNumberResult(
                                    totalItems,
                                    const Color(0xff9254DE),
                                    isLoading,
                                    randomNumber),
                                Text(
                                  'Khách hàng',
                                  style: GoogleFonts.robotoCondensed(
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff9254DE),
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: SvgPicture.asset(
                              'resources/khachhang.svg',
                              // color: Color(0xD3ADF7).withOpacity(0.2),

                              fit: BoxFit.contain,
                              width: 56,
                              height: 56,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onSelectPage(3);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffECFCFE),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x005c6566).withOpacity(0.3),
                              blurRadius: 8,
                            )
                          ]),
                      // width: 190,
                      width: (MediaQuery.of(context).size.width - 50) / 2,
                      height: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                renderNumberResult(
                                    totalDocuments,
                                    const Color(0xff064265),
                                    isLoading,
                                    randomNumber),
                                Text(
                                  'Hồ sơ C/O',
                                  style: GoogleFonts.robotoCondensed(
                                      color: const Color(0xff064265),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          Center(
                            child: SvgPicture.asset(
                              'resources/hoso.svg',
                              fit: BoxFit.contain,
                              height: 56,
                              width: 56,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.onSelectPage(7);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffF6FFED),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x005c6566).withOpacity(0.3),
                              blurRadius: 8,
                            )
                          ]),
                      width: (MediaQuery.of(context).size.width - 50) / 2,
                      height: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                renderNumberResult(
                                    totalProduct,
                                    const Color(0xff389E0D),
                                    isLoading,
                                    randomNumber),
                                Text(
                                  'Sản phẩm',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff389E0D),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Center(
                            child: SvgPicture.asset(
                              'resources/Product.svg',
                              fit: BoxFit.contain,
                              width: 56,
                              height: 56,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      widget.onSelectPage(8);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffFAFAFA),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x005c6566).withOpacity(0.3),
                              blurRadius: 8,
                            )
                          ]),
                      width: (MediaQuery.of(context).size.width - 50) / 2,
                      height: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                renderNumberResult(
                                    totalMaterial,
                                    const Color(0xffFA8C16),
                                    isLoading,
                                    randomNumber),
                                Text('Nguyên vật liệu',
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xffFA8C16)))
                              ],
                            ),
                          ),
                          Center(
                            child: SvgPicture.asset(
                              'resources/Material.svg',
                              fit: BoxFit.contain,
                              height: 56,
                              width: 56,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                widget.onSelectPage(6);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xffE6FFFB),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x005c6566).withOpacity(0.3),
                        blurRadius: 8,
                      )
                    ]),
                width: (MediaQuery.of(context).size.width - 50) / 2,
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          renderNumberResult(totalUser, const Color(0xff13C2C2),
                              isLoading, randomNumber),
                          Text('Nhân viên',
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff13C2C2)))
                        ],
                      ),
                    ),
                    Center(
                      child: SvgPicture.asset(
                        'resources/Employed.svg',
                        fit: BoxFit.contain,
                        height: 56,
                        width: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xffFAFAFA),
                      border: Border.all(
                          width: 1,
                          color: const Color(0xffC4C9CA),
                          style: BorderStyle.solid),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff2C2E30).withOpacity(0.2),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 370,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 36,
                            padding: const EdgeInsets.all(8),
                            child: Text('Số lượng hồ sơ C/O theo trạng thái',
                                style: GoogleFonts.robotoCondensed(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const Divider(color: Color(0xffC4C9CA)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 168,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color(0xffC4C9CA),
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    _showsimpleDialog(context);
                                  },
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: 'CÔNG TY TNHH SE...',
                                        hintStyle: GoogleFonts.robotoCondensed(
                                            color: const Color(0xffAAB1B1)),
                                        border: InputBorder.none,
                                        suffixIcon: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            VerticalDivider(
                                              width: 20,
                                              thickness: 1,
                                              color: Color(0xffC4C9CA),
                                            ),
                                            Icon(Icons.arrow_drop_down_outlined,
                                                color: Color(0xffAAB1B1))
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              Container(
                                width: 168,
                                height: 36,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color(0xffC4C9CA),
                                        width: 1,
                                        style: BorderStyle.solid)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    _showsimpleDialog(context);
                                  },
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: 'Nguyễn Văn A',
                                        hintStyle: GoogleFonts.robotoCondensed(
                                          color: const Color(0xffAAB1B1),
                                        ),
                                        border: InputBorder.none,
                                        suffixIcon: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            VerticalDivider(
                                              width: 20,
                                              color: Color(0xffAAB1B1),
                                              thickness: 1,
                                            ),
                                            Icon(Icons.arrow_drop_down_outlined,
                                                color: Color(0xffAAB1B1))
                                          ],
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Linecharpage(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xffFAFAFA),
                      border: Border.all(
                          width: 1,
                          color: const Color(0xffC4C9CA),
                          style: BorderStyle.solid),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xff2C2E30).withOpacity(0.2),
                            blurRadius: 8)
                      ]),
                  width: MediaQuery.of(context).size.width,
                  height: 450,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 36,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text('Tỷ lệ hồ sơ C/O theo trạng thái',
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        const Divider(color: Color(0xffC4C9CA)),
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 36,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1,
                                      color: const Color(0xffC4C9CA),
                                      style: BorderStyle.solid)),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: AbsorbPointer(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: TextField(
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        labelText:
                                            'Chọn Ngày Bắt Đầu và Kết Thúc',
                                        labelStyle: GoogleFonts.robotoCondensed(
                                            fontSize: 14,
                                            color: const Color(0xffAAB1B1)),
                                        border: InputBorder.none,
                                        suffixIcon: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            VerticalDivider(
                                              width: 20,
                                              thickness: 1,
                                              color: Color(0xffC4C9CA),
                                            ),
                                            Icon(Icons.calendar_today_rounded,
                                                color: Color(0xffAAB1B1))
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 168,
                                  height: 36,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xffC4C9CA),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showsimpleDialog(context);
                                    },
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'CÔNG TY TNHH SE...',
                                          hintStyle:
                                              GoogleFonts.robotoCondensed(
                                                  color:
                                                      const Color(0xffAAB1B1)),
                                          border: InputBorder.none,
                                          suffixIcon: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              VerticalDivider(
                                                width: 20,
                                                thickness: 1,
                                                color: Color(0xffC4C9CA),
                                              ),
                                              Icon(
                                                  Icons
                                                      .arrow_drop_down_outlined,
                                                  color: Color(0xffAAB1B1))
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 168,
                                  height: 36,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xffC4C9CA),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showsimpleDialog(context);
                                    },
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Nguyễn Văn A',
                                          hintStyle:
                                              GoogleFonts.robotoCondensed(
                                            color: const Color(0xffAAB1B1),
                                          ),
                                          border: InputBorder.none,
                                          suffixIcon: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              VerticalDivider(
                                                width: 20,
                                                color: Color(0xffAAB1B1),
                                                thickness: 1,
                                              ),
                                              Icon(
                                                  Icons
                                                      .arrow_drop_down_outlined,
                                                  color: Color(0xffAAB1B1))
                                            ],
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Piechartpage()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showsimpleDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Tùy chọn'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'lựa chọn 1');
                },
                child: const Text('Tùy chọn 1'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'lựa chọn 2');
                },
                child: const Text('Tùy chọn 2'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'lựa chọn 3');
                },
                child: const Text('Tùy chọn 3'),
              ),
            ],
          );
        });
  }
}
