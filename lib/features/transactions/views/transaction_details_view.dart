import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/dotted_divider.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:expense_tracker_app/utils/widgets/serrated_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TransactionsDetailsView extends StatefulWidget {
  const TransactionsDetailsView({super.key});

  @override
  State<TransactionsDetailsView> createState() =>
      _TransactionsDetailsViewState();
}

class _TransactionsDetailsViewState extends State<TransactionsDetailsView> {
  final ValueNotifier<int> _imageCarouselIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _imageCarouselIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Palette.montraPurple,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Positioned(
                    top: -5,
                    left: -5,
                    child: AppGraphics.eclipses.png.myImage(
                      height: 200.h,
                    ),
                  ),
                  Column(
                    children: [
                      50.sbH,
                      RowRailer(
                        rowPadding: 20.padH,
                        leading: const Icon(PhosphorIconsBold.arrowLeft,
                                color: Palette.whiteColor)
                            .tap(onTap: () {
                          goBack(context);
                        }),
                        middle: "Transaction Details"
                            .txt16(color: Palette.whiteColor, fontW: F.w5),
                        trailing: const Icon(PhosphorIconsFill.trash,
                                color: Palette.whiteColor)
                            .tap(onTap: () {
                          showCustomModal(context,
                              modalHeight: 230.h,
                              child: Padding(
                                padding: 15.padH,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    "Remove this Transaction?".txt16(),
                                    15.sbH,
                                    AppTexts.removeTransactionConfirmation
                                        .txt14(
                                            color: Palette.greyColor,
                                            textAlign: TextAlign.center),
                                    20.sbH,
                                    Row(
                                      children: [
                                        Expanded(
                                            child: AppButton(
                                                color: Palette.montraPurple
                                                    .withOpacity(0.2),
                                                text: "No",
                                                textColor: Palette.montraPurple,
                                                onTap: () {})),
                                        15.sbW,
                                        Expanded(
                                            child: AppButton(
                                                text: "Yes", onTap: () {})),
                                      ],
                                    )
                                  ],
                                ),
                              ));
                        }),
                      ),
                      50.sbH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "N5,555,555.00".txt(
                            size: 30.sp,
                            fontW: F.w8,
                            color: Palette.whiteColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      30.sbH
                    ],
                  ),
                  Column(
                    children: [
                      245.sbH,
                      CustomPaint(
                        size: Size(double.infinity, 60.h),
                        painter: SerratedPainter(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Palette.whiteColor,
                            border: Border.all(
                                color: Palette.whiteColor, width: 1)),
                        constraints: BoxConstraints(
                          minHeight: height(context) - 250.h,
                          minWidth: double.infinity,
                        ),
                        child: Padding(
                          padding: 20.padH,
                          child: Column(
                            children: [
                              DottedLineDivider(
                                color: Palette.offGrey,
                                dashWidth: 7.w,
                                dashSpace: 8.w,
                              ),
                              30.sbH,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Type".txt14(
                                      color: Palette.greyColor, fontW: F.w6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        PhosphorIconsFill.circle,
                                        color: Colors.green,
                                        size: 14.sp,
                                      ),
                                      5.sbW,
                                      "Income".txt14()
                                    ],
                                  ),
                                ],
                              ),
                              10.sbH,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Category".txt14(
                                      color: Palette.greyColor, fontW: F.w6),
                                  "Groceries".txt14()
                                ],
                              ),
                              10.sbH,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Time".txt14(
                                      color: Palette.greyColor, fontW: F.w6),
                                  "10:00AM".txt14()
                                ],
                              ),
                              10.sbH,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Date".txt14(
                                      color: Palette.greyColor, fontW: F.w6),
                                  "Sunday 14 August, 2024".txt14()
                                ],
                              ),
                              30.sbH,
                              DottedLineDivider(
                                color: Palette.offGrey,
                                dashWidth: 7.w,
                                dashSpace: 8.w,
                              ),
                              30.sbH,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Description".txt14(
                                      color: Palette.greyColor, fontW: F.w6),
                                  "Brought Groceries from store".txt14()
                                ],
                              ),
                              10.sbH,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Base Amount".txt14(
                                      color: Palette.greyColor, fontW: F.w6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      "N5,555,000.00".txt(
                                        size: 14.sp,
                                        fontW: F.w8,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              10.sbH,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Transaction Fee".txt14(
                                      color: Palette.greyColor, fontW: F.w6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      "N555.00".txt(
                                        size: 14.sp,
                                        fontW: F.w8,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              10.sbH,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Total".txt14(
                                      color: Palette.greyColor, fontW: F.w6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      "N5,555,555.00".txt(
                                        size: 14.sp,
                                        fontW: F.w8,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              30.sbH,
                              DottedLineDivider(
                                color: Palette.offGrey,
                                dashWidth: 7.w,
                                dashSpace: 8.w,
                              ),
                              30.sbH,
                              "Attachment"
                                  .txt14(color: Palette.greyColor, fontW: F.w6)
                                  .alignCenterLeft(),
                              10.sbH,
                              FlutterCarousel(
                                items: List.generate(
                                  4,
                                  (index) => AppGraphics.invoice.jpg.myImage(
                                    fit: BoxFit.cover,
                                    height: 180.h,
                                    width: double.infinity,
                                  ),
                                ),
                                options: CarouselOptions(
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 4),
                                  viewportFraction: 1.0,
                                  initialPage: 2,
                                  showIndicator: false,
                                  height: 180.h,
                                  onPageChanged: (int index,
                                      CarouselPageChangedReason reason) {
                                    _imageCarouselIndexNotifier.value = index;
                                  },
                                ),
                              ),
                              30.sbH,
                              DottedLineDivider(
                                color: Palette.offGrey,
                                dashWidth: 7.w,
                                dashSpace: 8.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Transform.scale(
                        scaleY: -1,
                        child: CustomPaint(
                          size: Size(double.infinity, 60.h),
                          painter: SerratedPainter(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
