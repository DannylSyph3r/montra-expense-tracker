import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCustomSelectionBottomSheet(BuildContext context, double? modalHeight,
    String title, Widget sheetContent) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35.r), topRight: Radius.circular(35.r))),
    builder: (context) {
      return SizedBox(
        height: modalHeight, // Change the background color as needed
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            children: <Widget>[
              10.sbH,
              Container(
                height: 5.h,
                width: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Palette.greyColor,
                ),
              ),
              30.sbH,
              title.txt16(fontW: F.w6),
              20.sbH,
              sheetContent,
            ],
          ),
        ),
      );
    },
  );
}
