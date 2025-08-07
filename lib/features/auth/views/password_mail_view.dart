import 'package:expense_tracker_app/features/auth/views/login_view.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordMailView extends StatelessWidget {
  const PasswordMailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: 15.padH,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [

            //! Mail Asset
            AppGraphics.forgotPassword.png.myImage(
              height: 400.h,
            ),
            30.sbH,

            //! Confirmation Text
            AppTexts.mailConfirmation.txt(size: 26.sp, fontW: F.w6, textAlign: TextAlign.center),
            30.sbH,

            //! Content
            "Check your email test@test.com and follow the instructions to reset your password"
                .txt(size: 16.sp, fontW: F.w4, textAlign: TextAlign.center),
            50.sbH,
          ],
        ),

        //! Action Button
        Column(
          children: [
            AppButton(
              onTap: () {
                goToAndReplace(context: context, view: const LoginView());
              },
              text: "Back to Login",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            40.sbH
          ],
        ),
      ]),
    ));
  }
}
