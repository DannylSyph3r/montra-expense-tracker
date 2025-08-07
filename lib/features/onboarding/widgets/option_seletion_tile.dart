import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionSelectionListTile extends StatelessWidget {
  final IconData? leadingIcon;
  final double? horizontalContentPadding;
  final double? titleFontSize;
  final String titleLabel;
  final Color? leadingIconColor;
  final String? subtitleLabel;
  final bool interactiveTrailing;
  final bool? isThreeLines;
  // final Widget? interactiveTrailingWidget;
  final void Function()? onTileTap;
  const OptionSelectionListTile(
      {super.key,
      this.horizontalContentPadding,
      required this.interactiveTrailing,
      this.isThreeLines = false,
      // this.interactiveTrailingWidget,
      this.leadingIconColor,
      this.leadingIcon,
      this.subtitleLabel,
      required this.titleLabel,
      this.titleFontSize,
      this.onTileTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTileTap,
      contentPadding: EdgeInsets.symmetric(
          vertical: 0.h, horizontal: horizontalContentPadding ?? 10.w),
      isThreeLine: isThreeLines ?? false,
      minVerticalPadding: 10.h,
      minLeadingWidth: 5.w,
      subtitle: subtitleLabel?.txt(size: 12.sp),
      leading: leadingIcon != null
          ? Icon(leadingIcon,
              size: 24.sp, color: leadingIconColor ?? Palette.montraPurple)
          : const SizedBox.shrink(),
      title: Container(
          padding:
              subtitleLabel != null ? EdgeInsets.only(bottom: 10.h) : 0.0.padA,
          child: titleLabel.txt(size: titleFontSize ?? 14.sp)),
      // trailing: interactiveTrailing == false
      //     ? MyIcon(icon: AppGrafiks.caretDown, height: 5.h,)
      //     : interactiveTrailingWidget
    );
  }
}
