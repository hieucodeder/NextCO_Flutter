import 'package:flutter/material.dart';

class OvalBttoCllipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height / 1.2);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
