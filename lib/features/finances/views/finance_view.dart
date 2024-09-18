import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/widgets/sliver_appbar.dart';
import 'package:expense_tracker_app/utils/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FinanceView extends StatefulWidget {
  const FinanceView({super.key});

  @override
  State<FinanceView> createState() => _FinanceViewState();
}

class _FinanceViewState extends State<FinanceView> {
  final ValueNotifier<int> _switchNotifier = 0.notifier;

  @override
  void dispose() {
    _switchNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverwareAppBar(
                appBarToolbarheight: 30.h,
                sliverCollapseMode: CollapseMode.parallax,
                isPinned: true,
                canStretch: false,
                isFloating: true,
                customizeLeadingWidget: false,
                showLeadingIconOrWidget: false,
                titleCentered: true,
                isTitleAWidget: false,
                title: "Finances",
                titleFontSize: 20.sp,
                titleFontWeight: FontWeight.w300,
                sliverBottom: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  scrolledUnderElevation: 0,
                  toolbarHeight: 50.h,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Container(
                    color: Colors.transparent,
                    child: TabBar(
                      isScrollable: true,
                      padding: EdgeInsets.zero,
                      tabAlignment: TabAlignment.center,
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 4,
                            color: Palette.montraPurple,
                          ),
                        ),
                      ),
                      labelColor: Palette.montraPurple,
                      unselectedLabelColor: Colors.black,
                      labelStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      unselectedLabelStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w300),
                      ),
                      tabs: ['Reports', 'Budgets']
                          .map((label) => SizedBox(
                                width: 60.w,
                                child: Tab(
                                  child: label.txt(size: 13.sp),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            color: Colors.white,
            child: TabBarView(children: [
              // Reports
              ListView(
                padding: 15.padH,
                children: [
                  20.sbH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Palette.blackColor),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // This ensures it expands based on its content
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              PhosphorIconsBold.caretCircleDown,
                              size: 22.h,
                              color: Palette.montraPurple,
                            ),
                            5.sbW,
                            "Month".txt14()
                          ],
                        ),
                      ),
                      _switchNotifier.sync(
                          builder: (context, displayType, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 13.w),
                              decoration: BoxDecoration(
                                color: displayType == 0
                                    ? Palette.montraPurple
                                    : Palette.whiteColor,
                                border: Border.all(
                                    color: Palette.montraPurple, width: 1.5),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.r),
                                  bottomLeft: Radius.circular(30.r),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  PhosphorIconsBold.lineSegments,
                                  size: 22.h,
                                  color: displayType == 0
                                      ? Palette.whiteColor
                                      : Palette.montraPurple,
                                ),
                              ),
                            ).tap(onTap: () {
                              _switchNotifier.value = 0;
                            }),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 13.w),
                              decoration: BoxDecoration(
                                color: displayType == 1
                                    ? Palette.montraPurple
                                    : Palette.whiteColor,
                                border: Border.all(
                                    color: Palette.montraPurple, width: 1.5),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.r),
                                  bottomRight: Radius.circular(30.r),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  PhosphorIconsBold.chartPie,
                                  size: 22.h,
                                  color: displayType == 1
                                      ? Palette.whiteColor
                                      : Palette.montraPurple,
                                ),
                              ),
                            ).tap(onTap: () {
                              _switchNotifier.value = 1;
                            })
                          ],
                        );
                      }),
                    ],
                  ),
                  120.sbH
                ],
              ),

              // Budgets
              ListView(
                padding: 15.padH,
                children: [
                  10.sbH,
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          PhosphorIconsFill.calendarBlank,
                          color: Palette.montraPurple,
                          size: 25.h,
                        ),
                        5.sbW,
                        "Sun 8 September - Sat 14 September".txt14(fontW: F.w6)
                      ],
                    ),
                  ),
                  10.sbH,
                  ListView.separated(
                    padding: 0.0.padA,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return TransactionTile(
                        transaction: transactions[index],
                        onTileTap: () {},
                      );
                    },
                    separatorBuilder: (context, index) {
                      return 10.sbH;
                    },
                  ),
                  120.sbH
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
