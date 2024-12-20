import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_1helo/provider/providerColor.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavigation(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    final selectedColor = Provider.of<Providercolor>(context).selectedColor;

    return Container(
      decoration: BoxDecoration(
        color: selectedColor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.robotoCondensed(
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        unselectedLabelStyle: GoogleFonts.robotoCondensed(
          textStyle: const TextStyle(fontSize: 13),
        ),
        items: [
          _buildNavItem(
            isSelected: widget.currentIndex == 0,
            activeIcon: Icons.home,
            inactiveIcon: Icons.home_outlined,
            label: 'Trang chủ',
          ),
          _buildNavItem(
            isSelected: widget.currentIndex == 1,
            activeIcon: Icons.dashboard,
            inactiveIcon: Icons.dashboard_outlined,
            label: 'Chức năng',
          ),
          _buildNavItem(
            isSelected: widget.currentIndex == 2,
            activeIcon: Icons.account_box,
            inactiveIcon: Icons.account_box_outlined,
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required bool isSelected,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.orange.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isSelected ? activeIcon : inactiveIcon,
          size: 25,
        ),
      ),
      label: label,
    );
  }
}
