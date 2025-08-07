import 'package:expense_tracker_app/features/auth/views/login_view.dart';
import 'package:expense_tracker_app/features/auth/views/sign_up_view.dart';
import 'package:expense_tracker_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:expense_tracker_app/features/onboarding/bloc/onboarding_event.dart';
import 'package:expense_tracker_app/features/onboarding/bloc/onboarding_state.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker_app/features/onboarding/widgets/onboarding_content.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
      return BlocProvider(
        create: (_) => OnboardingBloc(),
        child: Scaffold(
          body: Stack(
            children: [
              PageView(
                controller: controller,
                onPageChanged: (value) {
                  state.pageIndex.log();
                  context
                      .read<OnboardingBloc>()
                      .add(SwitchPageIndex(index: value));
                },
                children: const [
                  OnboardingContent(
                    backgroundColor: Palette.whiteColor,
                    image: AppGraphics.onboarding1,
                    title: AppTexts.onboardingTitle1,
                    description: AppTexts.onboardingdescription1,
                  ),
                  OnboardingContent(
                    backgroundColor: Palette.montraPurple,
                    image: AppGraphics.onboarding2,
                    title: AppTexts.onboardingTitle2,
                    description: AppTexts.onboardingdescription2,
                    textColor: Palette.whiteColor,
                  ),
                  OnboardingContent(
                    backgroundColor: Palette.whiteColor,
                    image: AppGraphics.onboarding3,
                    title: AppTexts.onboardingTitle3,
                    description: AppTexts.onboardingdescription3,
                  ),
                ],
              ),

              //! Dots Indicator
              Positioned(
                  child: Column(
                children: [
                  620.sbH,
                  SmoothPageIndicator(
                    effect: WormEffect(
                      dotHeight: 12.h,
                      dotWidth: 12.w,
                      spacing: 13.w,
                      dotColor: state.pageIndex == 1
                          ? Palette.whiteColor.withValues(alpha: 0.25)
                          : Palette.montraPurple.withValues(alpha: 0.25),
                      activeDotColor: state.pageIndex == 1
                          ? Palette.whiteColor
                          : Palette.montraPurple,
                    ),
                    controller: controller,
                    count: 3,
                  ).alignCenter(),
                  30.sbH,

                   //! Signup Button
                  AnimatedOpacity(
                    opacity: state.pageIndex == 2 ? 1 : 0,
                    duration: 300.milliseconds,
                    child: AnimatedContainer(
                        duration: 500.milliseconds,
                        height: 50.h,
                        width: state.pageIndex == 2
                            ? 333.w
                            : state.pageIndex == 1
                                ? 160.w
                                : 100.w,
                        decoration: BoxDecoration(
                            color: Palette.montraPurple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(color: Palette.montraPurple)),
                        child: Center(
                          child: 'Sign up'.txt(
                              size: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Palette.montraPurple),
                        )).tap(onTap: state.pageIndex == 2
                        ? (){
                          goToAndReplaceUnanimated(context: context, view: const SignUpView());
                        }
                        : (){}
                        ),
                  ),
                  20.sbH,

                  //! Action/Login Button
                  AnimatedContainer(
                    duration: 500.milliseconds,
                    height: 50.h,
                    width: state.pageIndex == 2
                        ? 333.w
                        : state.pageIndex == 1
                            ? 160.w
                            : 100.w,
                    decoration: BoxDecoration(
                      color: state.pageIndex == 1
                          ? Palette.whiteColor
                          : Palette.montraPurple,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Center(
                      child: state.pageIndex == 2
                          ? 'Login'.txt(
                              size: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: state.pageIndex == 1
                                  ? Palette.montraPurple
                                  : Palette.whiteColor,
                            )
                          : Icon(
                              Icons.keyboard_arrow_right_rounded,
                              size: 35.sp,
                              color: state.pageIndex == 1
                                  ? Palette.montraPurple
                                  : Palette.whiteColor,
                            ),
                    ),
                  ).tap(
                    onTap: () {
                      state.pageIndex.log();
                      if (state.pageIndex == 2) {
                        goToAndReplaceUnanimated(context: context, view: const LoginView());
                      } else {
                        context
                            .read<OnboardingBloc>()
                            .add(SwitchPageIndex(index: state.pageIndex + 1));
                        controller.animateToPage(
                          state.pageIndex + 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear,
                        );
                      }
                    },
                  )
                ],
              )),
            ],
          ),
        ),
      );
    });
  }
}
