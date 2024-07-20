// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliverwareAppBar extends StatelessWidget {
  final double? appBarToolbarheight;
  final double? appBarCollapsedHeight;
  final double? expandedHeight; //Used
  final bool isPinned; //Used
  final bool canStretch; //Used
  final bool isFloating;
  final Color appBarColor; //Used
  final CollapseMode? sliverCollapseMode;
  final Widget? expandedSliverSpaceBackground; //Used
  final Widget? leadingWidget;
  final VoidCallback? leadingTapAction;
  final bool customizeLeadingWidget;
  final Color? leadingIconColor;
  final IconData? customLeadingIcon;
  final bool? isLeadingAnIcon;
  final bool showLeadingIconOrWidget;
  final bool? titleCentered;
  final String? title; //Used
  final bool? isTitleAWidget;
  final Widget? titleWidget;
  final Widget? expandedSliverTitle;
  final double? titleFontSize; //Used
  final FontWeight? titleFontWeight; //Used
  final Color? titleFontColor;
  final List<Widget>? actions; //Used
  final PreferredSizeWidget? sliverBottom; //Used

  const SliverwareAppBar({
    Key? key,
    this.appBarToolbarheight,
    this.appBarCollapsedHeight,
    this.expandedHeight,
    required this.isPinned,
    required this.canStretch,
    required this.isFloating,
    required this.appBarColor,
    this.sliverCollapseMode,
    this.expandedSliverSpaceBackground,
    this.leadingWidget,
    this.leadingTapAction,
    required this.customizeLeadingWidget,
    this.leadingIconColor,
    this.customLeadingIcon,
    this.isLeadingAnIcon,
    this.expandedSliverTitle,
    required this.showLeadingIconOrWidget,
    this.titleCentered = false,
    this.title,
    this.isTitleAWidget = false,
    this.titleWidget,
    this.titleFontSize,
    this.titleFontWeight,
    this.titleFontColor,
    this.actions,
    this.sliverBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        toolbarHeight: appBarToolbarheight ?? kToolbarHeight,
        collapsedHeight: appBarCollapsedHeight,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: showLeadingIconOrWidget,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        expandedHeight: expandedHeight,
        backgroundColor: appBarColor,
        elevation: 0.0,
        centerTitle: titleCentered,
        title: isTitleAWidget == false
            ? Text(
                title ?? "",
                style: TextStyle(
                  fontSize: titleFontSize ?? 22.sp,
                  color: titleFontColor ?? Palette.blackColor,
                  fontWeight: titleFontWeight,
                ),
              )
            : titleWidget,
        actions: actions ?? const [SizedBox.shrink()],
        pinned: isPinned,
        floating: isFloating,
        stretch: canStretch,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: sliverCollapseMode ?? CollapseMode.pin,
          title: expandedSliverTitle,
          background: expandedSliverSpaceBackground ??
              Container(
                height: expandedHeight,
              ),
          stretchModes: const [
            StretchMode.blurBackground,
            StretchMode.zoomBackground,
          ],
        ),
        bottom: sliverBottom,
        leadingWidth: titleCentered == false ? 60 : null,
        leading: showLeadingIconOrWidget
            ? customizeLeadingWidget
                ? isLeadingAnIcon ?? true
                    ? IconButton(
                        onPressed: () => leadingTapAction!(),
                        icon: Icon(
                          customLeadingIcon ?? Icons.close,
                          color: leadingIconColor ?? Palette.blackColor,
                        ))
                    : GestureDetector(
                        onTap: leadingTapAction ?? () {}, child: leadingWidget)
                : null
            : null);
  }
}
