// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/keyboard_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInputWidget extends StatelessWidget {
  final bool? isTextFieldEnabled;
  final double? height;
  final double prefixIconDeimension;
  final double suffixIconDeimension;
  final double? width;
  final double? inputtedTextSize;
  final String hintText;
  final double? hintTextSize;
  final TextEditingController controller;
  final bool obscuretext;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffix;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Color? titleColor;
  final Color? borderColor;
  final FontWeight? titleFontWeight;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final Widget? iconn;
  final int? maxLength;
  final void Function()? onEditingComplete;
  final TextCapitalization? textCapitalization;
  final bool? readOnly;
  final Widget? prefix;
  final bool? autofocus;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  const TextInputWidget({
    Key? key,
    this.isTextFieldEnabled,
    this.height,
    this.prefixIconDeimension = 20,
    this.suffixIconDeimension = 20,
    this.width,
    this.inputtedTextSize,
    required this.hintText,
    this.hintTextSize,
    required this.controller,
    this.obscuretext = false,
    this.validator,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.suffix,
    this.focusNode,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
    this.titleColor,
    this.borderColor,
    this.titleFontWeight,
    this.onTap,
    this.onTapOutside,
    this.iconn,
    this.maxLength,
    this.onEditingComplete,
    this.textCapitalization,
    this.readOnly,
    this.prefix,
    this.autofocus,
    this.textAlign,
    this.contentPadding,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: SizedBox(
        height: height ?? 60.h,
        width: double.infinity,
        child: TextFormField(
          enabled: isTextFieldEnabled,
          maxLines: maxLines ?? 1,
          textAlign: textAlign ?? TextAlign.start,
          autofocus: autofocus ?? false,
          readOnly: readOnly ?? false,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          onEditingComplete: onEditingComplete,
          maxLength: maxLength,
          onTap: onTap,
          onTapOutside: onTapOutside ??
              (event) {
                dropKeyboard(context);
              },
          keyboardType: keyboardType,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: inputtedTextSize ?? 14.sp,
              color: Palette.blackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          controller: controller,
          inputFormatters: inputFormatters,
          obscureText: obscuretext,
          //obscuringCharacter: '*',
          cursorColor: Colors.black,
          decoration: InputDecoration(
            prefixIcon: prefix,
            prefixIconConstraints: BoxConstraints(
                minHeight: prefixIconDeimension.h,
                minWidth: prefixIconDeimension.w),
            // isDense: true,
            suffix: suffix,
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(vertical: 10.w).copyWith(left: 18.w),
            helperText: " ",
            helperStyle: const TextStyle(fontSize: 0.0005),
            errorStyle: const TextStyle(fontSize: 0.0005),
            suffixIcon: suffixIcon,
            suffixIconConstraints: BoxConstraints(
                minHeight: suffixIconDeimension.h,
                minWidth: suffixIconDeimension.w),
            hintText: hintText,
            fillColor: Palette.whiteColor,
            filled: true,
            hintStyle: GoogleFonts.inter(
              textStyle: TextStyle(
                fontSize: hintTextSize ?? 15.sp,
                color: Palette.greyColor,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Palette.textFieldGrey),
              borderRadius: BorderRadius.circular(15.r),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Palette.textFieldGrey),
              borderRadius: BorderRadius.circular(15.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Palette.textFieldGrey),
              borderRadius: BorderRadius.circular(15.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Palette.montraPurple),
              borderRadius: BorderRadius.circular(15.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Palette.redColor),
              borderRadius: BorderRadius.circular(15.r),
            ),
          ),
          validator: validator,
        ),
      ),
    );
  }
}

// class NewTextInput extends ConsumerWidget {
//   final TextEditingController controller;
//   final bool obscuretext;
//   final FormFieldValidator<String>? validator;
//   final Widget? suffixIcon;
//   final void Function(String)? onFieldSubmitted;
//   final Widget? suffix;
//   final FocusNode? focusNode;
//   final TextInputType? keyboardType;
//   final void Function(String)? onChanged;
//   final List<TextInputFormatter>? inputFormatters;
//   final Color? titleColor;
//   final Color? borderColor;
//   final FontWeight? titleFontWeight;
//   final void Function()? onTap;
//   final void Function(PointerDownEvent)? onTapOutside;
//   final Widget? iconn;
//   final int? maxLength;
//   final int? maxLines;
//   final String hintText;
//   final Widget? prefixIcon;
//   final String? suffixText;
//   final String? prefixText;
//   const NewTextInput({
//     Key? key,
//     required this.controller,
//     this.obscuretext = false,
//     this.validator,
//     this.suffixIcon,
//     this.onFieldSubmitted,
//     this.suffix,
//     this.focusNode,
//     this.keyboardType,
//     this.onChanged,
//     this.inputFormatters,
//     this.titleColor,
//     this.borderColor,
//     this.titleFontWeight,
//     this.onTap,
//     this.onTapOutside,
//     this.iconn,
//     this.maxLength,
//     this.maxLines,
//     required this.hintText,
//     this.prefixIcon,
//     this.suffixText,
//     this.prefixText,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SizedBox(
//       height: 40.h,
//       width: 250,
//       child: TextFormField(
//         // textAlign: TextAlign.center,
//         maxLines: maxLines,
//         maxLength: maxLength,
//         onTap: onTap,
//         onTapOutside: onTapOutside,
//         keyboardType: keyboardType,
//         focusNode: focusNode,
//         onFieldSubmitted: onFieldSubmitted,
//         onChanged: onChanged,
//         style: TextStyle(
//           fontSize: 15.sp,
//           fontFamily: AppTexts.appFont,
//         ),
//         controller: controller,
//         inputFormatters: inputFormatters,
//         obscureText: obscuretext,
//         obscuringCharacter: '*',
//         cursorColor: Colors.black,
//         decoration: InputDecoration(
//           prefixIcon: prefixIcon,
//           isDense: true,
//           suffix: suffix,
//           contentPadding:
//               EdgeInsets.symmetric(vertical: 10.w).copyWith(left: 12.w),
//           helperText: " ",
//           helperStyle: const TextStyle(fontSize: 0.0005),
//           errorStyle: const TextStyle(fontSize: 0.0005),
//           suffixText: suffixText,
//           suffixIcon: suffixIcon,
//           suffixIconConstraints:
//               BoxConstraints(minHeight: 20.h, minWidth: 20.w),
//           hintText: hintText,
//           hintStyle: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w500,
//             color: Palette.textFieldGrey,
//             fontFamily: AppTexts.appFont,
//           ),
//           border: OutlineInputBorder(
//             borderSide: const BorderSide(color: Palette.textFieldGrey),
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Palette.textFieldGrey),
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Palette.textFieldGrey),
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.red),
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Palette.textFieldGrey),
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//         ),
//         validator: validator,
//       ),
//     );
//   }
// }
