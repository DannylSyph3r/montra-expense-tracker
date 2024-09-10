import 'dart:ui';
import 'package:expense_tracker_app/features/home/widgets/curved_painter.dart';
import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:expense_tracker_app/utils/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ValueNotifier _privacyFilter = false.notifier;

  @override
  void dispose() {
    _privacyFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.montraPurple.withOpacity(0.94),
      body: CustomScrollView(
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
                    60.sbH,
                    RowRailer(
                      leading: Column(
                        children: [
                          Row(
                            children: [
                              "Good Morning"
                                  .txt18(color: Palette.whiteColor, fontW: F.w4)
                                  .alignCenterLeft(),
                              3.sbW,
                              Icon(
                                PhosphorIconsFill.fire,
                                size: 18.h,
                                color: Palette.whiteColor,
                              )
                            ],
                          ),
                          5.sbH,
                          "Minato Namikaze"
                              .txt20(
                                  color: Palette.whiteColor,
                                  fontW: F.w6,
                                  overflow: TextOverflow.ellipsis)
                              .alignCenterLeft(),
                        ],
                      ),
                      trailing: Container(
                        height: 33.h,
                        width: 33.h,
                        decoration: BoxDecoration(
                          color: Palette.greyFill.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(8.r)),
                        ),
                        child: const Icon(
                          PhosphorIconsRegular.bellSimple,
                          color: Palette.whiteColor,
                        ),
                      ),
                      rowPadding: 15.padH,
                    ),
                    120.sbH,
                    CustomPaint(
                      size: Size(double.infinity, 50.h),
                      painter: CurvedPainter(),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Palette.whiteColor,
                            border: Border.all(
                                color: Palette.whiteColor, width: 1)),
                        constraints:
                            BoxConstraints(minHeight: height(context) - 250.h),
                        child: Padding(
                          padding: 15.padH,
                          child: Column(
                            children: [
                              100.sbH,
                              RowRailer(
                                rowPadding: 0.padH,
                                leading: "Recent Transactions".txt18(
                                  fontW: F.w5,
                                ),
                                trailing: Container(
                                  height: 27.h,
                                  width: 67.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.r)),
                                      color: Palette.montraPurple
                                          .withOpacity(0.25)),
                                  child: Center(
                                    child: "See All".txt14(
                                        color: Palette.montraPurple,
                                        fontW: F.w5),
                                  ),
                                ),
                              ),
                              20.sbH,
                              ListView.separated(
                                padding: 0.0.padA,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return TransactionTile(
                                      transaction: transactions[index]);
                                },
                                separatorBuilder: (context, index) {
                                  return 10.sbH;
                                },
                              ),
                              100.sbH,
                            ],
                          ),
                        )),
                  ],
                ),
                Positioned(
                  top: 150,
                  left: 15,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 300.w,
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: Palette.montraPurple,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 9,
                            blurRadius: 18,
                            offset: const Offset(5, 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15.r)),
                      child: Container(
                        width: 345.w,
                        decoration: BoxDecoration(
                          color: Palette.montraPurple,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 6,
                              blurRadius: 14,
                              offset: const Offset(5, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.3,
                                child: AppGraphics.cardBG.png
                                    .myImage(fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 25.h),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      RowRailer(
                                        rowPadding: 0.padH,
                                        leading: "Total Balances".txt18(
                                            fontW: F.w3,
                                            color: Palette.whiteColor),
                                        trailing: _privacyFilter.sync(builder:
                                            (context, privacyOn, child) {
                                          return Icon(
                                            privacyOn
                                                ? PhosphorIconsRegular.eye
                                                : PhosphorIconsRegular.eyeSlash,
                                            color: Palette.whiteColor,
                                            size: 25.h,
                                          ).tap(onTap: () {
                                            _privacyFilter.value =
                                                !_privacyFilter.value;
                                          });
                                        }),
                                      ),
                                      5.sbH,
                                      Row(
                                        children: [
                                          _privacyFilter.sync(builder:
                                              (context, privacyOn, child) {
                                            return ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: privacyOn ? 7 : 0,
                                                sigmaY: privacyOn ? 7 : 0,
                                              ),
                                              child: privacyOn
                                                  ? "₦ 3,450".txt(
                                                      size: 32.sp,
                                                      fontW: F.w8,
                                                      color: Palette.whiteColor)
                                                  : "₦ 345,000.00".txt(
                                                      size: 32.sp,
                                                      fontW: F.w8,
                                                      color:
                                                          Palette.whiteColor),
                                            );
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      RowRailer(
                                        rowPadding: 0.padH,
                                        leading: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Palette.whiteColor
                                                      .withOpacity(0.3)),
                                              child: Padding(
                                                padding: 3.0.padA,
                                                child: Icon(
                                                  PhosphorIconsBold.arrowDown,
                                                  size: 15.h,
                                                  color: Palette.greenColor,
                                                ),
                                              ),
                                            ),
                                            5.sbW,
                                            "Income".txt(
                                                size: 19.sp,
                                                color: Palette.whiteColor,
                                                fontW: F.w3)
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Palette.whiteColor
                                                      .withOpacity(0.3)),
                                              child: Padding(
                                                padding: 3.0.padA,
                                                child: Icon(
                                                  PhosphorIconsBold.arrowUp,
                                                  size: 15.h,
                                                  color: Palette.redColor,
                                                ),
                                              ),
                                            ),
                                            5.sbW,
                                            "Expenses".txt(
                                                size: 19.sp,
                                                color: Palette.whiteColor,
                                                fontW: F.w3)
                                          ],
                                        ),
                                      ),
                                      15.sbH,
                                      RowRailer(
                                        rowPadding: 0.padH,
                                        leading: _privacyFilter.sync(builder:
                                            (context, privacyOn, child) {
                                          return ImageFiltered(
                                            imageFilter: ImageFilter.blur(
                                              sigmaX: privacyOn ? 5 : 0,
                                              sigmaY: privacyOn ? 5 : 0,
                                            ),
                                            child: privacyOn
                                                ? "₦ 3,450".txt18(
                                                    fontW: F.w3,
                                                    color: Palette.whiteColor)
                                                : "₦ 745,000.00".txt18(
                                                    fontW: F.w3,
                                                    color: Palette.whiteColor),
                                          );
                                        }),
                                        trailing: _privacyFilter.sync(builder:
                                            (context, privacyOn, child) {
                                          return ImageFiltered(
                                            imageFilter: ImageFilter.blur(
                                              sigmaX: privacyOn ? 5 : 0,
                                              sigmaY: privacyOn ? 5 : 0,
                                            ),
                                            child: privacyOn
                                                ? "₦ 3,450".txt18(
                                                    fontW: F.w3,
                                                    color: Palette.whiteColor)
                                                : "₦ 400,000.00".txt18(
                                                    fontW: F.w3,
                                                    color: Palette.whiteColor),
                                          );
                                        }),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
