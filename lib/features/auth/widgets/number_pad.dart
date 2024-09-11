import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NumberPad extends StatelessWidget {
  final Function(String) onNumberTap;

  const NumberPad({super.key, required this.onNumberTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 90,
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          if (index < 9) {
            return NumberPadButton(
                number: (index + 1).toString(), onTap: onNumberTap);
          } else if (index == 9) {
            return const SizedBox.shrink();
          } else if (index == 10) {
            return NumberPadButton(number: '0', onTap: onNumberTap);
          } else {
            return NumberPadButton(
                number: '<', isBackspace: true, onTap: onNumberTap);
          }
        },
      ),
    );
  }
}

class NumberPadButton extends StatelessWidget {
  final String number;
  final bool isBackspace;
  final Function(String) onTap;

  const NumberPadButton({
    super.key,
    required this.number,
    this.isBackspace = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(number),
              child: Center(
                child: isBackspace
                    ? Icon(
                        PhosphorIconsFill.backspace,
                        size: 30.sp,
                        color: Palette.whiteColor,
                      )
                    : number.txt(
                        size: 45.sp, color: Palette.whiteColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
