import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiamondPainter extends CustomPainter {
  Path _path;
  double length;
  DiamondPainter({this.length}) {
    _path = Path()
      ..moveTo(0, -length/2)
      ..lineTo(length/2, 0)
      ..lineTo(0, length/2)
      ..lineTo(-length/2, 0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;

    canvas.drawPath(_path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  @override
  bool hitTest(Offset position) {
    return _path.contains(position);
  }
}