import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
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
                    ),
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
