import 'package:expense_tracker_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? radius;
  final void Function()? onTap;
  final Color? color;
  final Widget? item;
  final String? text;
  final bool isText;
  final Color? textColor;
  final bool isEnabled;
  final bool? spanScreen;

  const AppButton({
    Key? key,
    this.isEnabled = true,
    this.spanScreen = true,
    this.height,
    this.width,
    this.fontSize,
    this.radius,
    required this.onTap,
    this.color,
    this.item,
    this.text,
    this.isText = true,
    this.textColor,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50.h,
      width: spanScreen == true ? double.infinity : 200.w,
      child: ElevatedButton(
        onPressed: isEnabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? 10.r),
            ),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
          shadowColor: Colors.black,
          backgroundColor: color ?? Palette.montraPurple,
        ),
        child: Center(
          child: isText == true
              ? Text(text ?? '',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontSize: fontSize ?? 14.sp,
                      fontWeight: fontWeight ?? FontWeight.w600,
                      color: textColor ?? Palette.whiteColor,
                    ),
                  ))
              : item,
        ),
      ),
    );
  }
}

class ArrowButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? radius;
  final void Function()? onTap;
  final Color? color;
  final Widget? item;
  final String? text;
  final bool isText;
  final Color? textColor;
  const ArrowButton({
    Key? key,
    this.height,
    this.width,
    this.fontSize,
    this.radius,
    required this.onTap,
    this.color,
    this.item,
    this.text,
    this.isText = true,
    this.textColor,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 56.h,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? 12.r),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 21.w),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: color ?? Palette.greyColor,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text ?? '',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: fontSize ?? 18.sp,
                    fontWeight: fontWeight ?? FontWeight.w500,
                    color: textColor ?? Palette.whiteColor,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: Palette.whiteColor,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransparentButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final void Function()? onTap;
  final Color? outlineColor;
  final Widget? item;
  final String? text;
  final bool isText;
  final Color? backgroundColor;
  final Color? textColor;
  
  const TransparentButton({
    Key? key,
    this.height,
    this.width,
    this.radius,
    required this.onTap,
    this.outlineColor,
    this.item,
    this.text,
    this.isText = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50.h,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.5,
              color: outlineColor ?? Colors.black,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? 10.r),
            ),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: backgroundColor ?? Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: isText == true
              ? Text(
                  text ?? '',
                  style: TextStyle(
                    fontSize: fontSize ?? 16.sp,
                    fontWeight: fontWeight ?? FontWeight.w500,
                    color: textColor ?? Palette.blackColor,
                  ),
                )
              : item,
        ),
      ),
    );
  }
}

// class GButton extends ConsumerWidget {
//   final bool? isFromLogin;
//   const GButton({
//     Key? key,
//     this.isFromLogin,
//   }) : super(key: key);

//   void signInWithGoogle(
//       {required BuildContext context, required WidgetRef ref}) {
//     ref
//         .read(authControllerProvider.notifier)
//         .signInWithGoogle(context: context);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentTheme = ref.watch(themeNotifierProvider);
//     return ClickButton(
//       onTap: () => signInWithGoogle(context: context, ref: ref),
//       child: Row(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           60.sbW,
//           MyIcon(icon: AppGrafiks.google, height: 20.h),
//           15.sbW,
//           Text(
//             'Continue With Google',
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AppleButton extends ConsumerWidget {
//   final bool? isFromLogin;
//   const AppleButton({
//     Key? key,
//     this.isFromLogin,
//   }) : super(key: key);

//   void signInWithGoogle(
//       {required BuildContext context, required WidgetRef ref}) {
//     ref
//         .read(authControllerProvider.notifier)
//         .signInWithGoogle(context: context);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentTheme = ref.watch(themeNotifierProvider);
//     return ClickButton(
//       onTap: () => signInWithGoogle(context: context, ref: ref),
//       child: Row(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           60.sbW,
//           Image.asset(
//             'apple'.png,
//             height: 23.h,
//             color: currentTheme.textTheme.bodyMedium!.color,
//           ),
//           15.sbW,
//           Text(
//             'Continue With Apple',
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class TTransparentButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? padding;
  final void Function()? onTap;
  final Color color;
  final Widget child;
  const TTransparentButton({
    Key? key,
    this.height,
    this.width,
    this.padding,
    required this.onTap,
    required this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 33.3.h,
      width: 40.w,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: color,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(5.r),
              ),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(
              vertical: padding ?? 0,
            )),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
