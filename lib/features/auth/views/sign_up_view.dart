import 'dart:async';
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
import 'package:flutter_animate/flutter_animate.dart';
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
  final ValueNotifier<bool> _showPasswordFeedback = ValueNotifier<bool>(false);

  Timer? _passwordMatchTimer;

  void passwordVisibility() => _passwordVisible.value = !_passwordVisible.value;
  void confirmPasswordVisibility() =>
      _confirmPasswordVisible.value = !_confirmPasswordVisible.value;
  void agreetoToc() => _toc.value = !_toc.value;

  void _checkPasswordMatch() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Cancel any existing timer
    _passwordMatchTimer?.cancel();

    // Hide feedback if either field is empty
    if (password.isEmpty || confirmPassword.isEmpty) {
      _showPasswordFeedback.value = false;
      return;
    }

    // Check if passwords match
    bool passwordsMatch = password == confirmPassword;

    if (passwordsMatch) {
      // Show "match" immediately
      _passwordsMatch.value = true;
      _showPasswordFeedback.value = true;
    } else {
      // Show "don't match" after 1 second delay
      _passwordMatchTimer = Timer(1.seconds, () {
        _passwordsMatch.value = false;
        _showPasswordFeedback.value = true;
      });
    }
  }

  //! Validation Function for Sign up
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

  //! Password Match Indicator
  Widget _buildPasswordMatchIndicator() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showPasswordFeedback,
      builder: (context, showFeedback, child) {
        if (!showFeedback) {
          return const SizedBox.shrink();
        }

        return ValueListenableBuilder<bool>(
          valueListenable: _passwordsMatch,
          builder: (context, passwordsMatch, child) {
            return Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Row(
                children: [
                  Icon(
                    passwordsMatch
                        ? PhosphorIconsBold.checkCircle
                        : PhosphorIconsBold.xCircle,
                    size: 16.h,
                    color:
                        passwordsMatch ? Palette.greenColor : Palette.redColor,
                  ),
                  8.sbW,
                  Text(
                    passwordsMatch
                        ? "Passwords match"
                        : "Passwords do not match",
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
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordMatch);
    _confirmPasswordController.addListener(_checkPasswordMatch);
  }

  @override
  void dispose() {
    _passwordMatchTimer?.cancel();
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordVisible.dispose();
    _confirmPasswordVisible.dispose();
    _toc.dispose();
    _passwordsMatch.dispose();
    _showPasswordFeedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //! AppBar
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

                //! Text Input (Full Name)
                TextInputWidget(
                    hintText: AppTexts.nameFieldHint,
                    controller: _fullnameController),
                10.sbH,

                //! Text Input (Email)
                TextInputWidget(
                    hintText: AppTexts.emailFieldHint,
                    controller: _emailController),
                10.sbH,

                //! Password Field
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
                _buildPasswordMatchIndicator(),

                20.sbH,

                //! TOC (Terms and Conditions) checker
                _toc.sync(builder: (context, tocAccepted, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Icon(
                          tocAccepted
                              ? PhosphorIconsBold.checkSquare
                              : PhosphorIconsRegular.square,
                          size: 20.h,
                          color: tocAccepted
                              ? Palette.montraPurple
                              : Palette.greyColor,
                        ),
                      ).tap(onTap: () {
                        agreetoToc();
                      }),
                      8.sbW,
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "By signing up, you agree to the ",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Palette.greyColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            children: [
                              TextSpan(
                                text: "Terms of Service",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Palette.montraPurple,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: " and ",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Palette.greyColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: "Privacy Policy",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Palette.montraPurple,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                20.sbH,

                //! Sign Up Buttons
                AppButton(
                  onTap: () {
                    _handleSignUp();
                  },
                  text: "Sign Up",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                15.sbH,

                "Or".txt(size: 14.sp, fontW: F.w7, color: Palette.greyColor),
                15.sbH,

                TransparentButton(
                  onTap: () {},
                  isText: false,
                  item: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MyIcon(icon: AppGraphics.googleIcon),
                        10.sbW,
                        "Sign up with Google".txt(size: 16.sp, fontW: F.w4)
                      ]),
                ),
                30.sbH,

                //! Switch to Login View
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Already have an account?",
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
