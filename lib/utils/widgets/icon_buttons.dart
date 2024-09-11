import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconButtons extends StatelessWidget {
  final IconData connectIcon;
  final void Function()? onIconTap;
  final double? iconSize;
  final Color? iconColor;
  final List<Shadow>? iconShadows;
  const IconButtons(
      {super.key,
      required this.connectIcon,
      this.onIconTap,
      this.iconSize,
      this.iconColor,
      this.iconShadows});

  @override
  Widget build(BuildContext context) {
    return Icon(
      connectIcon,
      size: iconSize ?? 16.sp,
      color: iconColor ?? Palette.greyColor,
      shadows: iconShadows,
    ).tap(onTap: onIconTap);
  }
}

class ConnectIconButtons extends StatelessWidget {
  final IconData connectIcon;
  final void Function()? onIconButtonTap;
  final double? iconSize;
  final Color? iconColor;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? iconPadding;
  final String? iconToolTip;
  final double? splashRadius;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? disabledColor;
  const ConnectIconButtons({
    super.key,
    this.visualDensity,
    this.iconPadding,
    this.iconToolTip,
    this.splashRadius,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    required this.connectIcon,
    this.onIconButtonTap,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      enableFeedback: true,
      tooltip: iconToolTip,
      padding: iconPadding,
      visualDensity: visualDensity,
      onPressed: onIconButtonTap,
      icon: Icon(
        connectIcon,
        size: iconSize ?? 16.sp,
        color: iconColor ?? Palette.greyColor,
      ),
      splashRadius: splashRadius,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      disabledColor: disabledColor,
    );
  }
}
