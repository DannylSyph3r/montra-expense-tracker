import 'package:expense_tracker_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomModal extends StatelessWidget {
  final double modalHeight;
  final Color? color;
  final Widget child; // Accept any widget as a child

  const CustomModal({
    required this.modalHeight,
    this.color,
    required this.child,
    super.key,
  });

  

  @override
  Widget build(BuildContext context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final backgroundColor =
      color ?? (isDarkMode ? Palette.blackColor : Palette.whiteColor);
    return Container(
      height: modalHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Container(
            width: 60.w,
            height: 4.h,
            decoration: ShapeDecoration(
              color: Palette.montraPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(child: child), // Use the passed child widget here
        ],
      ),
    );
  }
}

void showCustomModal(
  BuildContext context, {
  required double modalHeight,
  required Widget child,
  VoidCallback? onDismissed,
}) {
  showModalBottomSheet(
    isScrollControlled: true, // This is key!
    enableDrag: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Keyboard padding
      ),
      child: CustomModal(
        modalHeight: modalHeight,
        child: child,
      ),
    ),
  ).then((value) {
    if (onDismissed != null) {
      onDismissed();
    }
  });
}
