import 'package:expense_tracker_app/features/onboarding/views/new_account_view.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClusterSetupView extends StatelessWidget {
  const ClusterSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: 15.padH,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            80.sbH,
            SizedBox(
              width: 300.w,
              child: AppTexts.clusterMainInstruction1.txt(size: 35.sp, fontW: F.w6)).alignCenterLeft(),
            20.sbH,
            SizedBox(
              width: width(context)/1.5,
              child: AppTexts.clusterMainInstruction2
                  .txt(size: 16.sp, fontW: F.w3),
            ).alignCenterLeft(),
            50.sbH,
          ],
        ),

        //! sign Up Buttons
        Column(
          children: [
            AppButton(
              onTap: () {
                goTo(context: context, view: const NewAccountView());
              },
              text: "Let's Go",
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
