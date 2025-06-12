import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/snack_bar.dart';
import 'package:expense_tracker_app/utils/type_defs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

class ClusterSelectorModal extends StatefulWidget {
  final String currentCluster;
  final Function(String) onClusterSelected;

  const ClusterSelectorModal({
    super.key,
    required this.currentCluster,
    required this.onClusterSelected,
  });

  @override
  State<ClusterSelectorModal> createState() => _ClusterSelectorModalState();
}

class _ClusterSelectorModalState extends State<ClusterSelectorModal> {
  final List<Map<String, dynamic>> clusters = [
    {
      'name': 'Ryker Wallet',
      'type': 'Primary Account',
      'balance': 345000.00,
      'icon': PhosphorIconsBold.wallet,
      'color': Palette.montraPurple,
      'isActive': true,
      'accountNumber': '****1234',
      'lastTransaction': 'Today',
    },
    {
      'name': 'Business Account',
      'type': 'Business',
      'balance': 125000.00,
      'icon': PhosphorIconsBold.briefcase,
      'color': Colors.blue,
      'isActive': true,
      'accountNumber': '****5678',
      'lastTransaction': 'Yesterday',
    },
    {
      'name': 'Savings Vault',
      'type': 'High-Yield Savings',
      'balance': 750000.00,
      'icon': PhosphorIconsBold.piggyBank,
      'color': Colors.green,
      'isActive': true,
      'accountNumber': '****9012',
      'lastTransaction': '3 days ago',
    },
    {
      'name': 'Investment Portfolio',
      'type': 'Investment',
      'balance': 1250000.00,
      'icon': PhosphorIconsBold.trendUp,
      'color': Colors.orange,
      'isActive': true,
      'accountNumber': '****3456',
      'lastTransaction': '1 week ago',
    },
    {
      'name': 'Emergency Fund',
      'type': 'Emergency Savings',
      'balance': 200000.00,
      'icon': PhosphorIconsBold.shield,
      'color': Colors.red,
      'isActive': false,
      'accountNumber': '****7890',
      'lastTransaction': '2 weeks ago',
    },
  ];

  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'en_NG',
    symbol: 'N',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Palette.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 15.h),
            width: 60.w,
            height: 4.h,
            decoration: ShapeDecoration(
              color: Palette.montraPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          20.sbH,

          // Header
          Padding(
            padding: 20.padH,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Switch Account".txt18(fontW: F.w6),
                    4.sbH,
                    "Choose your active financial account".txt12(
                      color: Palette.greyColor,
                    ),
                  ],
                ),
                Container(
                  height: 40.h,
                  width: 40.h,
                  decoration: BoxDecoration(
                    color: Palette.montraPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: Palette.montraPurple.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    PhosphorIconsBold.plus,
                    size: 20.h,
                    color: Palette.montraPurple,
                  ),
                ).tap(onTap: () {
                  Navigator.pop(context);
                  showBanner(
                    context: context,
                    theMessage: "Add new account feature coming soon!",
                    theType: NotificationType.info,
                  );
                }),
              ],
            ),
          ),
          15.sbH,

          // Clusters List
          Expanded(
            child: ListView.separated(
              padding: 15.padH,
              itemCount: clusters.length,
              separatorBuilder: (context, index) => 15.sbH,
              itemBuilder: (context, index) {
                final cluster = clusters[index];
                final isSelected = cluster['name'] == widget.currentCluster;
                final isActive = cluster['isActive'] as bool;

                return Container(
                  padding: 18.0.padA,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Palette.montraPurple.withOpacity(0.08)
                        : isActive 
                            ? Palette.whiteColor
                            : Palette.greyFill.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16.r),
                    border: isSelected
                        ? Border.all(color: Palette.montraPurple, width: 2)
                        : Border.all(color: Palette.greyColor.withOpacity(0.2)),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Palette.montraPurple.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Cluster Icon
                          Container(
                            height: 55.h,
                            width: 55.h,
                            decoration: BoxDecoration(
                              color: (cluster['color'] as Color).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: (cluster['color'] as Color).withOpacity(0.3),
                              ),
                            ),
                            child: Icon(
                              cluster['icon'] as IconData,
                              size: 26.h,
                              color: cluster['color'] as Color,
                            ),
                          ),
                          18.sbW,

                          // Cluster Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: (cluster['name'] as String).txt16(
                                        fontW: F.w6,
                                        color: isSelected
                                            ? Palette.montraPurple
                                            : isActive
                                                ? Palette.blackColor
                                                : Palette.greyColor,
                                      ),
                                    ),
                                    if (!isActive)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 3.h),
                                        decoration: BoxDecoration(
                                          color: Palette.redColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: "Inactive".txt(
                                          size: 10.sp,
                                          color: Palette.redColor,
                                          fontW: F.w6,
                                        ),
                                      ),
                                  ],
                                ),
                                6.sbH,
                                (cluster['type'] as String).txt12(
                                  color: Palette.greyColor,
                                  fontW: F.w4,
                                ),
                                4.sbH,
                                currencyFormat
                                    .format(cluster['balance'] as double)
                                    .txt18(
                                  color: isActive
                                      ? isSelected
                                          ? Palette.montraPurple
                                          : Palette.blackColor
                                      : Palette.greyColor,
                                  fontW: F.w7,
                                ),
                              ],
                            ),
                          ),

                          // Selection indicator
                          Column(
                            children: [
                              if (isSelected)
                                Container(
                                  padding: 6.0.padA,
                                  decoration: const BoxDecoration(
                                    color: Palette.montraPurple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    PhosphorIconsBold.check,
                                    size: 14.h,
                                    color: Palette.whiteColor,
                                  ),
                                )
                              else
                                Container(
                                  height: 26.h,
                                  width: 26.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Palette.greyColor.withOpacity(0.4),
                                      width: 2,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Additional account info
                      12.sbH,
                      Container(
                        padding: 12.0.padA,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Palette.montraPurple.withOpacity(0.05)
                              : Palette.greyFill.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  PhosphorIconsBold.creditCard,
                                  size: 14.h,
                                  color: Palette.greyColor,
                                ),
                                6.sbW,
                                (cluster['accountNumber'] as String).txt12(
                                  color: Palette.greyColor,
                                  fontW: F.w5,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  PhosphorIconsBold.clock,
                                  size: 14.h,
                                  color: Palette.greyColor,
                                ),
                                6.sbW,
                                (cluster['lastTransaction'] as String).txt12(
                                  color: Palette.greyColor,
                                  fontW: F.w5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).tap(
                  onTap: isActive
                      ? () {
                          widget.onClusterSelected(cluster['name'] as String);
                          Navigator.pop(context);
                          showBanner(
                            context: context,
                            theMessage: "Switched to ${cluster['name']}",
                            theType: NotificationType.success,
                          );
                        }
                      : () {
                          showBanner(
                            context: context,
                            theMessage: "This account is currently inactive",
                            theType: NotificationType.info,
                          );
                        },
                );
              },
            ),
          ),

          // Bottom section with total portfolio
          Container(
            padding: 20.padH,
            decoration: BoxDecoration(
              color: Palette.greyFill.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.r),
                bottomRight: Radius.circular(25.r),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: 18.0.padA,
                  decoration: BoxDecoration(
                    color: Palette.montraPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                        color: Palette.montraPurple.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                PhosphorIconsBold.chartPieSlice,
                                size: 18.h,
                                color: Palette.montraPurple,
                              ),
                              8.sbW,
                              "Total Portfolio".txt14(
                                color: Palette.greyColor,
                                fontW: F.w5,
                              ),
                            ],
                          ),
                          8.sbH,
                          currencyFormat
                              .format(_getTotalActiveBalance())
                              .txt20(
                            color: Palette.montraPurple,
                            fontW: F.w7,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          "${_getActiveAccountsCount()} Active Accounts".txt12(
                            color: Palette.greyColor,
                            fontW: F.w5,
                          ),
                          4.sbH,
                          "${_getInactiveAccountsCount()} Inactive".txt12(
                            color: Palette.redColor,
                            fontW: F.w5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                15.sbH,
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getTotalActiveBalance() {
    return clusters
        .where((cluster) => cluster['isActive'] as bool)
        .fold(0.0, (sum, cluster) => sum + (cluster['balance'] as double));
  }

  int _getActiveAccountsCount() {
    return clusters.where((cluster) => cluster['isActive'] as bool).length;
  }

  int _getInactiveAccountsCount() {
    return clusters.where((cluster) => !(cluster['isActive'] as bool)).length;
  }
}

void showClusterSelectorModal(
  BuildContext context, {
  required String currentCluster,
  required Function(String) onClusterSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ClusterSelectorModal(
      currentCluster: currentCluster,
      onClusterSelected: onClusterSelected,
    ),
  );
}