import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/features/transactions/views/add_transaction_view.dart';
import 'package:expense_tracker_app/features/transactions/widgets/filter_tab.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:expense_tracker_app/utils/widgets/sliver_appbar.dart';
import 'package:expense_tracker_app/utils/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  final List<String> categories = [
    "Food",
    "Transportation",
    "Entertainment",
    "Shopping",
    "Utilities",
    "Health",
    "Travel",
    "Education",
    "Personal Care",
    "Gifts",
    "Investments",
    "Others",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 5,
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
                          modalHeight: 650.h,
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
                                    FilterTab(tabLabel: "Lowest"),
                                    FilterTab(tabLabel: "Newest"),
                                    FilterTab(tabLabel: "Oldest"),
                                  ],
                                ),
                                15.sbH,
                                "Category".txt16(fontW: F.w6),
                                10.sbH,
                                Wrap(
                                  spacing: 10.w,
                                  runSpacing: 10.h,
                                  children: categories
                                      .map((category) =>
                                          FilterTab(tabLabel: category))
                                      .toList(),
                                ),
                                30.sbH,
                                AppButton(text: "Apply", onTap: () {})
                              ],
                            ),
                          ));
                    }),
                  )
                ],
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
                      tabs: ['Day', 'Week', 'Month', 'Year', 'Custom']
                          .map((label) => SizedBox(
                                width: 55.w,
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
              // Day Transactions
              ListView(
                padding: 15.padH,
                children: [
                  20.sbH,
                  ListView.separated(
                    padding: 0.0.padA,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return TransactionTile(transaction: transactions[index]);
                    },
                    separatorBuilder: (context, index) {
                      return 10.sbH;
                    },
                  ),
                  120.sbH
                ],
              ),

              // Week Transations
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
                      return TransactionTile(transaction: transactions[index]);
                    },
                    separatorBuilder: (context, index) {
                      return 10.sbH;
                    },
                  ),
                  120.sbH
                ],
              ),

              // Month Transactions
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
                        "September 2024".txt14(fontW: F.w6)
                      ],
                    ),
                  ),
                  10.sbH,
                  ListView.separated(
                    padding: 0.0.padA,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return TransactionTile(transaction: transactions[index]);
                    },
                    separatorBuilder: (context, index) {
                      return 10.sbH;
                    },
                  ),
                  120.sbH
                ],
              ),

              // Year Transactions
              ListView(
                padding: 15.padH,
                children: [
                  GroupedListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: 0.padH,
                    shrinkWrap: true,
                    reverse: true,
                    elements: transactions,
                    groupBy: (Transaction transaction) {
                      return DateTime(
                        transaction.transactionDate.year,
                        transaction.transactionDate.month,
                      );
                    },
                    groupHeaderBuilder: (Transaction transaction) => Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            PhosphorIconsFill.calendarBlank,
                            color: Palette.montraPurple,
                            size: 25.h,
                          ),
                          5.sbW,
                          DateFormat.yMMMM()
                              .format(transaction.transactionDate)
                              .txt14(fontW: F.w6)
                              .alignCenterLeft(),
                        ],
                      ),
                    ),
                    itemBuilder:
                        (BuildContext context, Transaction transaction) {
                      return TransactionTile(transaction: transaction);
                    },
                    separator: 10.sbH,
                  ),
                ],
              ),
              Column(
                children: [],
              )
            ]),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50.h,
            width: 110.h,
            decoration: BoxDecoration(
                color: Palette.montraPurple,
                borderRadius: BorderRadius.circular(25.r)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIconsBold.plus,
                    size: 20.h,
                    color: Palette.whiteColor,
                  ),
                  10.sbW,
                  "Add".txt14(color: Palette.whiteColor)
                ],
              ),
            ),
          ).tap(onTap: () {
            goTo(context: context, view: AddTransactionView());
          }),
          80.sbH,
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
