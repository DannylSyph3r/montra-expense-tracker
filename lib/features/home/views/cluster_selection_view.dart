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
      context,
      modalHeight: 380.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Icon(
                  PhosphorIconsBold.arrowCounterClockwise,
                  color: Palette.montraPurple,
                  size: 24.h,
                ),
                12.sbW,
                "Reactivate Account".txt(size: 18.sp, fontW: F.w6),
              ],
            ),

            20.sbH,

            // Content
            "Do you want to reactivate your ${clusters[index]['name']}?".txt(
              size: 14.sp,
              color: Palette.greyColor,
            ),

            20.sbH,

            // Account preview card
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
                        (clusters[index]['name'] as String)
                            .txt(size: 16.sp, fontW: F.w6),
                        6.sbH,
                        (clusters[index]['type'] as String).txt(
                          size: 12.sp,
                          color: Palette.greyColor,
                        ),
                        4.sbH,
                        currencyFormat.format(clusters[index]['balance']).txt(
                              size: 14.sp,
                              color: Palette.blackColor,
                              fontW: F.w6,
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: "Cancel",
                    color: Palette.greyFill,
                    textColor: Palette.greyColor,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                15.sbW,
                Expanded(
                  child: AppButton(
                    text: "Reactivate",
                    onTap: () {
                      _reactivateAccount(index);
                      Navigator.of(context).pop();
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
                    "Total Portfolio Balance".txt(
                      size: 14.sp,
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
          "Account Breakdown".txt(size: 18.sp, fontW: F.w6),
          16.sbH,

          ...clusters.asMap().entries.map((entry) {
            final index = entry.key;
            final cluster = entry.value;
            final isActive = cluster['isActive'] as bool;

            return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: 16.0.padA,
                decoration: BoxDecoration(
                  color: Palette.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isActive
                        ? (cluster['color'] as Color).withOpacity(0.3)
                        : Palette.greyColor.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.blackColor.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Opacity(
                  opacity: cluster['isActive']
                      ? 1.0
                      : 0.5, // Add this line for greyed out effect
                  child: Row(
                    children: [
                      Container(
                        height: 40.h,
                        width: 40.h,
                        decoration: BoxDecoration(
                          color: (cluster['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          cluster['icon'] as IconData,
                          color: cluster['color'] as Color,
                          size: 20.h,
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
                                currencyFormat.format(cluster['balance']).txt(
                                      size: 12.sp,
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
                          .txt(
                        size: 12.sp,
                        color: Palette.greyColor,
                        fontW: F.w6,
                      ),
                    ],
                  ),
                )
                    .animate(delay: Duration(milliseconds: 100 * index))
                    .fadeIn(duration: 300.ms));
          }).toList(),
          50.sbH
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
      padding: 16.0.padA,
      decoration: BoxDecoration(
        color: isSelected
            ? Palette.montraPurple.withOpacity(0.05)
            : Palette.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected
              ? Palette.montraPurple.withOpacity(0.5)
              : Palette.greyColor.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Palette.blackColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            children: [
              // Icon
              Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                  color: isActive
                      ? (cluster['color'] as Color).withOpacity(0.1)
                      : Palette.greyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  cluster['icon'] as IconData,
                  color:
                      isActive ? cluster['color'] as Color : Palette.greyColor,
                  size: 20.h,
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
                          child: (cluster['name'] as String).txt(
                            size: 16.sp,
                            fontW: F.w6,
                            color: isActive
                                ? (isSelected
                                    ? Palette.montraPurple
                                    : Palette.blackColor)
                                : Palette.greyColor,
                          ),
                        ),
                        // More options button for active accounts
                        if (isActive && !isSelected)
                          PopupMenuButton<String>(
                            onSelected: (value) =>
                                _handleClusterAction(value, index, cluster),
                            icon: Icon(
                              PhosphorIconsBold.dotsThreeVertical,
                              size: 18.h,
                              color: Palette.greyColor,
                            ),
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'disable',
                                child: Row(
                                  children: [
                                    Icon(
                                      PhosphorIconsBold.pauseCircle,
                                      size: 16.h,
                                      color: Colors.orange,
                                    ),
                                    8.sbW,
                                    "Disable Account".txt(
                                      size: 14.sp,
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      PhosphorIconsBold.trash,
                                      size: 16.h,
                                      color: Colors.red,
                                    ),
                                    8.sbW,
                                    "Delete Account".txt(
                                      size: 14.sp,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    4.sbH,
                    currencyFormat.format(cluster['balance'] as double).txt(
                          size: 14.sp,
                          color: Palette.greyColor,
                          fontW: F.w5,
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
                  ? Palette.montraPurple.withOpacity(0.1)
                  : isActive
                      ? Palette.greyFill.withOpacity(0.3)
                      : Palette.greyFill.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      PhosphorIconsBold.bank,
                      size: 14.h,
                      color: Palette.greyColor,
                    ),
                    6.sbW,
                    (cluster['bank'] as String).txt(size: 12.sp,
                      color: Palette.greyColor,
                      fontW: F.w5,
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
                    "${cluster['accountNumber']}".txt(size: 12.sp,
                      color: Palette.greyColor,
                      fontW: F.w5,
                    ),
                  ],
                ),
                10.sbH,
                Row(
                  children: [
                    Icon(
                      PhosphorIconsBold.clock,
                      size: 14.h,
                      color: Palette.greyColor,
                    ),
                    6.sbW,
                    (cluster['lastTransaction'] as String).txt(size: 12.sp,
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

// Handler for cluster actions (disable/delete)
  void _handleClusterAction(
      String action, int index, Map<String, dynamic> cluster) {
    switch (action) {
      case 'disable':
        _showDisableConfirmation(index, cluster);
        break;
      case 'delete':
        _showDeleteConfirmation(index, cluster);
        break;
    }
  }

// Show disable confirmation modal
  void _showDisableConfirmation(int index, Map<String, dynamic> cluster) {
    showCustomModal(
      context,
      modalHeight: 280.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Icon(
                  PhosphorIconsBold.pauseCircle,
                  color: Colors.orange,
                  size: 24.h,
                ),
                12.sbW,
                "Disable Account".txt(
                  size: 18.sp,
                  fontW: F.w6,
                ),
              ],
            ),

            20.sbH,

            // Content
            "Are you sure you want to disable ${cluster['name']}?".txt(
              size: 14.sp,
              color: Palette.blackColor,
              fontW: F.w6,
            ),
            12.sbH,
            "This account will be hidden from your main view but can be reactivated later."
                .txt(
              size: 12.sp,
              color: Palette.greyColor,
            ),

            const Spacer(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    color: Palette.greyFill,
                    textColor: Palette.blackColor,
                    text: "Cancel",
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                15.sbW,
                Expanded(
                  child: AppButton(
                    color: Colors.orange,
                    text: "Disable",
                    onTap: () {
                      _disableCluster(index);
                      Navigator.of(context).pop();
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

// Show delete confirmation modal
  void _showDeleteConfirmation(int index, Map<String, dynamic> cluster) {
    showCustomModal(
      context,
      modalHeight: 380.h,
      child: Padding(
        padding: 20.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Icon(
                  PhosphorIconsBold.trash,
                  color: Colors.red,
                  size: 24.h,
                ),
                12.sbW,
                "Delete Account".txt(
                  size: 18.sp,
                  fontW: F.w6,
                ),
              ],
            ),

            20.sbH,

            // Content
            "Are you sure you want to permanently delete ${cluster['name']}?"
                .txt(
              size: 14.sp,
              color: Palette.blackColor,
              fontW: F.w6,
            ),
            12.sbH,
            "⚠️ This action cannot be undone. All transaction history for this account will be permanently lost."
                .txt(
              size: 12.sp,
              color: Colors.red,
            ),

            16.sbH,

            // Warning box
            Container(
              padding: 12.0.padA,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsBold.warning,
                    color: Colors.red,
                    size: 16.h,
                  ),
                  8.sbW,
                  Expanded(
                    child:
                        "Balance: ${currencyFormat.format(cluster['balance'] as double)} will be lost"
                            .txt(
                      size: 12.sp,
                      color: Colors.red,
                      fontW: F.w5,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    color: Palette.greyFill,
                    textColor: Palette.blackColor,
                    text: "Cancel",
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                15.sbW,
                Expanded(
                  child: AppButton(
                    color: Colors.red,
                    text: "Delete Permanently",
                    fontSize: 11.sp,
                    onTap: () {
                      _deleteCluster(index);
                      Navigator.of(context).pop();
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

// Method to disable a cluster
  void _disableCluster(int index) {
    setState(() {
      clusters[index]['isActive'] = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: "Account disabled successfully".txt(color: Colors.white),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

// Method to delete a cluster
  void _deleteCluster(int index) {
    final clusterName = clusters[index]['name'] as String;

    setState(() {
      clusters.removeAt(index);
    });

    // If the deleted cluster was the current selected one, switch to the first available
    if (widget.currentCluster == clusterName && clusters.isNotEmpty) {
      final newCluster = clusters.firstWhere(
        (cluster) => cluster['isActive'] as bool,
        orElse: () => clusters.first,
      );
      widget.onClusterSelected(newCluster['name'] as String);
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: "Account deleted successfully".txt(color: Colors.white),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
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
