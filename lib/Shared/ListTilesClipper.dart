import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ListTilesClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.5000000);
    path_0.lineTo(0, size.height);
    path_0.lineTo(size.width, size.height);
    path_0.quadraticBezierTo(size.width * 1.0016000, size.height * 0.2538600,
        size.width, size.height * 0.0315000);
    path_0.cubicTo(
        size.width * 1.0010800,
        size.height * 0.0148600,
        size.width * 0.9800600,
        size.height * 0.0030400,
        size.width * 0.9448000,
        size.height * 0.0187200);
    path_0.cubicTo(
        size.width * 0.8799600,
        size.height * 0.0477200,
        size.width * 0.2682400,
        size.height * 0.3309600,
        size.width * 0.0345600,
        size.height * 0.4433400);
    path_0.quadraticBezierTo(size.width * 0.0004200, size.height * 0.4567800, 0,
        size.height * 0.5000000);
    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
