import 'dart:io';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DocPickerModalBottomSheet extends StatefulWidget {
  final String headerText;
  final Color? color;
  final String descriptionText;
  final VoidCallback onTakeDocPicture;

  const DocPickerModalBottomSheet({
    super.key,
    required this.headerText,
    this.color,
    required this.descriptionText,
    required this.onTakeDocPicture,
  });

  @override
  State<DocPickerModalBottomSheet> createState() =>
      _DocPickerModalBottomSheetState();
}

class _DocPickerModalBottomSheetState extends State<DocPickerModalBottomSheet> {
  File? docPicture;

  void takeDocPicture() async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    
    if (!mounted) return;
    
    if (image == null) {
      return;
    }

    final imageTemp = File(image.path);
    widget.onTakeDocPicture();

    setState(() => docPicture = imageTemp);
  } on PlatformException catch (e) {
    'Failed to pick image file :(: $e'.log();
    
    if (!mounted) return;
    
    showSnackBar(
      context: context,
      text: 'An error occurred',
    );
  }
}

Future<void> pickImage() async {
  try {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    
    if (!mounted) return;

    if (result == null || result.files.isEmpty) {
      return;
    }

    final fileTemp = File(result.files.single.path!);
    widget.onTakeDocPicture();

    setState(() => docPicture = fileTemp);
  } catch (e) {
    if (!mounted) return;
    
    showSnackBar(
      context: context,
      text: 'An error occurred while picking the file',
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        widget.color ?? (isDarkMode ? Palette.blackColor : Palette.whiteColor);
    return Container(
      height: 370.h,
      width: width(context),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: Padding(
        padding: 20.padH,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                20.sbH,
                Container(
                  width: 60.w,
                  height: 4.h,
                  decoration: ShapeDecoration(
                    color: Palette.montraPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                20.sbH,
                widget.headerText.txt(size: 18.sp, fontW: F.w7),
                20.sbH,
                widget.descriptionText
                    .txt(size:14.sp, maxLines: 4, overflow: TextOverflow.ellipsis),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150.h,
                      width: 150.h,
                      decoration: BoxDecoration(
                          color: Palette.montraPurple,
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.r))),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            PhosphorIconsFill.camera,
                            size: 50.h,
                            color: Palette.whiteColor,
                          ),
                          10.sbH,
                          "Take Photo".txt(size:12.sp, color: Palette.whiteColor)
                        ],
                      )),
                    ).tap(onTap: () {
                      takeDocPicture();
                    }),
                    30.sbW,
                    Container(
                      height: 150.h,
                      width: 150.h,
                      decoration: BoxDecoration(
                          color: Palette.greyFill,
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.r))),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            PhosphorIconsFill.images,
                            size: 50.h,
                            color: Palette.greyColor,
                          ),
                          10.sbH,
                          "Choose Images".txt(size: 12.sp,
                            color: Palette.greyColor,
                          )
                        ],
                      )),
                    ).tap(onTap: () {
                      pickImage();
                    })
                  ],
                ),
                40.sbH
              ],
            )
          ],
        ),
      ),
    );
  }
}
