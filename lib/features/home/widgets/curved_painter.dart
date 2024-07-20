import 'package:expense_tracker_app/theme/palette.dart';
import 'package:flutter/material.dart';

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Palette.whiteColor
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, size.height * 0.5) // Start at the left-middle
      ..quadraticBezierTo(size.width * 0.5, size.height * 1.5, size.width, size.height * 0.5) // Draw the curve
      ..lineTo(size.width, size.height) // Draw line to the bottom-right
      ..lineTo(0, size.height) // Draw line to the bottom-left
      ..close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
