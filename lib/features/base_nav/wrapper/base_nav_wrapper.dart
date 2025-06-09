import 'package:expense_tracker_app/features/base_nav/bloc/nav_cubit.dart';
import 'package:expense_tracker_app/features/base_nav/widgets/nav_bar_widgets.dart';
import 'package:expense_tracker_app/features/finances/views/finance_view.dart';
import 'package:expense_tracker_app/features/home/views/home_view.dart';
import 'package:expense_tracker_app/features/profile/views/profile_view.dart';
import 'package:expense_tracker_app/features/transactions/views/transactions_view.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum Nav {
  home('Home', PhosphorIconsFill.house),
  transactions('Transactions', PhosphorIconsFill.arrowsDownUp),
  finances('Finances', PhosphorIconsFill.chartPieSlice),
  profile('Profile', PhosphorIconsFill.user);

  const Nav(this.label, this.icon);
  final String label;
  final IconData icon;
}

List<Widget> pages = [
  const HomeView(),
  const TransactionsView(),
  const FinanceView(),
  const ProfileView(),
];

class BaseNavWrapper extends StatelessWidget {
  const BaseNavWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BaseNavCubit(),
      child: BlocBuilder<BaseNavCubit, BaseNavState>(
        builder: (context, state) {
          int indexFromController = state.currentIndex;

          // Check if keyboard is visible
          bool isKeyboardVisible =
              MediaQuery.of(context).viewInsets.bottom != 0;

          // Update cubit with keyboard visibility
          context
              .read<BaseNavCubit>()
              .updateKeyboardVisibility(isKeyboardVisible);

          return PopScope(
            canPop: false,
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Palette.whiteColor,
                body: Stack(
                  children: [
                    pages[indexFromController],
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: state.isKeyboardVisible
                            ? 0.0
                            : 1.0, // Toggle opacity
                        duration: 300.milliseconds,
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.r)),
                            child: Material(
                              elevation: 40,
                              shadowColor: Palette.blackColor,
                              child: Container(
                                padding:
                                    EdgeInsets.only(left: 15.w, right: 15.w),
                                color: Palette.greyColor.withOpacity(0.2),
                                height: 60.h,
                                width: width(context) * 0.87,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: Nav.values
                                      .map((navItem) =>
                                          NavBarWidget(nav: navItem))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )

                // bottomNavigationBar: Material(
                //   elevation: 40,
                //   shadowColor: Palette.blackColor,
                //   child: Container(
                //     padding: EdgeInsets.only(left: 20.w, right: 20.w),
                //     color: Palette.whiteColor,
                //     height: 62.h,
                //     width: width(context),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: Nav.values
                //           .map((navItem) => NavBarWidget(nav: navItem))
                //           .toList(),
                //     ),
                //   ),
                // ),
                ),
          );
        },
      ),
    );
  }
}
