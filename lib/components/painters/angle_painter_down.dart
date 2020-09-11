import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnglePainterDown extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final horizontalLineStart = Offset(0, 0);
    final horizontalLineEnd = Offset(-50, 0);
    final verticalLineStart = Offset(0, 0);
    final verticalLineEnd = Offset(0, -50);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    canvas.drawLine(horizontalLineStart, horizontalLineEnd, paint);
    canvas.drawLine(verticalLineStart, verticalLineEnd, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}