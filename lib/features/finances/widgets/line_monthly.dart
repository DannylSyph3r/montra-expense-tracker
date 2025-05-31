import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

class _LineChartMonthlyState extends State<LineChartMonthly>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _tabNotifier = 0.notifier;
  final ValueNotifier<bool> _sortNotifier = true.notifier;
  late AnimationController _animationController;
  double _animationProgress = 0.0;
  late double _globalUpperLimit;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..addListener(() {
        setState(() {
          _animationProgress = _animationController.value;
        });
      });

    _animationController.forward();
    _tabNotifier.addListener(() {
      _animationController.reset();
      _animationController.forward();
    });

    _globalUpperLimit = _calculateGlobalUpperLimit();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabNotifier.dispose();
    _sortNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _globalUpperLimit = _calculateGlobalUpperLimit();

    return Column(
      children: [
        _buildLineChartSection(),
        30.sbH,
        _buildTabToggle(),
        20.sbH,
        _buildTransactionList(),
      ],
    );
  }

  Widget _buildLineChartSection() {
    return _tabNotifier.sync(builder: (context, tabIndex, child) {
      final selectedType =
          tabIndex == 0 ? TransactionType.expense : TransactionType.income;

      final dailySpendingData = _processDailySpendingData(selectedType);

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _buildLineChart(dailySpendingData, selectedType,
            key: ValueKey('chart-$tabIndex')),
      );
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
                      spots: _createAnimatedSpots(dailySpendingData),
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
              ),
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
      final now = DateTime.now();
      final currentMonth = DateTime(now.year, now.month);

      final monthlyTransactions = widget.transactions
          .where((t) =>
              t.transactionType == typeFilter &&
              t.transactionDate.year == currentMonth.year &&
              t.transactionDate.month == currentMonth.month)
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
          key: ValueKey('transactions-$tabIndex'),
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
                    itemBuilder: (context, index) => AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final shouldShow = index <=
                            (_animationController.value *
                                monthlyTransactions.length);
                        return AnimatedOpacity(
                          opacity: shouldShow ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            transform: Matrix4.translationValues(
                                0, shouldShow ? 0 : 20, 0),
                            child: TransactionTile(
                              transaction: monthlyTransactions[index],
                              onTileTap: () {},
                            ),
                          ),
                        );
                      },
                    ),
                    separatorBuilder: (context, index) => 10.sbH,
                  ),
          ],
        ),
      );
    });
  }

  double _calculateGlobalUpperLimit() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;

    double maxExpenseAmount = _processDailySpendingData(TransactionType.expense)
        .fold(0.0, (max, data) => data.amount > max ? data.amount : max);

    double maxIncomeAmount = _processDailySpendingData(TransactionType.income)
        .fold(0.0, (max, data) => data.amount > max ? data.amount : max);

    final maxAmount = [maxExpenseAmount, maxIncomeAmount].reduce(math.max);

    if (maxAmount == 0) return 50.0;
    return (maxAmount / 50).ceil() * 50.0;
  }

  List<DailySpending> _processDailySpendingData(TransactionType type) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final dailySpending = Map<int, double>.fromIterable(
      List.generate(daysInMonth, (i) => i + 1),
      key: (day) => day,
      value: (_) => 0.0,
    );

    double cumulativeSpending = 0;
    for (final transaction in widget.transactions) {
      final date = transaction.transactionDate;
      if (date.year != year ||
          date.month != month ||
          transaction.transactionType != type) continue;

      final day = date.day;
      // REMOVED DIVISION BY 1000 HERE
      dailySpending[day] = dailySpending[day]! + transaction.transactionAmount;
    }

    return List.generate(now.day, (i) {
      final day = i + 1;
      cumulativeSpending += dailySpending[day]!;
      return DailySpending(
        date: DateTime(year, month, day),
        amount: dailySpending[day]!,
        cumulativeAmount: cumulativeSpending,
      );
    });
  }

  List<FlSpot> _createAnimatedSpots(List<DailySpending> data) {
    final progress = _animationProgress;
    final animatedIndex = (data.length * progress).floor();

    return data.asMap().entries.map((entry) {
      final i = entry.key;
      final spending = entry.value;

      if (i > animatedIndex) return FlSpot(spending.date.day.toDouble(), 0);

      if (i == animatedIndex) {
        final fractionalProgress = (data.length * progress) - animatedIndex;
        return FlSpot(
            spending.date.day.toDouble(), spending.amount * fractionalProgress);
      }

      return FlSpot(spending.date.day.toDouble(), spending.amount);
    }).toList();
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
