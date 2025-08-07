import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterTab extends StatelessWidget {
  final Color? tabColor;
  final Color? tabBorderColor;
  final String tabLabel;

  const FilterTab({
    this.tabColor,
    this.tabBorderColor,
    required this.tabLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fillColor =
        tabColor ?? (isDarkMode ? Palette.blackColor : Palette.whiteColor);
    final borderColor =
        tabBorderColor ?? (isDarkMode ? Palette.whiteColor : Palette.greyColor);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      constraints: BoxConstraints(
        minWidth: 90.w, // Set the minimum width
      ),
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // This ensures it expands based on its content
        mainAxisAlignment: MainAxisAlignment.center,
        children: [tabLabel.txt(size: 12.sp)],
      ),
    );
  }
}
