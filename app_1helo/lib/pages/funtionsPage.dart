import 'dart:async';
import 'package:app_1helo/provider/navigationProvider.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/appLocalizations%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Funtionspage extends StatefulWidget {
  const Funtionspage({super.key});

  @override
  State<Funtionspage> createState() => _FuntionspageState();
}

class _FuntionspageState extends State<Funtionspage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;

  final List<String> _images = [
    'resources/xuatxu3.jpg',
    'resources/quytrinhthutuc.jpg',
    'resources/quoctichhanghoa.jpg',
    'resources/haiquan.jpg',
    'resources/cang.png',
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize PageController
    _pageController = PageController(initialPage: _currentIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        if (_animationController.isCompleted) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % _images.length;
          });
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
          _animationController.forward(from: 0);
        }
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final localization = AppLocalizations.of(context);
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    _images[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: _images.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: Colors.blue,
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 2,
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          navigationProvider.setCurrentIndex(9);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 135,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x005c6566)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                          )
                                        ]),
                                    child: ClipOval(
                                      child: Transform.scale(
                                        scale: 0.7,
                                        child: SvgPicture.asset(
                                          'resources/customer.svg',
                                          color: Colors.white,
                                          fit: BoxFit.contain,
                                          width: 36,
                                          height: 36,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localization?.translate('customer') ??
                                          'Khách hàng',
                                      style: GoogleFonts.robotoCondensed(
                                          fontSize: 15,
                                          color: Provider.of<Providercolor>(
                                                  context)
                                              .selectedColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigationProvider.setCurrentIndex(3);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 132,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x005c6566)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                          )
                                        ]),
                                    child: ClipOval(
                                      child: Transform.scale(
                                        scale: 0.7,
                                        child: SvgPicture.asset(
                                          'resources/document.svg',
                                          color: Colors.white,
                                          fit: BoxFit.contain,
                                          width: 56,
                                          height: 56,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localization?.translate('file') ??
                                          'Hồ sơ C/O',
                                      style: GoogleFonts.robotoCondensed(
                                          color: Provider.of<Providercolor>(
                                                  context)
                                              .selectedColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigationProvider.setCurrentIndex(7);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 125,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x005c6566)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                          )
                                        ]),
                                    child: ClipOval(
                                      child: Transform.scale(
                                        scale: 0.7,
                                        child: SvgPicture.asset(
                                          'resources/product1.svg',
                                          color: Colors.white,
                                          fit: BoxFit.contain,
                                          width: 56,
                                          height: 56,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localization?.translate('products') ??
                                          'Sản phẩm',
                                      style: GoogleFonts.robotoCondensed(
                                          color: Provider.of<Providercolor>(
                                                  context)
                                              .selectedColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          navigationProvider.setCurrentIndex(8);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 135,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x005c6566)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                          )
                                        ]),
                                    child: ClipOval(
                                      child: Transform.scale(
                                        scale: 0.7,
                                        child: SvgPicture.asset(
                                          'resources/material1.svg',
                                          color: Colors.white,
                                          fit: BoxFit.contain,
                                          width: 36,
                                          height: 36,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localization?.translate('material') ??
                                          'Nguyên vật liệu',
                                      style: GoogleFonts.robotoCondensed(
                                          fontSize: 15,
                                          color: Provider.of<Providercolor>(
                                                  context)
                                              .selectedColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigationProvider.setCurrentIndex(6);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 132,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x005c6566)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                          )
                                        ]),
                                    child: ClipOval(
                                      child: Transform.scale(
                                        scale: 0.7,
                                        child: SvgPicture.asset(
                                          'resources/emloyee.svg',
                                          color: Colors.white,
                                          fit: BoxFit.contain,
                                          width: 56,
                                          height: 56,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localization?.translate('employeed') ??
                                          'Nhân viên',
                                      style: GoogleFonts.robotoCondensed(
                                          color: Provider.of<Providercolor>(
                                                  context)
                                              .selectedColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigationProvider.setCurrentIndex(10);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 125,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x005c6566)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                          )
                                        ]),
                                    child: ClipOval(
                                      child: Transform.scale(
                                        scale: 0.7,
                                        child: SvgPicture.asset(
                                          'resources/info.svg',
                                          color: Colors.white,
                                          fit: BoxFit.contain,
                                          width: 56,
                                          height: 56,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localization?.translate('statistics') ??
                                          'Thống kê',
                                      style: GoogleFonts.robotoCondensed(
                                          color: Provider.of<Providercolor>(
                                                  context)
                                              .selectedColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          navigationProvider.setCurrentIndex(13);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 135,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x005c6566)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                          )
                                        ]),
                                    child: ClipOval(
                                      child: Transform.scale(
                                          scale: 0.7,
                                          child: Image.asset(
                                            'resources/box.png',
                                            color: Colors.white,
                                            fit: BoxFit.contain,
                                            width: 56,
                                            height: 56,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localization?.translate(
                                              'material_inventory') ??
                                          'Nguyên vật liệu tồn',
                                      style: GoogleFonts.robotoCondensed(
                                          fontSize: 15,
                                          color: Provider.of<Providercolor>(
                                                  context)
                                              .selectedColor,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigationProvider.setCurrentIndex(12);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 132,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x005c6566)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                          )
                                        ]),
                                    child: ClipOval(
                                      child: Transform.scale(
                                        scale: 0.7,
                                        child: Image.asset(
                                          'resources/materialtton.png',
                                          color: Colors.white,
                                          fit: BoxFit.contain,
                                          width: 56,
                                          height: 56,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localization?.translate(
                                              'products_inventory') ??
                                          'Sản phẩm tồn',
                                      style: GoogleFonts.robotoCondensed(
                                          color: Provider.of<Providercolor>(
                                                  context)
                                              .selectedColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigationProvider.setCurrentIndex(11);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 125,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Provider.of<Providercolor>(context)
                                          .selectedColor,
                                    ),
                                    child: const ClipOval(
                                        child: Icon(
                                      Icons.qr_code_outlined,
                                      size: 34,
                                      color: Colors.white,
                                    )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localization?.translate('payment') ??
                                          'Thanh toán',
                                      style: GoogleFonts.robotoCondensed(
                                          color: Provider.of<Providercolor>(
                                                  context)
                                              .selectedColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
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
