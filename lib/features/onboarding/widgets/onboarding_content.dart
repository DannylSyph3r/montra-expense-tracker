import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingContent extends StatelessWidget {
  final Color backgroundColor;
  final Color? textColor;
  final String image;
  final String title;
  final String description;
  const OnboardingContent({
    Key? key,
    required this.backgroundColor,
    this.textColor,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context),
      width: width(context),
      decoration: BoxDecoration(color: backgroundColor),
      child: Column(
        children: [
          70.sbH,
          //! image

          image.png.myImage(
            height: 346.h,
          ),
          14.sbH,

          //! title
          Padding(
            padding: 15.padH,
            child: title.txt(
                size: 28.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
                textAlign: TextAlign.center),
          ),
          30.sbH,

          //! description
          Padding(
            padding: 15.padH,
            child: description.txt(
                size: 16.sp,
                fontWeight: FontWeight.w300,
                color: textColor,
                textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }
}
