import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  TransactionTile({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final NumberFormat _currencyFormat = NumberFormat("#,##0.00", "en_US");
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  final DateFormat _timeFormat = DateFormat('hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLeading(),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.transactionCategory.label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction.transactionDescription,
                  style: TextStyle(fontSize: 14.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          _buildTrailing(),
        ],
      ),
    );
  }

  Widget _buildLeading() {
    return Container(
      height: 55.h,
      width: 55.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: transaction.transactionCategory.color.withOpacity(0.3),
      ),
      child: Icon(
        transaction.transactionCategory.icon,
        size: 25.h,
        color: transaction.transactionCategory.color,
      ),
    );
  }

  Widget _buildTrailing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${transaction.transactionType == TransactionType.expense ? '-' : ''}₦${_currencyFormat.format(transaction.transactionAmount)}',
          style: TextStyle(
            fontSize: 16.sp,
            color: transaction.transactionType == TransactionType.expense ? Colors.red : Colors.green,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          '${_dateFormat.format(transaction.transactionDate)}, ${_timeFormat.format(transaction.transactionDate)}',
          style: TextStyle(fontSize: 12.sp),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}