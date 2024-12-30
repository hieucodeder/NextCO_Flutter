import 'package:app_1helo/charPage/columnchar_page.dart';
import 'package:app_1helo/navigation/bottom_navigation.dart';
import 'package:app_1helo/pages/accout_page.dart';
import 'package:app_1helo/pages/change_password.dart';
import 'package:app_1helo/pages/chat_box.dart';
import 'package:app_1helo/pages/pay_page.dart';
import 'package:app_1helo/pages/customer_page.dart';
import 'package:app_1helo/pages/file_co_page.dart';
import 'package:app_1helo/navigation/drawer.dart';
import 'package:app_1helo/pages/facebookPage.dart';
import 'package:app_1helo/pages/funtions_page.dart';
import 'package:app_1helo/pages/personal_info.dart';
import 'package:app_1helo/pages/home_page.dart';
import 'package:app_1helo/pages/material_resport_page.dart';
import 'package:app_1helo/pages/materials_page.dart';
import 'package:app_1helo/pages/product_page.dart';
import 'package:app_1helo/pages/productreport_page.dart';
import 'package:app_1helo/pages/staff_page.dart';
import 'package:app_1helo/provider/navigationProvider.dart';
import 'package:app_1helo/provider/providerColor.dart';
import 'package:app_1helo/service/app_localizations%20.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  // final List<Map<String, dynamic>> languages = [
  //   {'locale': const Locale('vi'), 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
  //   {'locale': const Locale('en'), 'name': 'English', 'flag': '🇺🇸'},
  // ];
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const Funtionspage();
      case 2:
        return const AcountPage();
      case 3:
        return const Dshosoco();
      case 4:
        return const PersonalInfo();
      case 5:
        return const Changepassword();
      case 6:
        return const Staffpage();
      case 7:
        return const ProductPage();
      case 8:
        return const Materialspage();
      case 9:
        return const Clientpage();
      case 10:
        return const Columncharpage();
      case 11:
        return const Paypage();
      case 12:
        return const Productreportpage();
      case 13:
        return const Materialresportpage();
      default:
        return const HomePage();
    }
  }

  String _getAppBarTitle(BuildContext context, int index) {
    final localization = AppLocalizations.of(context);

    if (localization == null) {
      return "Default Title"; // Fallback title in case localization is null
    }

    switch (index) {
      case 0:
        return localization.translate('activity_report');
      case 1:
        return localization.translate('functions');
      case 2:
        return localization.translate('personal');
      case 3:
        return localization.translate('co_list');
      case 4:
        return localization.translate('personal_info');
      case 5:
        return localization.translate('change_password');
      case 6:
        return localization.translate('user_management');
      case 7:
        return localization.translate('product_list');
      case 8:
        return localization.translate('material_management');
      case 9:
        return localization.translate('customer_list');
      case 10:
        return localization.translate('software_usage_info');
      case 11:
        return localization.translate('payment_info');
      case 12:
        return localization.translate('product_stock_report');
      case 13:
        return localization.translate('material_stock_report');
      default:
        return localization.translate('activity_report');
    }
  }

  bool isExpanded = false;

  void _toggleButtons() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final currentIndex = navigationProvider.currentIndex;
    final selectedColor = Provider.of<Providercolor>(context).selectedColor;
    final localization = AppLocalizations.of(context);

    // final currentLocale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      drawer: DrawerCustom(
        onItemSelected: (index) {
          navigationProvider.setCurrentIndex(index);
          Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(context, currentIndex),
          style: GoogleFonts.robotoCondensed(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // DropdownButton<Locale>(
          //   value: currentLocale,
          //   onChanged: (Locale? newLocale) {
          //     if (newLocale != null) {
          //       context.read<LocaleProvider>().setLocale(newLocale);
          //     }
          //   },
          //   items: languages.map((language) {
          //     return DropdownMenuItem<Locale>(
          //       value: language['locale'],
          //       child: Row(
          //         children: [
          //           Text(
          //             language['flag'],
          //             style: const TextStyle(fontSize: 24),
          //           ),
          //         ],
          //       ),
          //     );
          //   }).toList(),
          // ),
          IconButton(
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    value: 'unread',
                    child: Text(
                      localization?.translate('un_read') ?? 'Chưa đọc',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'all',
                    child: Text(
                      localization?.translate('all') ?? 'Tất cả',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ).then((value) {
                if (value == 'all') {
                } else if (value == 'unread') {}
              });
            },
            icon: const Icon(Icons.notifications_none_outlined, size: 24),
            color: Colors.white,
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: selectedColor,
      ),
      body: _getPage(currentIndex),
      bottomNavigationBar: BottomNavigation(
          currentIndex: currentIndex.clamp(0, 2),
          onTap: (index) {
            navigationProvider.setCurrentIndex(index);
          }),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Visibility(
            visible: isExpanded,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 150.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  heroTag: 'uniqueTagForButton3',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FacebookPage()));
                  },
                  tooltip: 'Button 3',
                  backgroundColor: selectedColor,
                  child: const Icon(
                    Icons.facebook_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isExpanded,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  heroTag: 'uniqueTagForButton2',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Chatbox()));
                  },
                  backgroundColor: selectedColor,
                  tooltip: 'Button 2',
                  child: const Icon(
                    Icons.zoom_out_map_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isExpanded,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  heroTag: 'uniqueTagForButton1',
                  onPressed: () {},
                  backgroundColor: selectedColor,
                  tooltip: 'Button 1',
                  child: const Icon(
                    Icons.phone_callback_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              onPressed: _toggleButtons,
              tooltip: 'Toggle',
              backgroundColor: selectedColor,
              child: Icon(
                isExpanded ? Icons.close : Icons.support_agent_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
