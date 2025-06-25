import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/utils/widgets/transaction_tile.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:math' as math;

class LineChartMonthly extends StatefulWidget {
  final List<Transaction> transactions;
  final Color lineColor;
  final Color gradientColor;
  final String currencySymbol;

  const LineChartMonthly({
    Key? key,
    required this.transactions,
    this.lineColor = const Color(0xFF8A3FFC),
    this.gradientColor = const Color(0xFF8A3FFC),
    this.currencySymbol = '₦',
  }) : super(key: key);

  @override
  State<LineChartMonthly> createState() => _LineChartMonthlyState();
}

class _LineChartMonthlyState extends State<LineChartMonthly> {
  final ValueNotifier<int> _tabNotifier = 0.notifier;
  final ValueNotifier<bool> _sortNotifier = true.notifier;
  final ValueNotifier<DateTime> _selectedMonthNotifier = ValueNotifier<DateTime>(DateTime.now());
  late double _globalUpperLimit;

  @override
  void initState() {
    super.initState();
    _globalUpperLimit = _calculateGlobalUpperLimit();
  }

  @override
  void dispose() {
    _tabNotifier.dispose();
    _sortNotifier.dispose();
    _selectedMonthNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _globalUpperLimit = _calculateGlobalUpperLimit();

    return Column(
      children: [
        _buildMonthSelector(),
        20.sbH,
        _buildLineChartSection(),
        30.sbH,
        _buildTabToggle(),
        20.sbH,
        _buildTransactionList(),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return _selectedMonthNotifier.sync(builder: (context, selectedMonth, child) {
      return Container(
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
            DateFormat('MMMM yyyy').format(selectedMonth).txt14()
          ],
        ),
      ).tap(onTap: _showMonthSelector);
    });
  }

