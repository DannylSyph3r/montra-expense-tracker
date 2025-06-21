import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/snack_bar.dart';
import 'package:expense_tracker_app/utils/type_defs.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/sliver_appbar.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class ClusterSelectionView extends StatefulWidget {
  final String currentCluster;
  final Function(String) onClusterSelected;

  const ClusterSelectionView({
    super.key,
    required this.currentCluster,
    required this.onClusterSelected,
  });

  @override
  State<ClusterSelectionView> createState() => _ClusterSelectionViewState();
}

class _ClusterSelectionViewState extends State<ClusterSelectionView>
    with TickerProviderStateMixin {
  final currencyFormat = NumberFormat.currency(symbol: 'N ', locale: 'en_NG');
  late TabController _tabController;
  final ValueNotifier<int> _currentTabNotifier = ValueNotifier<int>(0);

  final List<Map<String, dynamic>> clusters = [
    {
      'name': 'Ryker Wallet',
      'type': 'Primary Account',
      'balance': 345000.00,
      'icon': PhosphorIconsBold.wallet,
      'color': Palette.montraPurple,
      'isActive': true,
      'accountNumber': '2047851234',
      'lastTransaction': 'Today',
      'bank': 'MoneyWave Bank',
    },
    {
      'name': 'Business Account',
      'type': 'Business',
      'balance': 125000.00,
      'icon': PhosphorIconsBold.briefcase,
      'color': Colors.blue,
      'isActive': true,
      'accountNumber': '4562135678',
      'lastTransaction': 'Yesterday',
      'bank': 'Corporate Trust',
    },
    {
      'name': 'Savings Vault',
      'type': 'High-Yield Savings',
      'balance': 89500.00,
      'icon': PhosphorIconsBold.piggyBank,
      'color': Colors.green,
      'isActive': true,
      'accountNumber': '7893459012',
      'lastTransaction': '3 days ago',
      'bank': 'Savings Plus',
    },
    {
      'name': 'Investment Portfolio',
      'type': 'Investment',
      'balance': 256000.00,
      'icon': PhosphorIconsBold.trendUp,
      'color': Colors.orange,
      'isActive': true,
      'accountNumber': '1597533456',
      'lastTransaction': '1 week ago',
      'bank': 'InvestMax',
    },
    {
      'name': 'Emergency Fund',
      'type': 'Emergency Savings',
      'balance': 50000.00,
      'icon': PhosphorIconsBold.shield,
      'color': Colors.red,
      'isActive': false,
      'accountNumber': '9876547890',
      'lastTransaction': '2 weeks ago',
      'bank': 'Safe Haven Bank',
    },
    {
      'name': 'Travel Fund',
      'type': 'Goal-Based Savings',
      'balance': 15000.00,
      'icon': PhosphorIconsBold.airplane,
      'color': Colors.cyan,
      'isActive': false,
      'accountNumber': '2468131357',
      'lastTransaction': '1 month ago',
      'bank': 'Adventure Bank',
    },
  ];

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
    _currentTabNotifier.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _reactivateAccount(int index) {
    setState(() {
      clusters[index]['isActive'] = true;
    });
    showBanner(
      context: context,
      theMessage: "${clusters[index]['name']} has been reactivated!",
      theType: NotificationType.success,
    );
  }

  void _showReactivateBottomSheet(int index) {
    showCustomModal(
      modalHeight: 400.h,
      context,
      child: Container(
        padding: 20.0.padA,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  PhosphorIconsBold.arrowCounterClockwise,
                  color: Palette.montraPurple,
                  size: 24.h,
                ),
                12.sbW,
                "Reactivate Account".txt18(fontW: F.w6),
              ],
            ),
            20.sbH,
            "Do you want to reactivate your ${clusters[index]['name']}?".txt14(
              color: Palette.greyColor,
            ),
            20.sbH,
            Container(
              padding: 16.0.padA,
              decoration: BoxDecoration(
                color: Palette.greyFill.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    height: 45.h,
                    width: 45.h,
                    decoration: BoxDecoration(
                      color:
                          (clusters[index]['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      clusters[index]['icon'] as IconData,
                      color: clusters[index]['color'] as Color,
                      size: 22.h,
                    ),
                  ),
                  15.sbW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (clusters[index]['name'] as String).txt16(fontW: F.w6),
                        6.sbH,
                        (clusters[index]['type'] as String).txt12(
                          color: Palette.greyColor,
                        ),
                        4.sbH,
                        currencyFormat.format(clusters[index]['balance']).txt14(
                              color: Palette.blackColor,
                              fontW: F.w6,
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            30.sbH,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: "Cancel",
                    color: Palette.greyFill,
                    textColor: Palette.greyColor,
                    onTap: () => goBack(context),
                  ),
                ),
                15.sbW,
                Expanded(
                  child: AppButton(
                    text: "Reactivate",
                    onTap: () {
                      goBack(context);
                      _reactivateAccount(index);
                    },
                  ),
                ),
              ],
            ),
            20.sbH,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.whiteColor,
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
                showLeadingIconOrWidget: true,
                titleCentered: true,
                isTitleAWidget: false,
                title: "Switch Account",
                titleFontSize: 18.sp,
                titleFontWeight: FontWeight.w600,
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
                      tabs: ['Summary', 'Accounts']
                          .map((label) => SizedBox(
                                width: 70.w,
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
                _buildSummaryTab(),
                _buildAccountsTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: 20.padH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.sbH,

          // Total Balance Card
          Container(
            width: double.infinity,
            padding: 24.0.padA,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Palette.montraPurple,
                  Palette.montraPurple.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Palette.montraPurple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Total Portfolio Balance".txt14(
                      color: Palette.whiteColor.withOpacity(0.8),
                      fontW: F.w5,
                    ),
                    Icon(
                      PhosphorIconsBold.wallet,
                      color: Palette.whiteColor.withOpacity(0.8),
                      size: 24.h,
                    ),
                  ],
                ),
                12.sbH,
                currencyFormat.format(_getTotalActiveBalance()).txt(
                      size: 32.sp,
                      color: Palette.whiteColor,
                      fontW: F.w7,
                    ),
              ],
            ),
          ),

          24.sbH,

          // Stats Grid - All three cards in one row
          Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                "Active Accounts",
                "${_getActiveAccountsCount()}",
                PhosphorIconsBold.checkCircle,
                Colors.green,
              )),
              12.sbW,
              Expanded(
                  child: _buildStatCard(
                "Inactive Accounts",
                "${_getInactiveAccountsCount()}",
                PhosphorIconsBold.pauseCircle,
                Colors.orange,
              )),
              12.sbW,
              Expanded(
                  child: _buildStatCard(
                "Total Accounts",
                "${clusters.length}",
                PhosphorIconsBold.stack,
                Palette.montraPurple,
              )),
            ],
          ),

          24.sbH,

          // Account Breakdown
          "Account Breakdown".txt18(fontW: F.w6),
          16.sbH,

          ...clusters.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> cluster = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: 16.0.padA,
              decoration: BoxDecoration(
                color: Palette.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: (cluster['color'] as Color).withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 45.h,
                    width: 45.h,
                    decoration: BoxDecoration(
                      color: (cluster['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      cluster['icon'] as IconData,
                      color: cluster['color'] as Color,
                      size: 22.h,
                    ),
                  ),
                  15.sbW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: (cluster['name'] as String)
                                  .txt(size: 13.sp, fontW: F.w6),
                            ),
                          ],
                        ),
                        5.sbH,
                        Row(
                          children: [
                            currencyFormat.format(cluster['balance']).txt12(
                                  color: Palette.greyColor,
                                ),
                            5.sbW,
                            if (!(cluster['isActive'] as bool))
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: "Inactive".txt(
                                  size: 10.sp,
                                  color: Colors.orange,
                                  fontW: F.w6,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  "${((cluster['balance'] as double) / _getTotalBalance() * 100).toStringAsFixed(1)}%"
                      .txt12(
                    color: Palette.greyColor,
                    fontW: F.w6,
                  ),
                ],
              ),
            )
                .animate(delay: Duration(milliseconds: 100 * index))
                .fadeIn(duration: 300.ms);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAccountsTab() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      itemCount: clusters.length,
      separatorBuilder: (context, index) => 16.sbH,
      itemBuilder: (context, index) {
        final cluster = clusters[index];
        final isSelected = cluster['name'] == widget.currentCluster;
        final isActive = cluster['isActive'] as bool;

        return _buildClusterCard(cluster, index, isSelected, isActive)
            .animate(delay: Duration(milliseconds: 50 * index))
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.1);
      },
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: 14.0.padA,
      decoration: BoxDecoration(
        color: Palette.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 18.h,
              ),
              value.txt(
                size: 18.sp,
                color: Palette.blackColor,
                fontW: F.w7,
              ),
            ],
          ),
          8.sbH,
          label.txt(
            size: 11.sp,
            color: Palette.greyColor,
            fontW: F.w5,
          ),
        ],
      ),
    );
  }

  Widget _buildClusterCard(
      Map<String, dynamic> cluster, int index, bool isSelected, bool isActive) {
    return Container(
      padding: 20.0.padA,
      decoration: BoxDecoration(
        color: isSelected
            ? Palette.montraPurple.withOpacity(0.08)
            : isActive
                ? Palette.whiteColor
                : Palette.greyFill.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: isSelected
            ? Border.all(color: Palette.montraPurple, width: 2)
            : Border.all(color: Palette.greyColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Palette.montraPurple.withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Account Icon
              Container(
                height: 55.h,
                width: 55.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (cluster['color'] as Color),
                      (cluster['color'] as Color).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: (cluster['color'] as Color).withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  cluster['icon'] as IconData,
                  size: 26.h,
                  color: Palette.whiteColor,
                ),
              ),
              16.sbW,

              // Account Info
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
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: "Inactive".txt(
                              size: 10.sp,
                              color: Colors.orange,
                              fontW: F.w6,
                            ),
                          ),
                      ],
                    ),
                    6.sbH,
                    (cluster['type'] as String).txt12(
                      color: Palette.greyColor,
                      fontW: F.w5,
                    ),
                    6.sbH,
                    currencyFormat.format(cluster['balance'] as double).txt18(
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

              // Selection/Action Indicator
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
                  else if (!isActive)
                    Container(
                      height: 28.h,
                      width: 28.h,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Icon(
                        PhosphorIconsBold.arrowCounterClockwise,
                        size: 14.h,
                        color: Colors.orange,
                      ),
                    ).tap(onTap: () => _showReactivateBottomSheet(index))
                  else
                    Container(
                      height: 28.h,
                      width: 28.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Palette.greyColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Account Details
          14.sbH,
          Container(
            padding: 14.0.padA,
            decoration: BoxDecoration(
              color: isSelected
                  ? Palette.montraPurple.withOpacity(0.05)
                  : isActive
                      ? Palette.greyFill.withOpacity(0.3)
                      : Palette.greyFill.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          PhosphorIconsBold.bank,
                          size: 14.h,
                          color: Palette.greyColor,
                        ),
                        6.sbW,
                        (cluster['bank'] as String).txt12(
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
                10.sbH,
                Row(
                  children: [
                    Icon(
                      PhosphorIconsBold.creditCard,
                      size: 14.h,
                      color: Palette.greyColor,
                    ),
                    6.sbW,
                    "Account: ${cluster['accountNumber']}".txt12(
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
              goBack(context);
            }
          : () => _showReactivateBottomSheet(index),
    );
  }

  double _getTotalActiveBalance() {
    return clusters
        .where((cluster) => cluster['isActive'] as bool)
        .fold(0.0, (sum, cluster) => sum + (cluster['balance'] as double));
  }

  double _getTotalBalance() {
    return clusters.fold(
        0.0, (sum, cluster) => sum + (cluster['balance'] as double));
  }

  int _getActiveAccountsCount() {
    return clusters.where((cluster) => cluster['isActive'] as bool).length;
  }

  int _getInactiveAccountsCount() {
    return clusters.where((cluster) => !(cluster['isActive'] as bool)).length;
  }
}
