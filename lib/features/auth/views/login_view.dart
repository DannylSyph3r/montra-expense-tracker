import 'package:expense_tracker_app/features/auth/views/forgot_password_view.dart';
import 'package:expense_tracker_app/features/auth/views/pin_input_view.dart';
import 'package:expense_tracker_app/features/auth/views/sign_up_view.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/appbar.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/myicon.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier _passwordVisible = false.notifier;

  void passwordVisibility() => _passwordVisible.value = !_passwordVisible.value;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //! appBar
        appBar: customAppBar("Login",
            implyLeading: false,
            context: context,
            toolbarHeight: 60.h,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            isTitleCentered: true),
        body: Padding(
          padding: 15.padH,
          child: ListView(
            children: [
              Column(children: [
                30.sbH,

                //! textInput
                TextInputWidget(
                    hintText: AppTexts.emailFieldHint,
                    controller: _emailController),
                10.sbH,
                _passwordVisible.sync(builder: (context, isVisible, child) {
                  return TextInputWidget(
                    hintText: AppTexts.passwordFieldHint,
                    controller: _passwordController,
                    obscuretext: _passwordVisible.value,
                    suffixIcon: Padding(
                        padding: 15.padH,
                        child: Icon(
                          PhosphorIconsRegular.eye,
                          size: 25.h,
                          color: _passwordVisible.value == false
                              ? Palette.montraPurple
                              : Palette.greyColor,
                        )).tap(onTap: () {
                      passwordVisibility();
                    }),
                  );
                }),
                20.sbH,

                //! forgot Password
                "Forgot Password?"
                    .txt16(fontW: F.w6, color: Palette.montraPurple)
                    .alignCenterRight()
                    .tap(onTap: () {
                  goTo(context: context, view: const ForgotPasswordView());
                }),

                //! TOC checker

                20.sbH,

                //! sign Up Buttons
                AppButton(
                  onTap: () {
                    goTo(context: context, view: PinInputView());
                  },
                  text: "Login",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                10.sbH,
                "Or with".txt16(fontW: F.w7, color: Palette.greyColor),
                10.sbH,
                TransparentButton(
                  onTap: () {},
                  isText: false,
                  item: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MyIcon(icon: AppGraphics.googleIcon),
                        10.sbW,
                        "Login with Google".txt16(fontW: F.w6)
                      ]),
                ),
                30.sbH,

                //! switch to Login View

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: AppTexts.switchToSignup.toCapitalized(),
                    style: TextStyle(
                      color: Palette.greyColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            goToAndReplace(
                                context: context, view: const SignUpView());
                          },
                        text: " Sign Up",
                        style: TextStyle(
                          color: Palette.montraPurple,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ));
  }
}
