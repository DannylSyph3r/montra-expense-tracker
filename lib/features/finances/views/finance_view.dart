import 'package:expense_tracker_app/features/finances/views/create_budget_view.dart';
import 'package:expense_tracker_app/features/finances/widgets/budget_summary_card.dart';
import 'package:expense_tracker_app/features/finances/widgets/budget_tile.dart';
import 'package:expense_tracker_app/features/finances/widgets/category_distro.dart';
import 'package:expense_tracker_app/features/finances/widgets/edit_budget_modal.dart';
import 'package:expense_tracker_app/features/finances/widgets/line_monthly.dart';
import 'package:expense_tracker_app/features/transactions/models/budget_model.dart';
import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class FinanceView extends StatefulWidget {
  const FinanceView({super.key});

  @override
  State<FinanceView> createState() => _FinanceViewState();
}

class _FinanceViewState extends State<FinanceView>
    with TickerProviderStateMixin {
  final ValueNotifier<int> _switchNotifier = 0.notifier;
  final ValueNotifier<int> _currentTabNotifier = ValueNotifier<int>(0);
  late TabController _tabController;

  // Sample budgets - in real app this would come from a state management solution
  final List<Budget> _budgets = sampleBudgets;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _currentTabNotifier.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _switchNotifier.dispose();
    _currentTabNotifier.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasBudgets = _budgets.isNotEmpty;

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
                titleFontSize: 18.sp,
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
                      controller: _tabController,
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReportsTab(),
                hasBudgets ? _buildBudgetsList() : _buildEmptyBudgetsState(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<int>(
        valueListenable: _currentTabNotifier,
        builder: (context, currentTab, child) {
          // Only show FAB on Budgets tab (index 1)
          if (currentTab != 1) return const SizedBox.shrink();

          return AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            offset: Offset.zero,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: 1.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: "budget_fab",
                    backgroundColor: Palette.montraPurple,
                    onPressed: () {
                      goTo(context: context, view: const CreateBudgetView());
                    },
                    child: Icon(
                      PhosphorIconsBold.plus,
                      color: Palette.whiteColor,
                      size: 24.h,
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(
                      begin: 1,
                      end: 0,
                      duration: 300.ms,
                      curve: Curves.easeOut),
                  80.sbH
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildReportsTab() {
    return ListView(
      padding: 15.padH,
      children: [
        20.sbH,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: Palette.blackColor),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
            _switchNotifier.sync(builder: (context, displayType, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 13.w),
                    decoration: BoxDecoration(
                      color: displayType == 0
                          ? Palette.montraPurple
                          : Palette.whiteColor,
                      border:
                          Border.all(color: Palette.montraPurple, width: 1.5),
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
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 13.w),
                    decoration: BoxDecoration(
                      color: displayType == 1
                          ? Palette.montraPurple
                          : Palette.whiteColor,
                      border:
                          Border.all(color: Palette.montraPurple, width: 1.5),
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
        30.sbH,

        // Animated chart switcher
        _switchNotifier.sync(builder: (context, displayType, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Line Chart (visible when displayType is 0)
              if (displayType == 0)
                LineChartMonthly(
                  transactions: transactions,
                  currencySymbol: 'N',
                ).animate().fadeIn(duration: 400.ms).slideX(
                    begin: -0.1,
                    end: 0,
                    duration: 300.ms,
                    curve: Curves.easeOutQuad),

              // Category Distribution Chart (visible when displayType is 1)
              if (displayType == 1)
                CategoryDistributionChart(
                  transactions: transactions,
                  size: 200,
                  strokeWidth: 28,
                  onCategoryTap: (category, amount) {
                    // Handle category tap
                  },
                ).animate().fadeIn(duration: 400.ms).slideX(
                    begin: 0.1,
                    end: 0,
                    duration: 300.ms,
                    curve: Curves.easeOutQuad),
            ],
          );
        }),

        100.sbH
      ],
    );
  }

  Widget _buildBudgetsList() {
    final activeBudgets =
        _budgets.where((b) => b.status == BudgetStatus.active).toList();
    final expiredBudgets =
        _budgets.where((b) => b.status == BudgetStatus.expired).toList();

    return ListView(
      padding: 15.padH,
      children: [
        15.sbH,

        // Budget Summary Card
        BudgetSummaryCard(budgets: _budgets),

        25.sbH,

        // Active Budgets Section
        if (activeBudgets.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Active Budgets".txt16(fontW: F.w6),
              "${activeBudgets.length} budgets".txt12(
                color: Palette.greyColor,
                fontW: F.w5,
              ),
            ],
          ),
          15.sbH,
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: activeBudgets.length,
            itemBuilder: (context, index) {
              return BudgetTile(
                budget: activeBudgets[index],
                onTileTap: () {
                  _showBudgetDetails(activeBudgets[index]);
                },
                onMoreTap: () {
                  _showBudgetOptions(activeBudgets[index]);
                },
              )
                  .animate(delay: Duration(milliseconds: index * 100))
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: 0.2, end: 0, duration: 400.ms);
            },
            separatorBuilder: (context, index) => 12.sbH,
          ),
        ],

        // Expired Budgets Section
        if (expiredBudgets.isNotEmpty) ...[
          25.sbH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Expired Budgets".txt16(fontW: F.w6),
              "${expiredBudgets.length} budgets".txt12(
                color: Palette.greyColor,
                fontW: F.w5,
              ),
            ],
          ),
          15.sbH,
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: expiredBudgets.length,
            itemBuilder: (context, index) {
              return Opacity(
                opacity: 0.7,
                child: BudgetTile(
                  budget: expiredBudgets[index],
                  onTileTap: () {
                    _showBudgetDetails(expiredBudgets[index]);
                  },
                  onMoreTap: () {
                    _showBudgetOptions(expiredBudgets[index]);
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => 12.sbH,
          ),
        ],

        100.sbH,
      ],
    );
  }

  Widget _buildEmptyBudgetsState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          PhosphorIconsFill.plusCircle,
          size: 70.h,
          color: Palette.montraPurple,
        ).tap(onTap: () {
          goTo(context: context, view: const CreateBudgetView());
        }),
        15.sbH,
        "No budgets created".txt14(fontW: F.w6),
        8.sbH,
        "Create your first budget to start tracking your spending".txt12(
          color: Palette.greyColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showBudgetDetails(Budget budget) {
    showCustomModal(
      context,
      modalHeight: 400.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  height: 50.h,
                  width: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: budget.category.color.withValues(alpha: 0.25),
                  ),
                  child: Icon(
                    budget.category.icon,
                    size: 25.h,
                    color: budget.category.color,
                  ),
                ),
                15.sbW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      budget.category.label.txt16(fontW: F.w6),
                      4.sbH,
                      budget.description.txt12(color: Palette.greyColor),
                    ],
                  ),
                ),
              ],
            ),

            20.sbH,

            // Stats
            Container(
              padding: 15.0.padA,
              decoration: BoxDecoration(
                color: Palette.greyFill,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  _buildDetailRow("Budget Amount",
                      "N${NumberFormat("#,##0.00", "en_US").format(budget.amount)}"),
                  _buildDetailRow("Spent",
                      "N${NumberFormat("#,##0.00", "en_US").format(budget.spentAmount)}"),
                  _buildDetailRow("Remaining",
                      "N${NumberFormat("#,##0.00", "en_US").format(budget.remainingAmount)}"),
                  _buildDetailRow("Period", budget.periodLabel),
                  _buildDetailRow("Days Left", "${budget.daysRemaining} days"),
                  _buildDetailRow(
                      "Recurring", budget.isRecurring ? "Yes" : "No"),
                ],
              ),
            ),

            20.sbH,

            // Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Progress".txt14(fontW: F.w6),
                8.sbH,
                Stack(
                  children: [
                    Container(
                      height: 8.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: budget.progressPercentage.clamp(0.0, 1.0),
                      child: Container(
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: budget.isExceeded
                              ? Palette.redColor
                              : Palette.greenColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ],
                ),
                8.sbH,
                "${(budget.progressPercentage * 100).toStringAsFixed(1)}% used"
                    .txt12(
                  color: Palette.greyColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          label.txt12(color: Palette.greyColor),
          value.txt12(fontW: F.w5),
        ],
      ),
    );
  }

  void _showBudgetOptions(Budget budget) {
    showCustomModal(
      context,
      modalHeight: 230.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(PhosphorIconsBold.pencil,
                  color: Palette.montraPurple),
              title: "Edit Budget".txt14(),
              onTap: () {
                Navigator.pop(context);
                _showEditBudget(budget);
              },
            ),
            ListTile(
              leading:
                  const Icon(PhosphorIconsBold.trash, color: Palette.redColor),
              title: "Delete Budget".txt14(color: Palette.redColor),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(budget);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBudget(Budget budget) {
    showCustomModal(
      context,
      modalHeight: 680.h,
      child: EditBudgetModal(
        budget: budget,
        onBudgetUpdated: (updatedBudget) {
          setState(() {
            final index = _budgets.indexWhere((b) => b.id == budget.id);
            if (index != -1) {
              _budgets[index] = updatedBudget;
            }
          });
        },
      ),
    );
  }

  void _showDeleteConfirmation(Budget budget) {
    showCustomModal(
      context,
      modalHeight: 230.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          children: [
            "Delete Budget?".txt16(fontW: F.w6),
            10.sbH,
            "This action cannot be undone. The budget for ${budget.category.label} will be permanently deleted."
                .txt12(
              color: Palette.greyColor,
              textAlign: TextAlign.center,
            ),
            20.sbH,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    color: Palette.greyFill,
                    textColor: Palette.blackColor,
                    text: "Cancel",
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                15.sbW,
                Expanded(
                  child: AppButton(
                    color: Palette.redColor,
                    text: "Delete",
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _budgets.removeWhere((b) => b.id == budget.id);
                      });
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
