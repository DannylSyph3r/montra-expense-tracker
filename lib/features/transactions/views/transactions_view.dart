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
  final ValueNotifier<Set<String>> _selectedFilters =
      ValueNotifier<Set<String>>({});
  final ValueNotifier<Set<String>> _selectedSortOptions =
      ValueNotifier<Set<String>>({});
  final ValueNotifier<Set<String>> _selectedCategories =
      ValueNotifier<Set<String>>({});

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
  void dispose() {
    _selectedFilters.dispose();
    _selectedSortOptions.dispose();
    _selectedCategories.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.whiteColor,
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
                titleFontSize: 20.sp,
                titleFontWeight: FontWeight.w500,
                actions: [
                  Padding(
                    padding: 15.padH,
                    child: Container(
                      height: 35.h,
                      width: 35.h,
                      decoration: BoxDecoration(
                        color: Palette.montraPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        PhosphorIconsFill.funnel,
                        color: Palette.montraPurple,
                        size: 20.h,
                      ),
                    ).tap(onTap: _showFilterModal),
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
                          bottom:
                              BorderSide(width: 3, color: Palette.montraPurple),
                        ),
                      ),
                      labelColor: Palette.montraPurple,
                      unselectedLabelColor: Palette.greyColor,
                      labelStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w600),
                      ),
                      unselectedLabelStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w400),
                      ),
                      tabs: ['Day', 'Week', 'Month', 'Year']
                          .map((label) => SizedBox(
                                width: 55.w,
                                child: Tab(child: label.txt(size: 14.sp)),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            color: Palette.whiteColor,
            child: TabBarView(
              children: [
                // Day Transactions
                _buildTransactionTab("Wed 18 March", 4),

                // Week Transactions
                _buildTransactionTab("Mon 18 November - Sun 24 November", 12),

                // Month Transactions
                _buildTransactionTab("March", 30),

                // Year Transactions
                ListView(
                  padding: 15.padH,
                  children: [
                    15.sbH,
                    if (transactions.isEmpty)
                      _buildEmptyState()
                    else
                      GroupedListView(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        reverse: false,
                        elements: transactions,
                        groupBy: (Transaction transaction) {
                          return DateTime(
                            transaction.transactionDate.year,
                            transaction.transactionDate.month,
                          );
                        },
                        groupHeaderBuilder: (Transaction transaction) {
                          // Check if this is the first group (earliest month in the year)
                          final sortedTransactions = transactions.toList()
                            ..sort((a, b) =>
                                a.transactionDate.compareTo(b.transactionDate));
                          final isFirstGroup = sortedTransactions.isNotEmpty &&
                              DateTime(transaction.transactionDate.year,
                                      transaction.transactionDate.month) ==
                                  DateTime(
                                      sortedTransactions
                                          .first.transactionDate.year,
                                      sortedTransactions
                                          .first.transactionDate.month);

                          return Container(
                            margin: EdgeInsets.only(
                                top: isFirstGroup ? 0.h : 12.h, bottom: 12.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: Palette.greyFill,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(PhosphorIconsFill.calendarBlank,
                                    color: Palette.montraPurple, size: 22.h),
                                8.sbW,
                                DateFormat.yMMMM()
                                    .format(transaction.transactionDate)
                                    .txt12(
                                        fontW: F.w6, color: Palette.blackColor),
                              ],
                            ),
                          );
                        },
                        itemBuilder:
                            (BuildContext context, Transaction transaction) {
                          return TransactionTile(
                            transaction: transaction,
                            onTileTap: () {},
                          );
                        },
                        separator: 12.sbH,
                      ),
                    120.sbH,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50.h,
            width: 50.h,
            decoration: BoxDecoration(
              color: Palette.montraPurple,
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: Palette.montraPurple.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(PhosphorIconsBold.plus,
                size: 24.h, color: Palette.whiteColor),
          ).tap(onTap: () {
            goTo(context: context, view: const AddTransactionView());
          }),
          80.sbH,
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _buildTransactionTab(String dateText, int itemCount) {
    return ListView(
      padding: 15.padH,
      children: [
        15.sbH,
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: Palette.greyFill,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(PhosphorIconsFill.calendarBlank,
                  color: Palette.montraPurple, size: 22.h),
              8.sbW,
              dateText.txt12(fontW: F.w6, color: Palette.blackColor),
            ],
          ),
        ),
        15.sbH,
        if (transactions.isEmpty)
          _buildEmptyState()
        else
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount.clamp(0, transactions.length),
            itemBuilder: (context, index) {
              return TransactionTile(
                transaction: transactions[index],
                onTileTap: () {},
              );
            },
            separatorBuilder: (context, index) => 12.sbH,
          ),
        120.sbH,
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: 40.padH,
        child: Column(
          children: [
            Container(
              height: 80.h,
              width: 80.h,
              decoration: BoxDecoration(
                color: Palette.greyFill,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(PhosphorIconsBold.receipt,
                  size: 40.h, color: Palette.greyColor),
            ),
            20.sbH,
            "No Transactions Yet".txt18(fontW: F.w6),
            10.sbH,
            "Start tracking your expenses and income by adding your first transaction."
                .txt14(color: Palette.greyColor, textAlign: TextAlign.center),
            30.sbH,
            AppButton(
              text: "Add Transaction",
              onTap: () =>
                  goTo(context: context, view: const AddTransactionView()),
              spanScreen: false,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal() {
    showCustomModal(
      context,
      modalHeight: 650.h,
      child: Padding(
        padding: 15.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RowRailer(
              rowPadding: EdgeInsets.zero,
              leading: "Transaction Filters".txt18(fontW: F.w6),
              trailing: Container(
                height: 32.h,
                width: 70.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Palette.montraPurple.withOpacity(0.1),
                ),
                child: Center(
                  child:
                      "Reset".txt12(color: Palette.montraPurple, fontW: F.w6),
                ),
              ).tap(onTap: () {
                _selectedFilters.value = {};
                _selectedSortOptions.value = {};
                _selectedCategories.value = {};
              }),
            ),
            20.sbH,

            // Filter By Section
            "Filter By".txt16(fontW: F.w6),
            12.sbH,
            ValueListenableBuilder<Set<String>>(
              valueListenable: _selectedFilters,
              builder: (context, selectedFilters, child) {
                return Row(
                  children: ["Income", "Expense"].map((filter) {
                    final isSelected = selectedFilters.contains(filter);
                    return Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: FilterTab(
                        tabLabel: filter,
                        tabColor: isSelected ? Palette.montraPurple : null,
                        tabBorderColor:
                            isSelected ? Palette.montraPurple : null,
                      ).tap(onTap: () {
                        final current = Set<String>.from(selectedFilters);
                        if (current.contains(filter)) {
                          current.remove(filter);
                        } else {
                          current.clear();
                          current.add(filter);
                        }
                        _selectedFilters.value = current;
                      }),
                    );
                  }).toList(),
                );
              },
            ),
            20.sbH,

            // Sort By Section
            "Sort By".txt16(fontW: F.w6),
            12.sbH,
            ValueListenableBuilder<Set<String>>(
              valueListenable: _selectedSortOptions,
              builder: (context, selectedSortOptions, child) {
                return Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: ["Highest", "Lowest", "Newest", "Oldest"]
                      .map((sortOption) {
                    final isSelected = selectedSortOptions.contains(sortOption);
                    return FilterTab(
                      tabLabel: sortOption,
                      tabColor: isSelected ? Palette.montraPurple : null,
                      tabBorderColor: isSelected ? Palette.montraPurple : null,
                    ).tap(onTap: () {
                      final current = Set<String>.from(selectedSortOptions);
                      if (current.contains(sortOption)) {
                        current.remove(sortOption);
                      } else {
                        current.clear();
                        current.add(sortOption);
                      }
                      _selectedSortOptions.value = current;
                    });
                  }).toList(),
                );
              },
            ),
            20.sbH,

            // Categories Section
            "Categories".txt16(fontW: F.w6),
            12.sbH,
            ValueListenableBuilder<Set<String>>(
              valueListenable: _selectedCategories,
              builder: (context, selectedCategories, child) {
                return Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: categories.map((category) {
                    final isSelected = selectedCategories.contains(category);
                    return FilterTab(
                      tabLabel: category,
                      tabColor: isSelected ? Palette.montraPurple : null,
                      tabBorderColor: isSelected ? Palette.montraPurple : null,
                    ).tap(onTap: () {
                      final current = Set<String>.from(selectedCategories);
                      if (current.contains(category)) {
                        current.remove(category);
                      } else {
                        current.add(category);
                      }
                      _selectedCategories.value = current;
                    });
                  }).toList(),
                );
              },
            ),
            30.sbH,

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    color: Palette.greyFill,
                    textColor: Palette.blackColor,
                    text: "Clear All",
                    onTap: () {
                      _selectedFilters.value = {};
                      _selectedSortOptions.value = {};
                      _selectedCategories.value = {};
                      Navigator.pop(context);
                    },
                  ),
                ),
                15.sbW,
                Expanded(
                  child: AppButton(
                    text: "Apply Filters",
                    onTap: () {
                      Navigator.pop(context);
                      // Apply filter logic here
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
