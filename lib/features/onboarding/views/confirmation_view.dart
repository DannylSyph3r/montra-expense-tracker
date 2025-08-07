import 'package:expense_tracker_app/features/base_nav/wrapper/base_nav_wrapper.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ClusterConfirmationView extends StatelessWidget {
  const ClusterConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          0.sbH,
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    PhosphorIconsBold.seal,
                    size: 130.h,
                    color: Palette.montraPurple,
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(duration: 4.seconds),
                  Icon(
                    PhosphorIconsFill.checkFat,
                    size: 40.h,
                    color: Palette.montraPurple,
                  ),
                ],
              ),
              30.sbH,
              "You are all Set!".txt(size: 22.sp, fontW: F.w6),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: 15.padH,
                child: TransparentButton(
                  onTap: () {
                    goTo(context: context, view: const BaseNavWrapper());
                  },
                  isText: true,
                  text: "Let's Get Tracking!",
                  textColor: Palette.montraPurple,
                  fontSize: 16.sp,
                  outlineColor: Palette.montraPurple,
                  backgroundColor: Palette.montraPurple.withValues(alpha: 0.2),
                ),
              ),
              30.sbH
            ],
          )
        ],
      )),
    );
  }
}
