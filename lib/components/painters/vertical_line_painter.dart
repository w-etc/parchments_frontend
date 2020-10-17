import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerticalLinePainter extends CustomPainter {
  Path _path;
  double height;
  VerticalLinePainter({this.height}) {
    _path = Path()
      ..moveTo(0, -height/2)
      ..lineTo(0, height/2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(_path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
