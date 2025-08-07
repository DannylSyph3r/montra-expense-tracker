import 'package:expense_tracker_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FrostedGlassLoader extends StatelessWidget {
  final double theWidth;
  final double theHeight;
  final MainAxisAlignment? theChildAlignment;
  const FrostedGlassLoader(
      {Key? key,
      required this.theWidth,
      required this.theHeight,
      this.theChildAlignment = MainAxisAlignment.center,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: theWidth,
        height: theHeight,
        color: Colors.transparent,
        child: Stack(
          children: [
            //blur effect ==> the third layer of stack
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 1.5,
                sigmaY: 1.5,
              ),
              child: Container(),
            ),
            //gradient effect ==> the second layer of stack
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05),
                    ]),
              ),
            ),
            //child ==> the first/top layer of stack
            Center(
                child: Column(
                    mainAxisAlignment: theChildAlignment!,
                    children: const [
                  SpinKitFadingCircle(color: Palette.redColor)
                ])),
          ],
        ),
      ),
    );
  }
}
