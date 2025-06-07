import 'package:expense_tracker_app/features/base_nav/wrapper/base_nav_wrapper.dart';
import 'package:expense_tracker_app/features/transactions/models/budget_model.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BudgetConfirmationView extends StatelessWidget {
  final Budget budget;

  const BudgetConfirmationView({
    super.key,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat("#,##0.00", "en_US");
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive card width with side padding
    final cardWidth = screenWidth > 600 
        ? 400.0  // Max width for tablets/large screens
        : screenWidth - 40.w; // Mobile with side padding
    
    // Side padding that scales with screen size
    final sidePadding = screenWidth > 600 
        ? (screenWidth - 400) / 2  // Center on large screens
        : 20.w; // Standard mobile padding

    return Scaffold(
      backgroundColor: Palette.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sidePadding),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    // Success Content
                    Expanded(
                      flex: screenHeight < 700 ? 2 : 3,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Success Icon
                            Container(
                              height: 75.h,
                              width: 75.h,
                              decoration: BoxDecoration(
                                color: Palette.greenColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                PhosphorIconsBold.checkCircle,
                                size: 50.h,
                                color: Palette.greenColor,
                              ),
                            ),
                            
                            20.sbH,
                            
                            // Success Message
                            "Budget Created!".txt(size: 24.sp, fontW: F.w6),
                            
                            10.sbH,
                            
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: "Your budget is now active and ready to help you track your spending."
                                  .txt(
                                size: 14.sp,
                                color: Palette.greyColor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            
                            30.sbH,
                            
                            // Budget Summary Card
                            Container(
                              width: cardWidth,
                              constraints: BoxConstraints(
                                maxWidth: 400.w,
                              ),
                              padding: 20.0.padA,
                              decoration: BoxDecoration(
                                color: Palette.greyFill,
                                borderRadius: BorderRadius.circular(15.r),
                                border: Border.all(
                                  color: budget.category.color.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Category Icon and Name
                                  Row(
                                    children: [
                                      Container(
                                        height: 45.h,
                                        width: 45.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                          color: budget.category.color.withOpacity(0.25),
                                        ),
                                        child: Icon(
                                          budget.category.icon,
                                          size: 22.h,
                                          color: budget.category.color,
                                        ),
                                      ),
                                      15.sbW,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            budget.category.label.txt(
                                              size: 16.sp,
                                              fontW: F.w6,
                                            ),
                                            4.sbH,
                                            budget.description.txt(
                                              size: 12.sp,
                                              color: Palette.greyColor,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  20.sbH,
                                  
                                  // Budget Amount
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: "N${currencyFormat.format(budget.amount)}".txt(
                                          size: 28.sp,
                                          fontW: F.w8,
                                          color: Palette.montraPurple,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  8.sbH,
                                  
                                  "${budget.periodLabel} Budget".txt(
                                    size: 12.sp,
                                    color: Palette.greyColor,
                                  ),
                                  
                                  20.sbH,
                                  
                                  // Budget Details
                                  Container(
                                    padding: 15.0.padA,
                                    decoration: BoxDecoration(
                                      color: Palette.whiteColor,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildDetailRow(
                                          "Start Date",
                                          DateFormat('dd MMM, yyyy').format(budget.startDate),
                                        ),
                                        _buildDetailRow(
                                          "End Date",
                                          DateFormat('dd MMM, yyyy').format(budget.endDate),
                                        ),
                                        _buildDetailRow(
                                          "Duration",
                                          "${budget.endDate.difference(budget.startDate).inDays + 1} days",
                                        ),
                                        _buildDetailRow(
                                          "Recurring",
                                          budget.isRecurring ? "Yes" : "No",
                                          isLast: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  if (budget.isRecurring) ...[
                                    10.sbH,
                                    Row(
                                      children: [
                                        Icon(
                                          PhosphorIconsBold.repeat,
                                          size: 14.h,
                                          color: Palette.greenColor,
                                        ),
                                        8.sbW,
                                        Expanded(
                                          child: "This budget will automatically renew when it expires"
                                              .txt(
                                            size: 11.sp,
                                            color: Palette.greenColor,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Action Buttons
                    Container(
                      width: cardWidth,
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Column(
                        children: [
                          // View Budget Button
                          AppButton(
                            text: "View My Budgets",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            onTap: () {
                              // Go back to replace the create budget view in stack
                              // This will return to the finance view budgets tab
                              goBack(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          label.txt(
            size: 12.sp,
            color: Palette.greyColor,
          ),
          value.txt(
            size: 12.sp,
            fontW: F.w5,
          ),
        ],
      ),
    );
  }
}