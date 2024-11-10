import 'dart:async';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NotificationPage extends StatefulWidget {
  final Function(int) onSelectPage;
  const NotificationPage({super.key, required this.onSelectPage});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Timer? _timer;
  final List<String> _images = [
    'resources/FTA.png',
    'resources/xuatxu3.jpg',
    'resources/quytrinhthutuc.jpg',
    'resources/quoctichhanghoa.jpg',
    'resources/haiquan.jpg',
    'resources/cang.png',
  ];
  int _currentIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < _images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.white,
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
            height: 16,
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
                        widget.onSelectPage(9);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    'Khách hàng',
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 14,
                                        color:
                                            Provider.of<Providercolor>(context)
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
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.onSelectPage(3);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    'Hồ sơ C/O',
                                    style: GoogleFonts.robotoCondensed(
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.onSelectPage(7);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    'Sản phẩm',
                                    style: GoogleFonts.robotoCondensed(
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        fontSize: 14,
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
                        widget.onSelectPage(8);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 105,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    'Nguyên vật liệu',
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 14,
                                        color:
                                            Provider.of<Providercolor>(context)
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
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.onSelectPage(6);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    'Nhân viên',
                                    style: GoogleFonts.robotoCondensed(
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.onSelectPage(10);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    'Thống kê',
                                    style: GoogleFonts.robotoCondensed(
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        fontSize: 14,
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
                        widget.onSelectPage(13);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    'Vật liệu tồn',
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 14,
                                        color:
                                            Provider.of<Providercolor>(context)
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
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.onSelectPage(12);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    'Sản phẩm tồn',
                                    style: GoogleFonts.robotoCondensed(
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.onSelectPage(11);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    'Thanh toán',
                                    style: GoogleFonts.robotoCondensed(
                                        color:
                                            Provider.of<Providercolor>(context)
                                                .selectedColor,
                                        fontSize: 14,
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
    );
  }
}
