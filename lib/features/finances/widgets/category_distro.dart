import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CategoryDistributionChart extends StatefulWidget {
  final List<Transaction> transactions;
  final double size;
  final Color defaultColor;
  final double strokeWidth;
  final Function(TransactionCategory, double)? onCategoryTap;

  const CategoryDistributionChart({
    Key? key,
    required this.transactions,
    this.size = 200,
    this.defaultColor = Colors.grey,
    this.strokeWidth = 24,
    this.onCategoryTap,
  }) : super(key: key);

  @override
  State<CategoryDistributionChart> createState() => _CategoryDistributionChartState();
}

class _CategoryDistributionChartState extends State<CategoryDistributionChart> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _tabNotifier = 0.notifier;
  late AnimationController _animationController;
  double _animationProgress = 0.0;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chart Section
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Chart (still keeping the circular chart for reference)
              _buildDistributionChart(),
              
              // Total amount in the center
              _tabNotifier.sync(
                builder: (context, tabIndex, child) {
                  final selectedType = tabIndex == 0 
                      ? TransactionType.expense 
                      : TransactionType.income;
                  
                  final total = _getTotalAmount(selectedType);
                  
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'N${total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        selectedType == TransactionType.expense ? 'Spent' : 'Earned',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                  .animate(key: ValueKey('total-$tabIndex'))
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 400.ms);
                }
              ),
            ],
          ),
        ),
        
        // Type Toggle
        30.sbH,
        _buildTabToggle(),
        30.sbH,
        
        // Category Bars
        _tabNotifier.sync(
          builder: (context, tabIndex, child) {
            final selectedType = tabIndex == 0 
                ? TransactionType.expense 
                : TransactionType.income;
            
            return _buildCategoryBars(selectedType, tabIndex);
          }
        ),
      ],
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
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTabSegment(
              title: 'Expense',
              isSelected: tabIndex == 0,
              onTap: () => _tabNotifier.value = 0,
            ),
            _buildTabSegment(
              title: 'Income',
              isSelected: tabIndex == 1,
              onTap: () => _tabNotifier.value = 1,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabSegment({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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

  Widget _buildDistributionChart() {
    return _tabNotifier.sync(
      builder: (context, tabIndex, child) {
        final selectedType = tabIndex == 0 
            ? TransactionType.expense 
            : TransactionType.income;
        
        final categorizedTransactions = _getCategorizedTransactions(selectedType);
        
        if (categorizedTransactions.isEmpty) {
          return Center(
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: EmptyChartPainter(
                strokeWidth: widget.strokeWidth,
                color: widget.defaultColor.withOpacity(0.3),
              ),
            ),
          );
        }

        return Center(
          key: ValueKey('chart-$tabIndex'),
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: AnimatedDistributionChartPainter(
              categorizedTransactions: categorizedTransactions,
              strokeWidth: widget.strokeWidth,
              defaultColor: widget.defaultColor,
              animationProgress: _animationProgress,
            ),
          ),
        );
      }
    );
  }

  Widget _buildCategoryBars(TransactionType type, int tabIndex) {
    Map<TransactionCategory, double> categorizedTransactions = _getCategorizedTransactions(type);
    
    if (categorizedTransactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'No ${type == TransactionType.expense ? "expenses" : "income"} to show',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    // For expenses, ensure we show all categories that have transactions
    if (type == TransactionType.expense) {
      // Get all possible expense categories
      final List<TransactionCategory> allExpenseCategories = TransactionCategory.getExpenseCategories();
      
      // Add any missing categories with zero amount
      for (var category in allExpenseCategories) {
        if (!categorizedTransactions.containsKey(category)) {
          categorizedTransactions[category] = 0;
        }
      }
    }
    
    // Sort by amount descending
    final sortedEntries = categorizedTransactions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Filter out zero amounts
    final nonZeroEntries = sortedEntries.where((entry) => entry.value > 0).toList();

    final totalAmount = _getTotalAmount(type);
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Column(
        key: ValueKey('bars-$tabIndex'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: nonZeroEntries.take(10).toList().asMap().entries.map((mapEntry) {
          final index = mapEntry.key;
          final entry = mapEntry.value;
          
          final category = entry.key;
          final amount = entry.value;
          final percentage = amount / totalAmount;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                if (widget.onCategoryTap != null) {
                  widget.onCategoryTap!(category, amount);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with category name and amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Category name with dot
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: category.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          8.sbW,
                          category.label.toString().txt(size: 13.sp, fontW: F.w4),
                        ],
                      ),
                      
                      // Amount with negative/positive sign
                      Text(
                        '${type == TransactionType.expense ? "- " : "+ "}N${amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: type == TransactionType.expense 
                              ? Colors.redAccent 
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  
                  8.sbH,
                  
                  // Progress bar
                  Stack(
                    children: [
                      // Background bar
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      
                      // Foreground bar with category color
                      TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 500 + (index * 100)),
                        curve: Curves.easeOutCubic,
                        tween: Tween<double>(begin: 0, end: percentage),
                        builder: (context, value, child) {
                          return FractionallySizedBox(
                            widthFactor: value,
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: category.color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
          .animate()
          .fadeIn(delay: Duration(milliseconds: index * 100), duration: 400.ms)
          .slideX(begin: 0.2, end: 0, delay: Duration(milliseconds: index * 100), duration: 400.ms);
        }).toList(),
      ),
    );
  }

  Map<TransactionCategory, double> _getCategorizedTransactions(TransactionType type) {
    // Get current month
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    
    // Filter transactions by selected type and month
    final filteredTransactions = widget.transactions
        .where((t) => t.transactionType == type && 
                      t.transactionDate.year == currentMonth.year && 
                      t.transactionDate.month == currentMonth.month)
        .toList();

    if (filteredTransactions.isEmpty) {
      return {};
    }

    // Group by category
    final Map<TransactionCategory, double> result = {};
    for (final transaction in filteredTransactions) {
      final category = transaction.transactionCategory;
      if (result.containsKey(category)) {
        result[category] = result[category]! + transaction.transactionAmount;
      } else {
        result[category] = transaction.transactionAmount;
      }
    }

    return result;
  }

  double _getTotalAmount(TransactionType type) {
    // Get current month
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    
    return widget.transactions
        .where((t) => t.transactionType == type && 
                     t.transactionDate.year == currentMonth.year && 
                     t.transactionDate.month == currentMonth.month)
        .fold(0, (sum, item) => sum + item.transactionAmount);
  }
}

class AnimatedDistributionChartPainter extends CustomPainter {
  final Map<TransactionCategory, double> categorizedTransactions;
  final double strokeWidth;
  final Color defaultColor;
  final double animationProgress;

  AnimatedDistributionChartPainter({
    required this.categorizedTransactions,
    required this.strokeWidth,
    required this.defaultColor,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Filter out zero values
    final nonZeroTransactions = Map<TransactionCategory, double>.fromEntries(
      categorizedTransactions.entries.where((e) => e.value > 0)
    );
    
    final total = nonZeroTransactions.values.fold(0.0, (a, b) => a + b);
    
    // Empty state
    if (total == 0) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = defaultColor.withOpacity(0.3);
      
      canvas.drawCircle(center, radius, paint);
      return;
    }

    final animProgress = animationProgress.clamp(0.0, 1.0);
    
    // Special case for exactly 2 categories (like income view)
    if (nonZeroTransactions.length == 2) {
      final entries = nonZeroTransactions.entries.toList();
      final firstCategory = entries[0].key;
      final secondCategory = entries[1].key;
      final firstValue = entries[0].value;
      
      // Calculate the proportion of the first category
      final firstProportion = firstValue / total;
      
      // First arc (e.g., Salary/Wages)
      final firstSweepAngle = 2 * math.pi * firstProportion * animProgress;
      final firstPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = firstCategory.color;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // Start at top
        firstSweepAngle,
        false,
        firstPaint,
      );
      
      // Second arc (e.g., Cash Inflow) - always completes the circle during animation
      final secondSweepAngle = 2 * math.pi * (1 - firstProportion) * animProgress;
      final secondPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = secondCategory.color;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2 + firstSweepAngle,
        secondSweepAngle,
        false,
        secondPaint,
      );
      
      return;
    }
    
    // Single category case
    if (nonZeroTransactions.length == 1) {
      final category = nonZeroTransactions.keys.first;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = category.color;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * animProgress,
        false,
        paint,
      );
      return;
    }
    
    // For 3+ categories
    double startAngle = -math.pi / 2;
    double remainingAngle = 2 * math.pi * animProgress;
    final entries = nonZeroTransactions.entries.toList();
    
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final category = entry.key;
      final value = entry.value;
      
      // The last segment gets all remaining angle to ensure the circle is complete
      final sweepAngle = (i == entries.length - 1) 
          ? remainingAngle 
          : (value / total) * 2 * math.pi * animProgress;
      
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = category.color;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      
      startAngle += sweepAngle;
      remainingAngle -= sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is AnimatedDistributionChartPainter) {
      return oldDelegate.categorizedTransactions != categorizedTransactions ||
          oldDelegate.strokeWidth != strokeWidth ||
          oldDelegate.defaultColor != defaultColor ||
          oldDelegate.animationProgress != animationProgress;
    }
    return true;
  }
}

class EmptyChartPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  EmptyChartPainter({
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;
    
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}