import 'package:app_1helo/provider/providerColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  final ValueChanged<int> changCurrentIndex;
  BottomNavigation({super.key, required this.changCurrentIndex});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  void _onTabTapped(int index) {
    widget.changCurrentIndex(index);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Provider.of<Providercolor>(context).selectedColor,
      padding: EdgeInsets.zero,
      height: 55,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _onTabTapped(0);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  child: IconButton(
                    iconSize: 25,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.home_outlined,
                      color: _currentIndex == 0 ? Colors.orange : Colors.white,
                    ),
                    onPressed: () {
                      _onTabTapped(0);
                    },
                  ),
                ),
                Text('Trang chủ',
                    style: GoogleFonts.robotoCondensed(
                        textStyle: TextStyle(
                            fontSize: 13,
                            color: _currentIndex == 0
                                ? Colors.orange
                                : Colors.white)))
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _onTabTapped(1);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  child: IconButton(
                    iconSize: 25,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.dashboard_outlined,
                      color: _currentIndex == 1 ? Colors.orange : Colors.white,
                    ),
                    onPressed: () {
                      _onTabTapped(1);
                    },
                  ),
                ),
                Text('Chức năng',
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 13,
                        color:
                            _currentIndex == 1 ? Colors.orange : Colors.white))
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _onTabTapped(2);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  child: IconButton(
                    iconSize: 25,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.account_box_rounded,
                      color: _currentIndex == 2 ? Colors.orange : Colors.white,
                    ),
                    onPressed: () {
                      _onTabTapped(2);
                    },
                  ),
                ),
                Text('Cá nhân',
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 13,
                        color:
                            _currentIndex == 2 ? Colors.orange : Colors.white))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
