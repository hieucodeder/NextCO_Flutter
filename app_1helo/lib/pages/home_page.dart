import 'dart:async';
import 'dart:math';
import 'package:app_1helo/charPage/PieChartPage.dart';
import 'package:app_1helo/charPage/tableEmployeedPage.dart';
import 'package:app_1helo/model/prodcutReportModel.dart';
import 'package:app_1helo/model/totalModel.dart';
import 'package:app_1helo/service/appLocalizations%20.dart';
import 'package:app_1helo/service/productReport_service.dart';

import 'package:app_1helo/service/total_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../charPage/LineCharPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<LinecharpageState> _lineChartKey =
      GlobalKey<LinecharpageState>();

  final GlobalKey<PiechartpageState> _pieChartKey =
      GlobalKey<PiechartpageState>();

  final GlobalKey<TableemployeedpageState> _tableEmployeedPageKey =
      GlobalKey<TableemployeedpageState>();
  int? totalProductsResport;
  int? totalItems, totalDocuments, totalUser;
  int? totalCustomer, totalProduct, totalMaterial;
  int? totalCoDocument, totalEmployee, totalProductsreport;

  bool _isLoading = true;
  bool isDropDownVisible = false;
  String randomNumber = '';

  Timer? timer;
  final totalService = TotalService();
  final productReportService = ProductReportService();
  final _scrollController = ScrollController();
  List<DataModel> items = [];

  int currentPage = 1;
  @override
  void initState() {
    super.initState();
    _resetState();
    _startRandomNumberGenerator();
    _fetchAllData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchAllData();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _resetState() {
    totalItems =
        totalDocuments = totalProduct = totalMaterial = totalUser = null;
    totalCustomer =
        totalCoDocument = totalEmployee = totalProductsreport = null;
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
    setState(() => _isLoading = true);

    try {
      await Future.wait([
        _fetchTotalData(),
        _fetchTotalDataProductsReport(),
      ]);
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          timer?.cancel();
        });
      }
    }
  }

  Future<void> _fetchTotalDataProductsReport() async {
    try {
      const int pageSize = 100;
      int page = 1;
      bool hasMoreData = true;
      int totalQuantity = 0;

      while (hasMoreData) {
        final List<DataModel> dataList =
            await productReportService.fetchProductsReportQuantity();

        totalQuantity += dataList.fold<int>(
          0,
          (sum, item) => sum + (item.quantity ?? 0),
        );

        hasMoreData = dataList.length == pageSize;
        page++;
      }

      if (mounted) {
        setState(() {
          totalProductsResport = totalQuantity;
        });
      }
    } catch (e) {
      print("Error fetching total data for products report: $e");
    }
  }

  Future<void> _fetchTotalData() async {
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

  String _formatNumber(int? number) {
    return number == null ? '_' : NumberFormat('#,##0', 'en_US').format(number);
  }

  Text renderNumberResult(int? result, Color color) {
    return Text(
      _isLoading ? randomNumber : _formatNumber(result),
      style: TextStyle(
        color: color,
        fontSize: 19,
        fontWeight: FontWeight.w700,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Future<void> _onRefresh() async {
    _startRandomNumberGenerator();

    await Future.wait([
      _fetchAllData(),
      _lineChartKey.currentState?.refreshChartData() ?? Future.value(),
      _pieChartKey.currentState?.refreshChartData() ?? Future.value()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
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
                                  const Color.fromARGB(255, 108, 55, 172),
                                ),
                                Text(
                                  localization?.translate('customer') ??
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
                          color: const Color.fromARGB(255, 253, 253, 218),
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
                                  const Color.fromARGB(255, 131, 129, 11),
                                ),
                                Text(
                                    localization?.translate('employeed') ??
                                        'Nhân viên',
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromARGB(
                                          255, 131, 129, 11),
                                    ))
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 250, 248, 160),
                              ),
                              child: ClipOval(
                                child: Transform.scale(
                                  scale: 0.7,
                                  child: SvgPicture.asset(
                                    'resources/emloyee.svg',
                                    color:
                                        const Color.fromARGB(255, 131, 129, 11),
                                    fit: BoxFit.contain,
                                    width: 56,
                                    height: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                renderNumberResult(
                                  totalProduct,
                                  const Color(0xff389E0D),
                                ),
                                Text(
                                  localization?.translate('products') ??
                                      'Sản phẩm C/O',
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
                                  localization?.translate('file') ??
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
              const SizedBox(height: 10),
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
                            color: const Color(0xffFFEEED),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  renderNumberResult(
                                    totalProductsResport,
                                    const Color.fromARGB(255, 255, 82, 82),
                                  ),
                                  Text(
                                      localization?.translate(
                                              'product_inventory') ??
                                          'Sản phẩm tồn',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 255, 82, 82),
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Center(
                              child: SvgPicture.asset(
                                'resources/ProductsResport.svg',
                                fit: BoxFit.contain,
                                height: 56,
                                width: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  renderNumberResult(
                                    totalMaterial,
                                    const Color(0xffFA8C16),
                                  ),
                                  Text(
                                      localization?.translate('material') ??
                                          'Nguyên vật liệu',
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
                    ]),
              ),
              const SizedBox(
                height: 20,
              ),
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
                      height: 450,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                localization?.translate('number_employee') ??
                                    'Số lượng hồ sơ C/O theo nhân viên',
                                style: GoogleFonts.robotoCondensed(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                          const Divider(color: Color(0xffC4C9CA)),
                          const SizedBox(
                            height: 8,
                          ),
                          Tableemployeedpage(key: _tableEmployeedPageKey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
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
                      height: 450,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                localization?.translate('number_status') ??
                                    'Số lượng hồ sơ C/O theo trạng thái',
                                style: GoogleFonts.robotoCondensed(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                          const Divider(color: Color(0xffC4C9CA)),
                          const SizedBox(
                            height: 8,
                          ),
                          Linecharpage(key: _lineChartKey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                              localization?.translate('applications_status') ??
                                  'Tỷ lệ hồ sơ C/O theo trạng thái',
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                        const Divider(color: Color(0xffC4C9CA)),
                        Piechartpage(
                          key: _pieChartKey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
