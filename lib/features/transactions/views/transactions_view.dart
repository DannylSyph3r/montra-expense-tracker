import 'package:expense_tracker_app/features/transactions/widgets/filter_tab.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:expense_tracker_app/utils/widgets/sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverwareAppBar(
                appBarToolbarheight: 40.h,
                sliverCollapseMode: CollapseMode.parallax,
                isPinned: true,
                canStretch: false,
                isFloating: true,
                customizeLeadingWidget: false,
                showLeadingIconOrWidget: false,
                titleCentered: true,
                isTitleAWidget: false,
                title: "Transactions",
                titleFontSize: 20.sp,
                titleFontWeight: FontWeight.w300,
                actions: [
                  Padding(
                    padding: 15.padH,
                    child: Icon(
                      PhosphorIconsFill.funnel,
                      color: Palette.montraPurple,
                      size: 28.h,
                    ).tap(onTap: () {
                      showCustomModal(context,
                          modalHeight: 450.h,
                          child: Padding(
                            padding: 15.padH,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RowRailer(
                                  rowPadding: 0.padH,
                                  leading: "Transaction Filter".txt16(
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
                                      child: "Reset".txt14(
                                          color: Palette.montraPurple,
                                          fontW: F.w5),
                                    ),
                                  ),
                                ),
                                15.sbH,
                                "Filter By".txt16(fontW: F.w6),
                                10.sbH,
                                Row(
                                  children: [
                                    const FilterTab(tabLabel: "Income"),
                                    10.sbW,
                                    const FilterTab(tabLabel: "Expense"),
                                  ],
                                ),
                                15.sbH,
                                "Sort By".txt16(fontW: F.w6),
                                10.sbH,
                                Wrap(
                                  spacing: 10.w,
                                  runSpacing: 10.h,
                                  children: const [
                                    FilterTab(tabLabel: "Highest"),
                                    FilterTab(
                                      tabLabel: "Lowest",
                                    ),
                                    FilterTab(
                                      tabLabel: "Newest",
                                    ),
                                    FilterTab(
                                      tabLabel: "Oldest",
                                    ),
                                  ],
                                ),
                                15.sbH,
                                "Category".txt16(fontW: F.w6),
                              ],
                            ),
                          ));
                    }),
                  )
                ],
                sliverBottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.h),
                  child: Material(
                    color: Colors.white,
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
                      tabs: ['Day', 'Week', 'Month', 'Year']
                          .map((label) => SizedBox(
                                width: 55.w,
                                child: Tab(
                                  child: label.txt14(),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              )
            ];
          },
          body: Container(
            color: Colors.white,
            child: TabBarView(children: [
              Column(
                children: [],
              ),
              Column(
                children: [],
              ),
              Column(
                children: [],
              ),
              Column(
                children: [],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
