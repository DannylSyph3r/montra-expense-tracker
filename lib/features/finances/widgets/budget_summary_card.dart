import 'package:expense_tracker_app/features/transactions/models/budget_model.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BudgetSummaryCard extends StatelessWidget {
  final List<Budget> budgets;

  const BudgetSummaryCard({
    Key? key,
    required this.budgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat("#,##0.00", "en_US");
    
    // Calculate summary stats
    final activeBudgets = budgets.where((b) => b.status == BudgetStatus.active).toList();
    final totalBudgeted = activeBudgets.fold(0.0, (sum, budget) => sum + budget.amount);
    final totalSpent = activeBudgets.fold(0.0, (sum, budget) => sum + budget.spentAmount);
    final exceededBudgets = activeBudgets.where((b) => b.isExceeded).length;
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Palette.montraPurple,
            Palette.montraPurple.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Palette.montraPurple.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Budget Overview".txt16(
                    color: Palette.whiteColor,
                    fontW: F.w6,
                  ),
                  4.sbH,
                  "${activeBudgets.length} active budgets".txt12(
                    color: Palette.whiteColor.withValues(alpha: 0.8),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Palette.whiteColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  PhosphorIconsBold.chartPieSlice,
                  color: Palette.whiteColor,
                  size: 20.h,
                ),
              ),
            ],
          ),
          
          20.sbH,
          
          // Main amount display
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Total Spent".txt12(
                color: Palette.whiteColor.withValues(alpha: 0.8),
              ),
              4.sbH,
              Row(
                children: [
                  Icon(
                    PhosphorIconsBold.currencyNgn,
                    color: Palette.whiteColor,
                    size: 24.sp,
                  ),
                  4.sbW,
                  Expanded(
                    child: currencyFormat.format(totalSpent).txt(
                      size: 28.sp,
                      fontW: F.w8,
                      color: Palette.whiteColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              4.sbH,
              "of N${currencyFormat.format(totalBudgeted)} budgeted".txt12(
                color: Palette.whiteColor.withValues(alpha: 0.8),
              ),
            ],
          ),
          
          20.sbH,
          
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Overall Progress".txt12(
                    color: Palette.whiteColor.withValues(alpha: 0.8),
                  ),
                  "${((totalSpent / totalBudgeted) * 100).toStringAsFixed(1)}%".txt12(
                    color: Palette.whiteColor,
                    fontW: F.w6,
                  ),
                ],
              ),
              8.sbH,
              Stack(
                children: [
                  // Background
                  Container(
                    height: 8.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Palette.whiteColor.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  // Progress
                  FractionallySizedBox(
                    widthFactor: totalBudgeted > 0 
                        ? (totalSpent / totalBudgeted).clamp(0.0, 1.0)
                        : 0.0,
                    child: Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Palette.whiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          16.sbH,
          
          // Stats row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: PhosphorIconsBold.checkCircle,
                  label: "On Track",
                  value: "${activeBudgets.length - exceededBudgets}",
                  color: Palette.greenColor,
                ),
              ),
              12.sbW,
              Expanded(
                child: _buildStatItem(
                  icon: PhosphorIconsBold.warning,
                  label: "Exceeded",
                  value: "$exceededBudgets",
                  color: Palette.redColor,
                ),
              ),
              12.sbW,
              Expanded(
                child: _buildStatItem(
                  icon: PhosphorIconsBold.wallet,
                  label: "Remaining",
                  value: "N${currencyFormat.format((totalBudgeted - totalSpent).clamp(0, double.infinity))}",
                  color: Palette.whiteColor,
                  isAmount: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isAmount = false,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Palette.whiteColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 18.h,
          ),
          4.sbH,
          value.txt(
            size: isAmount ? 10.sp : 14.sp,
            fontW: F.w6,
            color: Palette.whiteColor,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          2.sbH,
          label.txt(
            size: 10.sp,
            color: Palette.whiteColor.withValues(alpha: 0.8),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}