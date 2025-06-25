import 'package:expense_tracker_app/features/auth/views/login_view.dart';
import 'package:expense_tracker_app/features/auth/views/otp_verification_view.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/snack_bar.dart';
import 'package:expense_tracker_app/utils/type_defs.dart';
import 'package:expense_tracker_app/utils/widgets/appbar.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/myicon.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ValueNotifier _passwordVisible = false.notifier;
  final ValueNotifier _confirmPasswordVisible = false.notifier;
  final ValueNotifier _toc = false.notifier;
  final ValueNotifier<bool> _passwordsMatch = ValueNotifier<bool>(false);

  void passwordVisibility() => _passwordVisible.value = !_passwordVisible.value;
  void confirmPasswordVisibility() =>
      _confirmPasswordVisible.value = !_confirmPasswordVisible.value;
  void agreetoToc() => _toc.value = !_toc.value;

  void _checkPasswordMatch() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (confirmPassword.isEmpty) {
      _passwordsMatch.value = false;
      return;
    }

    _passwordsMatch.value = password == confirmPassword;
  }

  void _handleSignUp() {
    final fullname = _fullnameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      showBanner(
        context: context,
        theMessage: "Passwords do not match. Please check and try again.",
        theType: NotificationType.failure,
      );
      return;
    }

    if (fullname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showBanner(
        context: context,
        theMessage: "Please fill in all fields.",
        theType: NotificationType.failure,
      );
      return;
    }

    showBanner(
      context: context,
      theMessage: "Account created successfully!",
      theType: NotificationType.success,
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        goTo(
          context: context,
          view: OtpVerificationView(
            email: _emailController.text,
            fullName: _fullnameController.text,
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordMatch);
    _confirmPasswordController.addListener(_checkPasswordMatch);
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordVisible.dispose();
    _confirmPasswordVisible.dispose();
    _toc.dispose();
    _passwordsMatch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //! appBar
        appBar: customAppBar(
            title: "Sign Up",
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
                    hintText: AppTexts.nameFieldHint,
                    controller: _fullnameController),
                10.sbH,
                TextInputWidget(
                    hintText: AppTexts.emailFieldHint,
                    controller: _emailController),
                10.sbH,
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
                10.sbH,

                //! Confirm Password Field
                _confirmPasswordVisible.sync(
                    builder: (context, isVisible, child) {
                  return TextInputWidget(
                    hintText: AppTexts.confirmPasswordFieldHint,
                    controller: _confirmPasswordController,
                    obscuretext: !_confirmPasswordVisible.value,
                    suffixIcon: Padding(
                        padding: 15.padH,
                        child: Icon(
                          PhosphorIconsRegular.eye,
                          size: 25.h,
                          color: _confirmPasswordVisible.value == true
                              ? Palette.montraPurple
                              : Palette.greyColor,
                        )).tap(onTap: () {
                      confirmPasswordVisibility();
                    }),
                  );
                }),

                //! Password Match Indicator
                ValueListenableBuilder<bool>(
                  valueListenable: _passwordsMatch,
                  builder: (context, passwordsMatch, child) {
                    if (_confirmPasswordController.text.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            passwordsMatch
                                ? PhosphorIconsBold.checkCircle
                                : PhosphorIconsBold.xCircle,
                            size: 16.h,
                            color: passwordsMatch
                                ? Palette.greenColor
                                : Palette.redColor,
                          ),
                          8.sbW,
                          Text(
                            passwordsMatch
                                ? "Passwords match"
                                : "Passwords don't match",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: passwordsMatch
                                  ? Palette.greenColor
                                  : Palette.redColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                20.sbH,

                //! TOC checker
                Row(
                  children: [
                    _toc.sync(
                        builder: (context, value, child) => Container(
                              height: 22.w,
                              width: 22.w,
                              decoration: BoxDecoration(
                                color: _toc.value == true
                                    ? Palette.montraPurple
                                    : null,
                                borderRadius: BorderRadius.circular(3.r),
                                border: Border.all(
                                  width: 1.5,
                                  color: Palette.montraPurple,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  PhosphorIconsRegular.check,
                                  size: 14.sp,
                                  color: Palette.whiteColor,
                                ),
                              ),
                            ).tap(
                              onTap: () {
                                _toc.value = !_toc.value;
                              },
                            )),
                    10.sbW,
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: AppTexts.proceeding.toCapitalized(),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Palette.greyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: [
                            TextSpan(
                              text: AppTexts.terms,
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
                    ),
                  ],
                ),
                30.sbH,

                //! sign Up Buttons
                AppButton(
                  onTap: _handleSignUp,
                  text: "Sign Up",
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
                        "Sign Up with Google".txt16(fontW: F.w6)
                      ]),
                ),
                30.sbH,

                //! switch to Login View

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: AppTexts.switchToLogin.toCapitalized(),
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
                                context: context, view: const LoginView());
                          },
                        text: " Login",
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
