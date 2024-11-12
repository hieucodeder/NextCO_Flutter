import 'dart:async';
import 'dart:math';
import 'package:app_1helo/charPage/LineCharPage.dart';
import 'package:app_1helo/charPage/PieChartPage.dart';
import 'package:app_1helo/model/totalModel.dart';
import 'package:app_1helo/service/total_service.dart';
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
  late Future<List<void>> loadData;
// Xử lý bất đồng bộ
  Future<List<void>> loadAllData() {
    return Future.wait([
      _fetchTotalData(),
      Linecharpage().fetchLineChartData(),
      Piechartpage().fetchPieChartData(),
    ]);
  }

  int? totalItems, totalDocuments, totalUser;
  int? totalCustomer,
      totalProduct,
      totalMaterial,
      totalCoDocument,
      totalEmployee;
  bool isLoading = true, isDropDownVisible = false;
  String randomNumber = '';

  Timer? timer;
  final totalService = TotalService();

  @override
  void initState() {
    super.initState();
    _resetState();
    _startRandomNumberGenerator();
    _fetchAllData();
    loadData = loadAllData();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _resetState() {
    totalItems =
        totalDocuments = totalProduct = totalMaterial = totalUser = null;
    totalCustomer = totalCoDocument = totalEmployee = null;
    isDropDownVisible = false;
  }

  void _startRandomNumberGenerator() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      if (mounted) {
        setState(() {
          randomNumber = (Random().nextInt(100) + 1).toString();
        });
      }
    });
  }

  Future<void> _fetchAllData() async {
    setState(() => isLoading = true);

    try {
      await Future.wait([
        _fetchTotalData(),
      ]);
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          timer?.cancel();
        });
      }
    }
  }

  Future<void> _fetchTotalData() async {
    await Future.delayed(Duration(seconds: 2));
    try {
      final Data? data = await totalService.fetchTotalItemsUsers();
      if (mounted) {
        setState(() {
          totalCustomer = data?.customer;
          totalCoDocument = data?.coDocument;
          totalProduct = data?.product;
          totalMaterial = data?.material;
          totalEmployee = data?.employee;
        });
      }
    } catch (e) {
      print("Error fetching total data: $e");
    }
  }

  Text _customText(
      String text, Color color, double fontSize, FontWeight fontWeight) {
    return Text(
      text,
      style:
          TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
    );
  }

  String _formatNumber(int? number) {
    return number == null ? '-' : NumberFormat('#,##0', 'en_US').format(number);
  }

  Text renderNumberResult(int? result, Color color) {
    return _customText(
      isLoading ? randomNumber : _formatNumber(result),
      color,
      20,
      FontWeight.w700,
    );
  }

  final TextStyle styleText = GoogleFonts.robotoCondensed(
    textStyle: const TextStyle(
        fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
  );

  final TextStyle stylesNumber = GoogleFonts.robotoCondensed(
    textStyle: const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
  );

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                          width: 90,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              renderNumberResult(
                                totalCustomer,
                                const Color(0xff9254DE),
                              ),
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
                            fit: BoxFit.contain,
                            width: 56,
                            height: 56,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
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
                                totalCoDocument,
                                const Color(0xff064265),
                              ),
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
                  Container(
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
                              ),
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
                  const SizedBox(width: 10),
                  Container(
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
                              ),
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
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
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
                        renderNumberResult(
                          totalEmployee,
                          const Color(0xff13C2C2),
                        ),
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
                    height: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            child: Text('Số lượng hồ sơ C/O theo trạng thái',
                                style: GoogleFonts.robotoCondensed(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const Divider(color: Color(0xffC4C9CA)),
                          const SizedBox(
                            height: 8,
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
                  height: 470,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text('Tỷ lệ hồ sơ C/O theo trạng thái',
                            style: GoogleFonts.robotoCondensed(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const Divider(color: Color(0xffC4C9CA)),
                      Container(
                          width: double.infinity,
                          height: 400,
                          child: SingleChildScrollView(child: Piechartpage())),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
