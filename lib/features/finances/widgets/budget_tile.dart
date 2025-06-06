import 'package:expense_tracker_app/features/transactions/models/budget_model.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BudgetTile extends StatelessWidget {
  final Budget budget;
  final VoidCallback onTileTap;
  final VoidCallback? onMoreTap;

  BudgetTile({
    Key? key,
    required this.budget,
    required this.onTileTap,
    this.onMoreTap,
  }) : super(key: key);

  final NumberFormat _currencyFormat = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Palette.greyFill,
        borderRadius: BorderRadius.circular(15.r),
        border: budget.isExceeded
            ? Border.all(color: Palette.redColor.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Category Icon
              Container(
                height: 45.h,
                width: 45.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: budget.category.color.withValues(alpha: 0.25),
                ),
                child: Icon(
                  budget.category.icon,
                  size: 22.h,
                  color: budget.category.color,
                ),
              ),
              12.sbW,
              
              // Category and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            budget.category.label,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Status indicator
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            _getStatusLabel(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    4.sbH,
                    Text(
                      budget.description.isNotEmpty 
                          ? budget.description 
                          : '${budget.periodLabel} budget',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Palette.greyColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // More Button
              IconButton(
                onPressed: onMoreTap,
                icon: Icon(
                  PhosphorIconsBold.dotsThreeVertical,
                  size: 18.h,
                  color: Palette.greyColor,
                ),
                constraints: BoxConstraints(
                  minWidth: 30.w,
                  minHeight: 30.h,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          
          16.sbH,
          
          // Progress Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount spent vs budget
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'N${_currencyFormat.format(budget.spentAmount)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: budget.isExceeded ? Palette.redColor : Colors.black,
                    ),
                  ),
                  Text(
                    'of N${_currencyFormat.format(budget.amount)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Palette.greyColor,
                    ),
                  ),
                ],
              ),
              
              8.sbH,
              
              // Progress Bar
              Stack(
                children: [
                  // Background bar
                  Container(
                    height: 8.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  
                  // Progress bar
                  FractionallySizedBox(
                    widthFactor: budget.progressPercentage.clamp(0.0, 1.0),
                    child: Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: _getProgressColor(),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ],
              ),
              
              8.sbH,
              
              // Bottom info row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remaining/Exceeded amount
                  Row(
                    children: [
                      Icon(
                        budget.isExceeded 
                            ? PhosphorIconsBold.warning 
                            : PhosphorIconsBold.wallet,
                        size: 14.h,
                        color: budget.isExceeded ? Palette.redColor : Palette.greenColor,
                      ),
                      4.sbW,
                      Text(
                        budget.isExceeded 
                            ? 'N${_currencyFormat.format(budget.spentAmount - budget.amount)} over'
                            : 'N${_currencyFormat.format(budget.remainingAmount)} left',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: budget.isExceeded ? Palette.redColor : Palette.greenColor,
                        ),
                      ),
                    ],
                  ),
                  
                  // Time remaining
                  Row(
                    children: [
                      Icon(
                        PhosphorIconsBold.clock,
                        size: 14.h,
                        color: Palette.greyColor,
                      ),
                      4.sbW,
                      Text(
                        '${budget.daysRemaining} days left',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Palette.greyColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).tap(onTap: onTileTap);
  }

  Color _getProgressColor() {
    if (budget.isExceeded) return Palette.redColor;
    if (budget.progressPercentage > 0.8) return Colors.orange;
    return Palette.greenColor;
  }

  Color _getStatusColor() {
    switch (budget.status) {
      case BudgetStatus.active:
        return budget.isExceeded ? Palette.redColor : Palette.greenColor;
      case BudgetStatus.expired:
        return Palette.greyColor;
      case BudgetStatus.upcoming:
        return Palette.blue;
    }
  }

  String _getStatusLabel() {
    if (budget.status == BudgetStatus.active && budget.isExceeded) {
      return 'EXCEEDED';
    }
    switch (budget.status) {
      case BudgetStatus.active:
        return 'ACTIVE';
      case BudgetStatus.expired:
        return 'EXPIRED';
      case BudgetStatus.upcoming:
        return 'UPCOMING';
    }
  }
}