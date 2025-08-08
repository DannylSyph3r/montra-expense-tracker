import 'dart:ui';
import 'package:expense_tracker_app/features/home/views/cluster_selection_view.dart';
import 'package:expense_tracker_app/features/notifcations/views/notifications_view.dart';
import 'package:expense_tracker_app/utils/widgets/curved_painter.dart';
import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:expense_tracker_app/features/transactions/views/transaction_details_view.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:expense_tracker_app/utils/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker_app/features/base_nav/bloc/nav_cubit.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:badges/badges.dart' as badges;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ValueNotifier _privacyFilter = false.notifier;
  final ValueNotifier<String> _currentCluster = "Ryker Wallet".notifier;
  final ValueNotifier<int> _unreadNotifications =
      3.notifier; //! Badge count placeholder

  @override
  void dispose() {
    _privacyFilter.dispose();
    _currentCluster.dispose();
    _unreadNotifications.dispose();
    super.dispose();
  }

  //! Method for enhanced privacy blur effect
  Widget _buildPrivacyBlur({
    required Widget child,
    required bool isPrivacyOn,
    double blurIntensity = 8.0,
  }) {
    if (!isPrivacyOn) return child;

    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: blurIntensity,
        sigmaY: blurIntensity,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.montraPurple.withValues(alpha: 0.94),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Positioned(
                  top: -5,
                  left: -5,
                  child: AppGraphics.eclipses.png.myImage(height: 200.h),
                ),
                Column(
                  children: [
                    40.sbH,

                    //! Cluster Display/Selection
                    ValueListenableBuilder<String>(
                      valueListenable: _currentCluster,
                      builder: (context, currentCluster, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            currentCluster.txt(
                                size: 16.sp,
                                color: Palette.whiteColor,
                                fontW: F.w6),
                            5.sbW,
                            Icon(
                              PhosphorIconsBold.caretCircleDown,
                              size: 20.h,
                              color: Palette.whiteColor,
                            ),
                          ],
                        ).tap(onTap: () {
                          goTo(
                              context: context,
                              view: ClusterSelectionView(
                                currentCluster: currentCluster,
                                onClusterSelected: (String selectedCluster) {
                                  _currentCluster.value = selectedCluster;
                                  // Update all other cluster related data here
                                },
                              ));
                        });
                      },
                    ),
                    35.sbH,

                    //! Page Header/Greeting Section
                    RowRailer(
                      leading: Column(
                        children: [
                          Row(
                            children: [
                              "Good Morning"
                                  .txt(
                                      size: 18.sp,
                                      color: Palette.whiteColor,
                                      fontW: F.w4)
                                  .alignCenterLeft(),
                              3.sbW,
                              Icon(
                                PhosphorIconsFill.fire,
                                size: 18.h,
                                color: Palette.whiteColor,
                              ),
                            ],
                          ),
                          5.sbH,
                          "Minato Namikaze"
                              .txt(
                                  size: 18.sp,
                                  color: Palette.whiteColor,
                                  fontW: F.w6,
                                  overflow: TextOverflow.ellipsis)
                              .alignCenterLeft()
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .shimmer(
                                duration: 2500.ms,
                                color: const Color(0xFFE879F9),
                                angle: 0,
                              ),
                        ],
                      ),

                      //! Notifications bell
                      trailing: ValueListenableBuilder<int>(
                        valueListenable: _unreadNotifications,
                        builder: (context, unreadCount, child) {
                          return badges.Badge(
                            position:
                                badges.BadgePosition.topEnd(top: -9, end: -6),
                            showBadge: unreadCount > 0,
                            ignorePointer: false,
                            badgeContent: unreadCount > 9
                                ? Icon(Icons.more_horiz,
                                    color: Colors.white, size: 12.h)
                                : Text(
                                    unreadCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            badgeAnimation: const badges.BadgeAnimation.slide(
                              animationDuration: Duration(milliseconds: 300),
                              colorChangeAnimationDuration:
                                  Duration(milliseconds: 300),
                              loopAnimation: false,
                              curve: Curves.fastOutSlowIn,
                              colorChangeAnimationCurve: Curves.easeInCubic,
                            ),
                            badgeStyle: badges.BadgeStyle(
                              shape: badges.BadgeShape.circle,
                              badgeColor: Palette.redColor,
                              padding: EdgeInsets.all(6.w),
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide:
                                  const BorderSide(color: Colors.white, width: 1.5),
                              elevation: 2,
                            ),
                            child: Container(
                              height: 38.h,
                              width: 38.h,
                              decoration: BoxDecoration(
                                color: Palette.greyFill.withValues(alpha: 0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                              ),
                              child: Icon(
                                PhosphorIconsRegular.bellSimple,
                                color: Palette.whiteColor,
                                size: 25.h,
                              ).tap(onTap: () {
                                goTo(
                                    context: context,
                                    view: const NotificationsView());
                              }),
                            ),
                          );
                        },
                      ),
                      rowPadding: 15.padH,
                    ),
                    113.sbH,
                    CustomPaint(
                      size: Size(double.infinity, 50.h),
                      painter: CurvedPainter(),
                    ),

                    //! Recent Transactions
                    _buildTransactionsSection(),
                  ],
                ),

                //! Balance Card
                _buildBalanceCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildBalanceCard() {
  return Positioned(
    top: 190.h,
    left: 0,
    right: 0,
    child: Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          //! Card Shadow
          Container(
            width: 300.w,
            height: 170.h,
            decoration: BoxDecoration(
              color: Palette.montraPurple,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 9,
                  blurRadius: 18,
                  offset: const Offset(5, 10),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -190),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              child: Container(
                width: 345.w,
                decoration: BoxDecoration(
                  color: Palette.montraPurple,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      spreadRadius: 6,
                      blurRadius: 14,
                      offset: const Offset(5, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background Pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.3,
                        child: AppGraphics.cardBG.png.myImage(fit: BoxFit.cover),
                      ),
                    ),
                    
                    // Card Content
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              //! Card Header
                              RowRailer(
                                rowPadding: EdgeInsets.zero,
                                leading: "Total Balance".txt(
                                    size: 16.sp,
                                    fontW: F.w3,
                                    color: Palette.whiteColor),
                                //! Privacy Toggle
                                trailing: _privacyFilter.sync(
                                    builder: (context, privacyOn, child) {
                                  return Icon(
                                    privacyOn
                                        ? PhosphorIconsRegular.eyeSlash
                                        : PhosphorIconsRegular.eye,
                                    color: Palette.whiteColor,
                                    size: 25.h,
                                  ).tap(onTap: () {
                                    _privacyFilter.value = !_privacyFilter.value;
                                  });
                                }),
                              ),
                              10.sbH,
                              //! Balance Count
                              Row(
                                children: [
                                  Expanded(
                                    child: _privacyFilter.sync(
                                        builder: (context, privacyOn, child) {
                                      return _buildPrivacyBlur(
                                        isPrivacyOn: privacyOn,
                                        blurIntensity: 10.0,
                                        child: "N 5,345,000,00".txt(
                                          size: 30.sp,
                                          fontW: F.w7,
                                          overflow: TextOverflow.ellipsis,
                                          color: Palette.whiteColor,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          5.sbH,
                          //! Income and Expense
                          Column(
                            children: [
                              RowRailer(
                                rowPadding: EdgeInsets.zero,
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Palette.whiteColor.withValues(alpha: 0.3)),
                                      child: Padding(
                                        padding: 3.0.padA,
                                        child: Icon(
                                          PhosphorIconsBold.arrowDown,
                                          size: 15.h,
                                          color: Palette.greenColor,
                                        ),
                                      ),
                                    ),
                                    5.sbW,
                                    "Income".txt(
                                        size: 16.sp,
                                        color: Palette.whiteColor,
                                        fontW: F.w3)
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Palette.whiteColor.withValues(alpha: 0.3)),
                                      child: Padding(
                                        padding: 3.0.padA,
                                        child: Icon(
                                          PhosphorIconsBold.arrowUp,
                                          size: 15.h,
                                          color: Palette.redColor,
                                        ),
                                      ),
                                    ),
                                    5.sbW,
                                    "Expenses".txt(
                                        size: 16.sp,
                                        color: Palette.whiteColor,
                                        fontW: F.w3)
                                  ],
                                ),
                              ),
                              15.sbH,
                              RowRailer(
                                rowPadding: EdgeInsets.zero,
                                leading: _privacyFilter.sync(
                                    builder: (context, privacyOn, child) {
                                  return _buildPrivacyBlur(
                                    isPrivacyOn: privacyOn,
                                    blurIntensity: 6.0,
                                    child: "N 745,000.00".txt(
                                        size: 17.sp,
                                        fontW: F.w3,
                                        color: Palette.whiteColor),
                                  );
                                }),
                                trailing: _privacyFilter.sync(
                                    builder: (context, privacyOn, child) {
                                  return _buildPrivacyBlur(
                                    isPrivacyOn: privacyOn,
                                    blurIntensity: 6.0,
                                    child: "N 400,000.00".txt(
                                        size: 17.sp,
                                        fontW: F.w3,
                                        color: Palette.whiteColor),
                                  );
                                }),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    
                    // Border Light Effect
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 2.h,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.r),
                            topRight: Radius.circular(15.r),
                          ),
                          gradient: LinearGradient(
                            begin: const Alignment(-4.0, 0),
                            end: const Alignment(4.0, 0),
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.1),
                              Colors.white.withValues(alpha: 0.3),
                              Colors.white.withValues(alpha: 0.6),
                              Colors.white.withValues(alpha: 0.9),
                              Colors.white.withValues(alpha: 1.0), 
                              Colors.white.withValues(alpha: 0.9),
                              Colors.white.withValues(alpha: 0.6),
                              Colors.white.withValues(alpha: 0.3),
                              Colors.white.withValues(alpha: 0.1),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.1, 0.2, 0.35, 0.42, 0.46, 0.49, 0.5, 0.51, 0.54, 0.58, 0.65, 0.8, 0.9, 1.0],
                          ),
                        ),
                      )
                        // Add blur as a separate effect
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .blur(
                          begin: const Offset(0, 0),
                          end: const Offset(2, 0.5),
                        )
                        .custom(
                          duration: 15000.ms,
                          builder: (context, value, child) {
                            final animationPhase = value * 15;
                            late double slideValue;
                            
                            if (animationPhase <= 1.5) {
                              final progress = animationPhase / 1.5;
                              slideValue = Curves.easeInOut.transform(progress) * 8 - 4;
                            } else {
                              slideValue = 4.5;
                            }
                            
                            return Transform.translate(
                              offset: Offset(slideValue * 100.w, 0),
                              child: child,
                            );
                          },
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ).animate().scale(
    delay: 400.ms,
    duration: 600.ms,
    begin: const Offset(0.8, 0.8),
    curve: Curves.elasticOut,
  );
}

  Widget _buildTransactionsSection() {
    return Container(
      decoration: BoxDecoration(
          color: Palette.whiteColor,
          border: Border.all(color: Palette.whiteColor, width: 1)),
      constraints: BoxConstraints(minHeight: height(context) - 320.h),
      child: Padding(
        padding: 15.padH,
        child: Column(
          children: [
            100.sbH,

            //! Section Header
            RowRailer(
              rowPadding: EdgeInsets.zero,
              leading: "Recent Transactions".txt(size: 16.sp, fontW: F.w5),
              trailing: Container(
                height: 27.h,
                width: 67.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                    color: Palette.montraPurple.withValues(alpha: 0.25)),
                child: Center(
                  child: "See All"
                      .txt(
                          size: 14.sp, color: Palette.montraPurple, fontW: F.w5)
                      .tap(onTap: () {
                    context.read<BaseNavCubit>().moveToPage(1);
                  }),
                ),
              ),
            ),
            20.sbH,

            //! Transaction List
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return TransactionTile(
                  transaction: transactions[index],
                  onTileTap: () {
                    final transaction = transactions[index];

                    // Format currency
                    String formatCurrency(double amount) {
                      return "N${amount.toStringAsFixed(2)}";
                    }

                    // Format time
                    String formatTime(DateTime dateTime) {
                      return DateFormat('h:mm a').format(dateTime);
                    }

                    // Format Date
                    String formatDate(DateTime dateTime) {
                      return DateFormat('EEEE dd MMMM, yyyy').format(dateTime);
                    }

                    goTo(
                      context: context,
                      view: TransactionsDetailsView(
                        transactionAmount:
                            formatCurrency(transaction.transactionAmount),
                        transactionType:
                            transaction.transactionType.name.toCapitalized(),
                        category: transaction.transactionCategory.label,
                        time: formatTime(transaction.transactionDate),
                        date: formatDate(transaction.transactionDate),
                        description: transaction.transactionDescription,
                        attachmentImages:
                            null,
                        onDelete: () {
                          // Handle delete logic here
                          setState(() {
                            transactions.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                )
                    .animate(delay: Duration(milliseconds: index * 100))
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: 0.2, end: 0, duration: 400.ms);
              },
              separatorBuilder: (context, index) => 10.sbH,
            ),
            100.sbH,
          ],
        ),
      ),
    );
  }
}
