import 'package:expense_tracker_app/features/base_nav/bloc/nav_cubit.dart';
import 'package:expense_tracker_app/features/base_nav/wrapper/base_nav_wrapper.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavBarWidget extends StatelessWidget {
  final Nav nav;

  const NavBarWidget({
    Key? key,
    required this.nav,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int indexFromController =
        context.select((BaseNavCubit cubit) => cubit.state.currentIndex);
    bool isSelected = indexFromController == nav.index;

    return SizedBox(
      width: 55.w,
      child: Column(
        children: [
          // Animated Item Indicator Container
          AnimatedContainer(
            duration: 350.milliseconds,
            height: 5.h,
            width: isSelected ? 50.w : 0,
            decoration: BoxDecoration(
              color: isSelected ? Palette.montraPurple : Palette.greyColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.r),
                bottomRight: Radius.circular(25.r),
              ),
            ),
          ),
          10.sbH,

          //! ICON
          Column(
            children: [
              Icon(
                nav.icon,
                color: isSelected ? Palette.montraPurple : Palette.greyColor,
                size: 22.h,
              ),
              3.sbH,
              nav.label.txt(
                size: 11.sp,
                fontW: F.w5,
                color: isSelected ? Palette.montraPurple : Palette.greyColor,
              )
            ],
          ),
        ],
      ),
    ).gestureTap(
      onTap: () {
        context.read<BaseNavCubit>().moveToPage(nav.index);
      },
    );
  }
}
