import 'package:expense_tracker_app/features/base_nav/wrapper/base_nav_wrapper.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              AppGraphics.clusterSetupSuccess.png.myImage(
                height: 100.h,
              ),
              10.sbH,
              "You are all Set!".txt(size: 22.sp, fontW: F.w6),
            ],
          ),
          Column(
            children: [
              Container(
                  height: 50.h,
                  width: 333.w,
                  decoration: BoxDecoration(
                      color: Palette.montraPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: Palette.montraPurple)),
                  child: Center(
                    child: "Let's get tracking!".txt(
                        size: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Palette.montraPurple),
                  )).tap(onTap: (){
                    goTo(context: context, view: const BaseNavWrapper());
                  }),
                  30.sbH
            ],
          )
        ],
      )),
    );
  }
}
