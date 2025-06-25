import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/features/transactions/views/add_transaction_view.dart';
import 'package:expense_tracker_app/features/transactions/views/transaction_details_view.dart';
import 'package:expense_tracker_app/features/transactions/views/transaction_filter_view.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/doc_picker_modalsheet.dart';
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
  
  // FAB state
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

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollTimer?.cancel();
    _isFabExpandedNotifier.dispose();
    _isFabVisibleNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    final currentScrollOffset = _scrollController.offset;
    final scrollDelta = currentScrollOffset - _lastScrollOffset;

    if (scrollDelta.abs() > 5.0) {
      final isScrollingDown = scrollDelta > 0;

      if (isScrollingDown && _isFabVisibleNotifier.value) {
        _isFabVisibleNotifier.value = false;
        if (_isFabExpandedNotifier.value) {
          _isFabExpandedNotifier.value = false;
        }
      }

      _scrollTimer?.cancel();
      _scrollTimer = Timer(const Duration(milliseconds: 400), () {
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
        descriptionText: "Take a photo of your receipt or select from gallery. We'll automatically extract transaction details for you.",
        onTakeDocPicture: () {
          goBack(context);
          // TODO: Add receipt scanning logic here
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[_buildAppBar()];
          },
          body: Container(
            color: Colors.white,
            child: _buildTabBarView(),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildAppBar() {
    return SliverwareAppBar(
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
          ).tap(onTap: () => goTo(context: context, view: const TransactionFilterView())),
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
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      children: [
        _buildDayView(),
        _buildWeekView(),
        _buildMonthView(),
        _buildYearView(),
      ],
    );
  }

  Widget _buildDayView() {
    return ListView(
      controller: _scrollController,
      padding: 15.padH,
      children: [
        10.sbH,
        _buildDateHeader("Wed 18 March 2025"),
        5.sbH,
        _buildTransactionList(4),
        120.sbH
      ],
    );
  }

  Widget _buildWeekView() {
    return ListView(
      controller: _scrollController,
      padding: 15.padH,
      children: [
        10.sbH,
        _buildDateHeader("Mon 18 March 2025 - Sun 18 March 2025"),
        5.sbH,
        _buildTransactionList(12),
        120.sbH
      ],
    );
  }

  Widget _buildMonthView() {
    return ListView(
      controller: _scrollController,
      padding: 15.padH,
      children: [
        10.sbH,
        _buildDateHeader("March 2025"),
        5.sbH,
        _buildTransactionList(30),
        120.sbH
      ],
    );
  }

  Widget _buildYearView() {
    return ListView(
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
            padding: EdgeInsets.symmetric(vertical: 22.5.h, horizontal: 15.w),
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
          itemBuilder: (BuildContext context, Transaction transaction) {
            return TransactionTile(
              transaction: transaction,
              onTileTap: () {
                goTo(context: context, view: const TransactionsDetailsView());
              },
            );
          },
          separator: 10.sbH,
        ),
      ],
    );
  }

  Widget _buildDateHeader(String dateText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            PhosphorIconsFill.calendarBlank,
            color: Palette.montraPurple,
            size: 25.h,
          ),
          5.sbW,
          dateText.txt12(fontW: F.w6)
        ],
      ),
    );
  }

  Widget _buildTransactionList(int itemCount) {
    return ListView.separated(
      padding: 0.0.padA,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return TransactionTile(
          transaction: transactions[index],
          onTileTap: () {
            goTo(context: context, view: const TransactionsDetailsView());
          },
        );
      },
      separatorBuilder: (context, index) => 10.sbH,
    );
  }

  Widget _buildFloatingActionButton() {
    return ValueListenableBuilder<bool>(
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
                    if (isExpanded) ...[
                      _buildFabOption(
                        label: "Scan Receipt",
                        backgroundColor: Palette.greenColor,
                        icon: PhosphorIconsBold.scan,
                        onTap: _onReceiptScanTap,
                        delay: 0,
                      ),
                      15.sbH,
                      _buildFabOption(
                        label: "Add Manually",
                        backgroundColor: Palette.blue,
                        icon: PhosphorIconsBold.pencil,
                        onTap: _onManualAddTap,
                        delay: 50,
                      ),
                      15.sbH,
                    ],
                    Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "main_fab",
                          backgroundColor: Palette.montraPurple,
                          onPressed: _toggleFab,
                          child: AnimatedRotation(
                            turns: isExpanded ? 0.125 : 0.0,
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
    );
  }

  Widget _buildFabOption({
    required String label,
    required Color backgroundColor,
    required IconData icon,
    required VoidCallback onTap,
    required int delay,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Palette.blackColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: label.txt12(
            color: Palette.whiteColor,
            fontW: F.w5,
          ),
        ),
        8.sbW,
        FloatingActionButton(
          mini: true,
          heroTag: label.toLowerCase().replaceAll(' ', '_'),
          backgroundColor: backgroundColor,
          onPressed: onTap,
          child: Icon(
            icon,
            color: Palette.whiteColor,
            size: 20.h,
          ),
        ),
      ],
    ).animate()
     .fadeIn(duration: 200.ms, delay: Duration(milliseconds: delay))
     .slideX(begin: 0.5, duration: 250.ms);
  }
}