import 'package:expense_tracker_app/theme/palette.dart';
import 'package:flutter/material.dart';

class SerratedPainter extends CustomPainter {
  final int teethCount;
  final double teethHeight;

  SerratedPainter({this.teethCount = 20, this.teethHeight = 10.0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Palette.whiteColor
      ..style = PaintingStyle.fill;

    var path = Path();

    // Start at the top-left corner
    path.moveTo(0, 0);

    // Calculate the width of each tooth
    double toothWidth = size.width / teethCount;

    // Draw serrated edge
    for (int i = 0; i < teethCount; i++) {
      path.lineTo((i * 2 + 1) * toothWidth / 2, teethHeight);
      path.lineTo((i + 1) * toothWidth, 0);
    }

    // Complete the shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}