import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiamondPainter extends CustomPainter {
  double length;
  DiamondPainter({this.length});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;

    Path path = Path()
    ..moveTo(0, -length/2)
    ..lineTo(length/2, 0)
    ..lineTo(0, length/2)
    ..lineTo(-length/2, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}