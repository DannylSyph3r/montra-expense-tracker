import 'package:expense_tracker_app/features/auth/views/password_mail_view.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/appbar.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //! AppBar
        appBar: customAppBar(
            title: "Forgot Password",
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
                AppTexts.forgotPassword1
                    .txt(size: 24.sp, fontW: F.w6)
                    .alignCenterLeft(),
                15.sbH,
                AppTexts.forgotPassword2.txt(size: 16.sp, fontW: F.w4),
                50.sbH,

                //! Text Input (Email)
                TextInputWidget(
                    hintText: AppTexts.emailFieldHint,
                    controller: _emailController),
                10.sbH,

                //! Action Button
                AppButton(
                  onTap: () {
                    goToAndReset(context: context, view: const PasswordMailView());
                  },
                  text: "Continue",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                30.sbH,
              ]),
            ],
          ),
        ));
  }
}
