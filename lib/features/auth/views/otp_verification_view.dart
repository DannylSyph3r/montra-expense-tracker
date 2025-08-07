import 'dart:async';
import 'package:expense_tracker_app/features/auth/views/pin_input_view.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/snack_bar.dart';
import 'package:expense_tracker_app/utils/type_defs.dart';
import 'package:expense_tracker_app/utils/widgets/appbar.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OtpVerificationView extends StatefulWidget {
  final String email;
  final String fullName;
  const OtpVerificationView({
    super.key,
    required this.email,
    required this.fullName,
  });

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  final ValueNotifier<int> _remainingTimeNotifier = ValueNotifier<int>(60);
  final ValueNotifier<bool> _canResendNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isVerifyingNotifier = ValueNotifier<bool>(false);

  Timer? _timer;
  final String _correctOtp = "12345"; // Mock OTP for demonstration

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingTimeNotifier.value = 60;
    _canResendNotifier.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeNotifier.value > 0) {
        _remainingTimeNotifier.value--;
      } else {
        _canResendNotifier.value = true;
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    //! Rend OTP logic here
    showBanner(
      context: context,
      theMessage: "OTP code sent successfully to ${widget.email}",
      theType: NotificationType.success,
    );
    _startTimer();
  }

void _verifyOtp() async {
  final enteredOtp = _otpController.text;

  if (enteredOtp.length != 5) {
    showBanner(
      context: context,
      theMessage: "Please enter the complete 5-digit code",
      theType: NotificationType.failure,
    );
    return;
  }

  _isVerifyingNotifier.value = true;

  // Simulate API call delay
  await Future.delayed(const Duration(seconds: 2));

  if (!mounted) return;

  _isVerifyingNotifier.value = false;

  if (enteredOtp == _correctOtp) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      goToAndReset(context: context, view: const PinInputView());
    });
  } else {
    showBanner(
      context: context,
      theMessage: "Invalid verification code. Please try again.",
      theType: NotificationType.failure,
    );
    _otpController.clear();
  }
}

  String _getFirstName(String fullName) {
    // Extract first name and handle lengthy names
    final nameParts = fullName.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : fullName;

    // Truncate if too long (more than 12 characters)
    if (firstName.length > 12) {
      return '${firstName.substring(0, 12)}...';
    }

    return firstName;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    _remainingTimeNotifier.dispose();
    _canResendNotifier.dispose();
    _isVerifyingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 24.sp,
        color: Palette.blackColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Palette.greyFill,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Palette.greyColor.withValues(alpha: 0.3)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Palette.montraPurple, width: 2),
      color: Palette.whiteColor,
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Palette.montraPurple.withValues(alpha: 0.1),
        border: Border.all(color: Palette.montraPurple),
      ),
    );

    return Scaffold(

      //! AppBar
      appBar: customAppBar(
        title: "Email Verification",
        context: context,
        toolbarHeight: 60.h,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        isTitleCentered: true,
      ),
      body: SingleChildScrollView(
        padding: 20.padH,
        child: Column(
          children: [
            Column(
              children: [
                30.sbH,

                // Animated Envelope Icon
                Container(
                  height: 100.h,
                  width: 100.h,
                  decoration: BoxDecoration(
                    color: Palette.montraPurple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIconsBold.envelopeSimple,
                    size: 60.h,
                    color: Palette.montraPurple,
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 2000.ms,
                      color: const Color(0xFFE879F9),
                    )
                    .then(delay: 500.ms)
                    .shake(
                      duration: 600.ms,
                      hz: 2,
                      offset: const Offset(2, 0),
                    )
                    .then(delay: 1500.ms)
                    .scale(
                      duration: 400.ms,
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.1, 1.1),
                    )
                    .then()
                    .scale(
                      duration: 400.ms,
                      begin: const Offset(1.1, 1.1),
                      end: const Offset(1.0, 1.0),
                    ),
                20.sbH,

                // Title - Personal greeting
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Hey ",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Palette.blackColor,
                      fontWeight: FontWeight.w400,
                      fontFamily:
                          Theme.of(context).textTheme.bodyLarge?.fontFamily,
                    ),
                    children: [
                      TextSpan(
                        text: _getFirstName(widget.fullName),
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Palette.montraPurple,
                          fontWeight: FontWeight.w700,
                          fontFamily:
                              Theme.of(context).textTheme.bodyLarge?.fontFamily,
                        ),
                      ),
                      TextSpan(
                        text: " :)\nPlease check your email!",
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Palette.blackColor,
                          fontWeight: FontWeight.w600,
                          fontFamily:
                              Theme.of(context).textTheme.bodyLarge?.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                50.sbH,

                // Description
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "We've sent a 5-digit verification code to\n",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Palette.greyColor,
                      fontWeight: FontWeight.w400,
                      fontFamily:
                          Theme.of(context).textTheme.bodyLarge?.fontFamily,
                    ),
                    children: [
                      TextSpan(
                        text: widget.email,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Palette.montraPurple,
                          fontWeight: FontWeight.w600,
                          fontFamily:
                              Theme.of(context).textTheme.bodyLarge?.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                30.sbH,

                // OTP Input
                Pinput(
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  length: 5,
                  autofocus: false,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showCursor: true,
                  cursor: Container(
                    height: 24.h,
                    width: 2.w,
                    color: Palette.montraPurple,
                  ),
                  onCompleted: (pin) {
                    // Auto verify when all 5 digits are entered
                    _verifyOtp();
                  },
                ),
                30.sbH,

                // Timer and Resend
                ValueListenableBuilder<bool>(
                  valueListenable: _canResendNotifier,
                  builder: (context, canResend, child) {
                    return ValueListenableBuilder<int>(
                      valueListenable: _remainingTimeNotifier,
                      builder: (context, remainingTime, child) {
                        if (canResend) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              "Didn't receive the code? ".txt(
                                size: 14.sp,
                                color: Palette.greyColor,
                              ),
                              "Resend"
                                  .txt(
                                    size: 14.sp,
                                    color: Palette.montraPurple,
                                    fontW: F.w6,
                                  )
                                  .tap(onTap: _resendOtp),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              "Resend code in ".txt(
                                size: 14.sp,
                                color: Palette.greyColor,
                              ),
                              _formatTime(remainingTime).txt(
                                size: 14.sp,
                                color: Palette.montraPurple,
                                fontW: F.w6,
                              ),
                            ],
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),

            // Space to push buttons down but allow scrolling
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),

            // Action Button
            Column(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _isVerifyingNotifier,
                  builder: (context, isVerifying, child) {
                    return AppButton(
                      onTap: isVerifying ? null : _verifyOtp,
                      text: isVerifying ? "Verifying..." : "Verify Email",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      isEnabled: !isVerifying,
                    );
                  },
                ),
                15.sbH,

                // Back to sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    "Wrong email? ".txt(size: 14.sp, color: Palette.greyColor),
                    "Change email"
                        .txt(
                      size: 14.sp,
                      color: Palette.montraPurple,
                      fontW: F.w6,
                    )
                        .tap(onTap: () {
                      goBack(context);
                    }),
                  ],
                ),
                40.sbH,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
