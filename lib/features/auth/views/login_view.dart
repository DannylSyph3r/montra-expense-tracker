import 'package:expense_tracker_app/features/auth/views/forgot_password_view.dart';
import 'package:expense_tracker_app/features/auth/views/sign_up_view.dart';
import 'package:expense_tracker_app/features/base_nav/wrapper/base_nav_wrapper.dart';
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
import 'package:google_fonts/google_fonts.dart';
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
        //! AppBar
        appBar: customAppBar(
            title: "Login",
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

                //! Text Input (Email)
                TextInputWidget(
                    hintText: AppTexts.emailFieldHint,
                    controller: _emailController),
                10.sbH,
                //! Text Input (Password)
                _passwordVisible.sync(builder: (context, isVisible, child) {
                  return TextInputWidget(
                    hintText: AppTexts.passwordFieldHint,
                    controller: _passwordController,
                    obscuretext: !_passwordVisible.value,
                    suffixIcon: Padding(
                        padding: 15.padH,
                        child: Icon(
                          PhosphorIconsRegular.eye,
                          size: 25.h,
                          color: _passwordVisible.value == true
                              ? Palette.montraPurple
                              : Palette.greyColor,
                        )).tap(onTap: () {
                      passwordVisibility();
                    }),
                  );
                }),
                20.sbH,

                //! forgot Password?
                "Forgot Password?"
                    .txt(size:14.sp, fontW: F.w6, color: Palette.montraPurple)
                    .alignCenterRight()
                    .tap(onTap: () {
                  goTo(context: context, view: const ForgotPasswordView());
                }),
                20.sbH,

                //! Login Button
                AppButton(
                  onTap: () {
                    goToAndReset(context: context, view: const BaseNavWrapper());
                  },
                  text: "Login",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                15.sbH,
                "Or".txt(size: 14.sp, fontW: F.w7, color: Palette.greyColor),
                15.sbH,

                //! Google Login Button
                TransparentButton(
                  onTap: () {},
                  isText: false,
                  item: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MyIcon(icon: AppGraphics.googleIcon),
                        10.sbW,
                        "Login with Google".txt(size: 16.sp, fontW: F.w6)
                      ]),
                ),
                30.sbH,

                //! Switch to Sign up
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: AppTexts.switchToSignup.toCapitalized(),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Palette.greyColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            goToAndReplace(
                                context: context, view: const SignUpView());
                          },
                        text: " Sign Up",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Palette.montraPurple,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
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
