import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/features/transactions/views/add_transaction_view.dart';
import 'package:expense_tracker_app/features/transactions/views/transaction_details_view.dart';
import 'package:expense_tracker_app/features/transactions/widgets/filter_tab.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/doc_picker_modalsheet.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:expense_tracker_app/utils/widgets/sliver_appbar.dart';
import 'package:expense_tracker_app/utils/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:async';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView>
    with TickerProviderStateMixin {
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

  final ValueNotifier<bool> _isFabExpandedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isFabVisibleNotifier = ValueNotifier<bool>(true);
  final ScrollController _scrollController = ScrollController();

  double _lastScrollOffset = 0.0;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentScrollOffset = _scrollController.offset;
    final scrollDelta = currentScrollOffset - _lastScrollOffset;

    // Only react to significant scroll movements
    if (scrollDelta.abs() > 5.0) {
      final isScrollingDown = scrollDelta > 0;

      // Hide FAB when scrolling down
      if (isScrollingDown && _isFabVisibleNotifier.value) {
        _isFabVisibleNotifier.value = false;
        // Close expanded FAB when hiding
        if (_isFabExpandedNotifier.value) {
          _isFabExpandedNotifier.value = false;
        }
      }

      // Cancel previous timer and start a new one
      _scrollTimer?.cancel();
      _scrollTimer = Timer(const Duration(milliseconds: 400), () {
        // Show FAB when user stops scrolling for 800ms
        if (!_isFabVisibleNotifier.value) {
          _isFabVisibleNotifier.value = true;
        }
      });
    }

    _lastScrollOffset = currentScrollOffset;
  }

  void _toggleFab() {
    _isFabExpandedNotifier.value = !_isFabExpandedNotifier.value;
  }

  void _closeFab() {
    _isFabExpandedNotifier.value = false;
  }

  void _onManualAddTap() {
    _closeFab();
    goTo(context: context, view: AddTransactionView());
  }

  void _onReceiptScanTap() {
    _closeFab();
    showModalBottomSheet(
      context: context,
      builder: (context) => DocPickerModalBottomSheet(
        headerText: "Receipt Scanner",
        descriptionText:
            "Take a photo of your receipt or select from gallery. We'll automatically extract transaction details for you.",
        onTakeDocPicture: () {
          goBack(context);
          // TODO: Add receipt scanning logic here
          // This will eventually process the image and navigate to add transaction with pre-filled data
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollTimer?.cancel();
    _isFabExpandedNotifier.dispose();
    _isFabVisibleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
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
                titleFontSize: 18.sp,
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
                      tabs: ['Day', 'Week', 'Month', 'Year']
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
            child: TabBarView(
              children: [
                // Day Transactions
                ListView(
                  controller: _scrollController,
                  padding: 15.padH,
                  children: [
                    10.sbH,
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            PhosphorIconsFill.calendarBlank,
                            color: Palette.montraPurple,
                            size: 25.h,
                          ),
                          5.sbW,
                          "Wed 18 March 2025".txt12(fontW: F.w6)
                        ],
                      ),
                    ),
                    5.sbH,
                    ListView.separated(
                      padding: 0.0.padA,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return TransactionTile(
                          transaction: transactions[index],
                          onTileTap: () {
                            goTo(
                                context: context,
                                view: const TransactionsDetailsView());
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return 10.sbH;
                      },
                    ),
                    120.sbH
                  ],
                ),

                // Week Transactions
                ListView(
                  controller: _scrollController,
                  padding: 15.padH,
                  children: [
                    10.sbH,
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            PhosphorIconsFill.calendarBlank,
                            color: Palette.montraPurple,
                            size: 25.h,
                          ),
                          5.sbW,
                          "Mon 18 March 2025 - Sun 18 March 2025"
                              .txt12(fontW: F.w6)
                        ],
                      ),
                    ),
                    5.sbH,
                    ListView.separated(
                      padding: 0.0.padA,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return TransactionTile(
                          transaction: transactions[index],
                          onTileTap: () {
                            goTo(
                                context: context,
                                view: const TransactionsDetailsView());
                          },
                        );
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
                  controller: _scrollController,
                  padding: 15.padH,
                  children: [
                    10.sbH,
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            PhosphorIconsFill.calendarBlank,
                            color: Palette.montraPurple,
                            size: 25.h,
                          ),
                          5.sbW,
                          "March 2025".txt12(fontW: F.w6)
                        ],
                      ),
                    ),
                    5.sbH,
                    ListView.separated(
                      padding: 0.0.padA,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        return TransactionTile(
                          transaction: transactions[index],
                          onTileTap: () {
                            goTo(
                                context: context,
                                view: const TransactionsDetailsView());
                          },
                        );
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
                  controller: _scrollController,
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
                            vertical: 22.5.h, horizontal: 15.w),
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
                                .txt12(fontW: F.w6)
                                .alignCenterLeft(),
                          ],
                        ),
                      ),
                      itemBuilder:
                          (BuildContext context, Transaction transaction) {
                        return TransactionTile(
                          transaction: transaction,
                          onTileTap: () {
                            goTo(
                                context: context,
                                view: const TransactionsDetailsView());
                          },
                        );
                      },
                      separator: 10.sbH,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _isFabVisibleNotifier,
        builder: (context, isFabVisible, child) {
          return AnimatedSlide(
            duration: const Duration(milliseconds: 200),
            offset: isFabVisible ? Offset.zero : const Offset(0, 2),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isFabVisible ? 1.0 : 0.0,
              child: ValueListenableBuilder<bool>(
                valueListenable: _isFabExpandedNotifier,
                builder: (context, isExpanded, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Expanded options
                      if (isExpanded) ...[
                        // Receipt Scan Button
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Label
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Palette.blackColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: "Scan Receipt".txt12(
                                color: Palette.whiteColor,
                                fontW: F.w5,
                              ),
                            ),
                            8.sbW,
                            // Button
                            FloatingActionButton(
                              mini: true,
                              heroTag: "scan_receipt",
                              backgroundColor: Palette.greenColor,
                              onPressed: _onReceiptScanTap,
                              child: Icon(
                                PhosphorIconsBold.scan,
                                color: Palette.whiteColor,
                                size: 20.h,
                              ),
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 200.ms)
                            .slideX(begin: 0.5, duration: 250.ms),

                        15.sbH,

                        // Manual Add Button
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Label
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Palette.blackColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: "Add Manually".txt12(
                                color: Palette.whiteColor,
                                fontW: F.w5,
                              ),
                            ),
                            8.sbW,
                            // Button
                            FloatingActionButton(
                              mini: true,
                              heroTag: "add_manual",
                              backgroundColor: Palette.blue,
                              onPressed: _onManualAddTap,
                              child: Icon(
                                PhosphorIconsBold.pencil,
                                color: Palette.whiteColor,
                                size: 20.h,
                              ),
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 200.ms, delay: 50.ms)
                            .slideX(begin: 0.5, duration: 250.ms),

                        15.sbH,
                      ],

                      // Main FAB
                      Column(
                        children: [
                          FloatingActionButton(
                            heroTag: "main_fab",
                            backgroundColor: Palette.montraPurple,
                            onPressed: _toggleFab,
                            child: AnimatedRotation(
                              turns: isExpanded
                                  ? 0.125
                                  : 0.0, // 45 degrees when expanded
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                PhosphorIconsBold.plus,
                                color: Palette.whiteColor,
                                size: 24.h,
                              ),
                            ),
                          ),
                          80.sbH
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