  void _showMonthSelector() {
    final availableMonths = _getAvailableMonths();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: 20.0.padA,
        height: 450.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            20.sbH,
            "Select Month".txt18(fontW: F.w6),
            15.sbH,
            Expanded(
              child: ListView.separated(
                itemCount: availableMonths.length,
                itemBuilder: (context, index) {
                  final month = availableMonths[index];
                  final isSelected = month.month == _selectedMonthNotifier.value.month &&
                                   month.year == _selectedMonthNotifier.value.year;
                  
                  return ListTile(
                    onTap: () {
                      _selectedMonthNotifier.value = month;
                      Navigator.pop(context);
                    },
                    title: DateFormat('MMMM yyyy').format(month).txt14(),
                    trailing: isSelected 
                      ? Icon(PhosphorIconsBold.check, color: Palette.montraPurple, size: 20.h)
                      : null,
                    tileColor: isSelected 
                      ? Palette.montraPurple.withOpacity(0.1)
                      : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  );
                },
                separatorBuilder: (context, index) => 5.sbH,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _getAvailableMonths() {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    
    List<DateTime> months = [];
    
    // Add months from January of current year up to current month
    for (int month = 1; month <= currentMonth; month++) {
      months.add(DateTime(currentYear, month));
    }
    
    // Reverse to show most recent first
    return months.reversed.toList();
  }

  Widget _buildLineChartSection() {
    return _tabNotifier.sync(builder: (context, tabIndex, child) {
      final selectedType =
          tabIndex == 0 ? TransactionType.expense : TransactionType.income;

      return _selectedMonthNotifier.sync(builder: (context, selectedMonth, child) {
        final dailySpendingData = _processDailySpendingData(selectedType, selectedMonth);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _buildLineChart(dailySpendingData, selectedType,
              key: ValueKey('chart-$tabIndex-${selectedMonth.month}')),
        );
      });
    });
  }

  Widget _buildLineChart(
      List<DailySpending> dailySpendingData, TransactionType type,
      {Key? key}) {
    final double upperLimit = _globalUpperLimit.clamp(50.0, double.infinity);

    return SizedBox(
      key: key,
      height: 200,
      child: dailySpendingData.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 5 != 0) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${value.toInt()}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 1,
                  maxX: 31,
                  minY: 0,
                  maxY: upperLimit,
                  lineBarsData: [
                    LineChartBarData(
                      spots: dailySpendingData
                          .map((spending) => FlSpot(
                              spending.date.day.toDouble(), spending.amount))
                          .toList(),
                      isCurved: true,
                      color: type == TransactionType.expense
                          ? widget.lineColor
                          : Colors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            (type == TransactionType.expense
                                    ? widget.gradientColor
                                    : Colors.green)
                                .withOpacity(0.5),
                            (type == TransactionType.expense
                                    ? widget.gradientColor
                                    : Colors.green)
                                .withOpacity(0.1),
                            (type == TransactionType.expense
                                    ? widget.gradientColor
                                    : Colors.green)
                                .withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.black,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final int dayIndex = spot.x.toInt() - 1;
                          if (dayIndex >= 0 &&
                              dayIndex < dailySpendingData.length) {
                            final spending = dailySpendingData[dayIndex];
                            final formattedDate =
                                DateFormat('MMM d').format(spending.date);
                            return LineTooltipItem(
                              '$formattedDate\n${widget.currencySymbol} ${(spot.y * 1000).toStringAsFixed(0)}',
                              const TextStyle(color: Colors.white),
                            );
                          }
                          return null;
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOutQuad)
                  .then(delay: 200.ms)
                  .shimmer(
                      duration: 1000.ms,
                      color: Palette.greyColor.withOpacity(0.7)),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No data available',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTabToggle() {
    return _tabNotifier.sync(builder: (context, tabIndex, child) {
      return Container(
        height: 48,
        width: 220.w,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _buildTabSegment(
                title: 'Expense',
                isSelected: tabIndex == 0,
                onTap: () => _tabNotifier.value = 0),
            _buildTabSegment(
                title: 'Income',
                isSelected: tabIndex == 1,
                onTap: () => _tabNotifier.value = 1),
          ],
        ),
      );
    });
  }

  Widget _buildTabSegment(
      {required String title,
      required bool isSelected,
      required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF8A3FFC) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return _tabNotifier.sync(builder: (context, tabIndex, child) {
      final TransactionType typeFilter =
          tabIndex == 0 ? TransactionType.expense : TransactionType.income;

      return _selectedMonthNotifier.sync(builder: (context, selectedMonth, child) {
        final monthlyTransactions = widget.transactions
            .where((t) =>
                t.transactionType == typeFilter &&
                t.transactionDate.year == selectedMonth.year &&
                t.transactionDate.month == selectedMonth.month)
            .toList();

        _sortNotifier.sync(builder: (context, sortAscending, child) {
          monthlyTransactions.sort((a, b) => sortAscending
              ? b.transactionDate.compareTo(a.transactionDate)
              : a.transactionDate.compareTo(b.transactionDate));
          return const SizedBox.shrink();
        });

        final total = monthlyTransactions.fold(
            0.0, (sum, item) => sum + item.transactionAmount);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: ValueKey('transactions-$tabIndex-${selectedMonth.month}'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tabIndex == 0
                          ? 'Expense Transactions'
                          : 'Income Transactions',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    _sortNotifier.sync(
                      builder: (context, sortType, child) => Icon(
                        sortType
                            ? PhosphorIconsBold.sortAscending
                            : PhosphorIconsBold.sortDescending,
                        size: 22.h,
                        color: Palette.montraPurple,
                      ).tap(
                          onTap: () =>
                              _sortNotifier.value = !_sortNotifier.value),
                    ),
                  ],
                ),
              ),
              10.sbH,
              monthlyTransactions.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'No ${tabIndex == 0 ? 'expenses' : 'income'} for this month',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: monthlyTransactions.length > 30
                          ? 30
                          : monthlyTransactions.length,
                      itemBuilder: (context, index) => TransactionTile(
                        transaction: monthlyTransactions[index],
                        onTileTap: () {},
                      )
                          .animate(delay: Duration(milliseconds: index * 100))
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.2, end: 0, duration: 400.ms),
                      separatorBuilder: (context, index) => 10.sbH,
                    ),
            ],
          ),
        );
      });
    });
  }

  double _calculateGlobalUpperLimit() {
    final now = DateTime.now();

    double maxExpenseAmount = 0.0;
    double maxIncomeAmount = 0.0;

    // Calculate limits for all available months
    final availableMonths = _getAvailableMonths();
    for (final month in availableMonths) {
      final expenseData = _processDailySpendingData(TransactionType.expense, month);
      final incomeData = _processDailySpendingData(TransactionType.income, month);
      
      final monthMaxExpense = expenseData.fold(0.0, (max, data) => data.amount > max ? data.amount : max);
      final monthMaxIncome = incomeData.fold(0.0, (max, data) => data.amount > max ? data.amount : max);
      
      if (monthMaxExpense > maxExpenseAmount) maxExpenseAmount = monthMaxExpense;
      if (monthMaxIncome > maxIncomeAmount) maxIncomeAmount = monthMaxIncome;
    }

    final maxAmount = [maxExpenseAmount, maxIncomeAmount].reduce(math.max);

    if (maxAmount == 0) return 50.0;
    return (maxAmount / 50).ceil() * 50.0;
  }

  List<DailySpending> _processDailySpendingData(TransactionType type, DateTime selectedMonth) {
    final year = selectedMonth.year;
    final month = selectedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final now = DateTime.now();
    final isCurrentMonth = year == now.year && month == now.month;

    final dailySpending = {
      for (var day in List.generate(daysInMonth, (i) => i + 1)) day: 0.0
    };

    double cumulativeSpending = 0;
    for (final transaction in widget.transactions) {
      final date = transaction.transactionDate;
      if (date.year != year ||
          date.month != month ||
          transaction.transactionType != type) {
        continue;
      }

      final day = date.day;
      dailySpending[day] = dailySpending[day]! + transaction.transactionAmount;
    }

    // For current month, only show up to today
    // For past months, show all days
    final maxDay = isCurrentMonth ? now.day : daysInMonth;

    return List.generate(maxDay, (i) {
      final day = i + 1;
      cumulativeSpending += dailySpending[day]!;
      return DailySpending(
        date: DateTime(year, month, day),
        amount: dailySpending[day]!,
        cumulativeAmount: cumulativeSpending,
      );
    });
  }
}

class DailySpending {
  final DateTime date;
  final double amount;
  final double cumulativeAmount;

  DailySpending({
    required this.date,
    required this.amount,
    this.cumulativeAmount = 0,
  });
}