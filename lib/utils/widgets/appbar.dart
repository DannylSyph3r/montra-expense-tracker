import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar customAppBar(String title,
    {bool isLeftAligned = false,
    bool? isTitleCentered,
    bool? implyLeading,
    double? fontSize,
    FontWeight? fontWeight,
    List<Widget>? actions,
    TabBar? bottom,
    double? toolbarHeight,
    bool showBackButton = true,
    Color? color,
    Color? fontColor,
    Color? iconColor,
    bool overrideBackButtonAction = false,
    bool showXIcon = false,
    Color? foregroundColor,
    Function? backFunction,
    required BuildContext context}) {
  bool shouldShowLeading = implyLeading ?? true;
  bool shouldCenterTitle =
      isTitleCentered ?? (!shouldShowLeading || !isLeftAligned);

  return AppBar(
    toolbarHeight: toolbarHeight ?? 75.h,
    automaticallyImplyLeading: shouldShowLeading,
    titleSpacing: isLeftAligned ? 0 : 5.w,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    foregroundColor: foregroundColor ?? Palette.blackColor,
    backgroundColor: color ?? Palette.whiteColor,
    leading: shouldShowLeading
        ? showBackButton
            ? overrideBackButtonAction
                ? showXIcon
                    ? IconButton(
                        onPressed: () => backFunction!(),
                        icon: Icon(
                          Icons.close,
                          color: iconColor ?? Palette.blackColor,
                        ))
                    : BackButton(
                        color: iconColor ?? Palette.blackColor,
                        onPressed: () => backFunction!(),
                      )
                : showXIcon
                    ? IconButton(
                        onPressed: () => goBack(context),
                        icon: Icon(
                          Icons.close,
                          color: iconColor ?? Palette.blackColor,
                        ))
                    : BackButton(
                        color: iconColor ?? Palette.blackColor,
                      )
            : null
        : null,
    elevation: 0,
    centerTitle: shouldCenterTitle,
    leadingWidth: isLeftAligned ? 30.w : null,
    title: Text(
      title,
      style: GoogleFonts.inter(
        textStyle: TextStyle(
          fontSize: fontSize ?? 22.sp,
          color: fontColor ?? Palette.blackColor,
          fontWeight: fontWeight,
        ),
      ),
    ),
    actions: actions ?? const [SizedBox.shrink()],
    bottom: bottom,
  );
}
