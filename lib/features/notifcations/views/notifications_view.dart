import 'package:expense_tracker_app/features/notifcations/models/notifiication_model.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final ValueNotifier<List<NotificationItem>> _notificationsNotifier =
      ValueNotifier<List<NotificationItem>>(
          NotificationData.getSampleNotifications());

  @override
  void dispose() {
    _notificationsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      appBar: customAppBar(
        title: "Notifications",
        context: context,
        toolbarHeight: 60.h,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        isTitleCentered: true,
      ),
      body: ValueListenableBuilder<List<NotificationItem>>(
        valueListenable: _notificationsNotifier,
        builder: (context, notifications, child) {
          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          final hasUnread = notifications.any((n) => !n.isRead);

          return Column(
            children: [
              // Animated Mark All As Read Section
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: hasUnread ? 80.h : 0,
                width: double.infinity,
                padding: hasUnread
                    ? EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h)
                    : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: hasUnread
                      ? Palette.montraPurple.withOpacity(0.05)
                      : Colors.transparent,
                  border: hasUnread
                      ? Border(
                          bottom: BorderSide(
                            color: Palette.greyColor.withOpacity(0.1),
                          ),
                        )
                      : null,
                ),
                child: hasUnread
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                PhosphorIconsBold.warningCircle,
                                size: 15.h,
                                color: Palette.montraPurple,
                              ),
                              5.sbW,
                              "You have ${notifications.where((n) => !n.isRead).length} unread notifications"
                                  .txt12(
                                color: Palette.greyColor,
                                fontW: F.w5,
                              ),
                            ],
                          ),
                          3.sbH,
                          TextButton(
                            onPressed: _markAllAsRead,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.h, horizontal: 19.w),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: "Mark all as read".txt12(
                              color: Palette.montraPurple,
                              fontW: F.w6,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),

              // Notifications List - Direct listing without date grouping
              Expanded(
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) =>
                      8.sbH, // More compact spacing
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationTile(notification);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    return Container(
      padding: 10.0.padA, // Reduced from 12
      decoration: BoxDecoration(
        color: notification.isRead ? Palette.whiteColor : Palette.greyFill,
        borderRadius: BorderRadius.circular(10.r), // Reduced from 12
        border: Border.all(
          color: notification.isRead
              ? Palette.greyColor.withOpacity(0.2)
              : notification.color.withOpacity(0.3),
          width: notification.isRead ? 1 : 2,
        ),
        boxShadow: notification.isRead
            ? null
            : [
                BoxShadow(
                  color: notification.color.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification Icon - smaller
          Container(
            height: 32.h, // Reduced from 36
            width: 32.h, // Reduced from 36
            decoration: BoxDecoration(
              color: notification.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r), // Reduced from 10
              border: Border.all(
                color: notification.color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              notification.icon,
              size: 16.h, // Reduced from 18
              color: notification.color,
            ),
          ),
          10.sbW, // Reduced from 12

          // Notification Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: notification.title.txt(
                        size: 13.sp,
                        fontW: F.w6,
                        color: notification.isRead
                            ? Palette.blackColor
                            : Palette.blackColor,
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 5.w, // Reduced from 6
                        height: 5.w, // Reduced from 6
                        decoration: const BoxDecoration(
                          color: Palette.montraPurple,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                4.sbH,
                notification.message.txt(
                  size: 11.sp,
                  color: Palette.greyColor,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  height: 1.2,
                ),
                8.sbH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date display on bottom left with new formatting
                    _formatTileDate(notification.timestamp).txt(
                      size: 9.sp, // Reduced from 10
                      color: Palette.greyColor.withOpacity(0.8),
                      fontW: F.w5,
                    ),
                    // Action button for certain notification types
                    if (_shouldShowActionButton(notification))
                      _buildActionButton(notification),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).tap(onTap: () => _onNotificationTap(notification));
  }

  String _formatTileDate(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    // Only show dd/mm/yyyy format for notifications older than 14 days
    if (difference.inDays >= 14) {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    } else {
      // For items newer than 14 days, show relative format
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else {
        return '${difference.inDays}d ago';
      }
    }
  }

  bool _shouldShowActionButton(NotificationItem notification) {
    return notification.type == NotificationType.promotion ||
        (notification.type == NotificationType.system &&
            (notification.title.contains('New Feature') ||
                notification.title.contains('Reminder')));
  }

  Widget _buildActionButton(NotificationItem notification) {
    String buttonText = '';
    Color buttonColor = Palette.montraPurple;

    switch (notification.type) {
      case NotificationType.promotion:
        buttonText = 'Upgrade';
        buttonColor = Colors.amber;
        break;
      case NotificationType.system:
        if (notification.title.contains('New Feature')) {
          buttonText = 'Try Now';
          buttonColor = Palette.montraPurple;
        } else if (notification.title.contains('Reminder')) {
          buttonText = 'Log Now';
          buttonColor = Palette.montraPurple;
        }
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h), // More compact
      decoration: BoxDecoration(
        color: buttonColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r), // Reduced from 8
        border: Border.all(color: buttonColor.withOpacity(0.3)),
      ),
      child: buttonText.txt(
        size: 11.sp,
        color: buttonColor,
        fontW: F.w6,
      ),
    ).tap(onTap: () => _onActionButtonTap(notification));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: 40.padH,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100.h,
              width: 100.h,
              decoration: BoxDecoration(
                color: Palette.greyFill,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Palette.greyColor.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                PhosphorIconsBold.bellSlash,
                size: 45.h,
                color: Palette.greyColor,
              ),
            ),
            25.sbH,
            "No Notifications".txt20(fontW: F.w6),
            15.sbH,
            "You're all caught up! Check back later for updates on your transactions, budgets, and new features."
                .txt14(
              color: Palette.greyColor,
              textAlign: TextAlign.center,
              height: 1.5,
            ),
            30.sbH,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Palette.montraPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Palette.montraPurple.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    PhosphorIconsBold.info,
                    size: 16.h,
                    color: Palette.montraPurple,
                  ),
                  8.sbW,
                  "Enable notifications to stay updated".txt12(
                    color: Palette.montraPurple,
                    fontW: F.w5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNotificationTap(NotificationItem notification) {
    // Mark as read if not already read
    if (!notification.isRead) {
      _markAsRead(notification.id);
    }

    // Handle notification action based on type
    switch (notification.type) {
      case NotificationType.promotion:
        // Navigate to premium upgrade page
        // Example: goTo(context: context, view: PremiumUpgradeView());
        break;
      case NotificationType.budget:
        // Navigate to budget view or specific budget
        // Example: goTo(context: context, view: BudgetView());
        break;
      case NotificationType.system:
        if (notification.title.contains('Reminder')) {
          // Navigate to add transaction view
          // Example: goTo(context: context, view: AddTransactionView());
        } else if (notification.title.contains('New Feature')) {
          // Navigate to feature introduction or specific feature
          // Example: goTo(context: context, view: ReceiptScannerView());
        }
        break;
      case NotificationType.transaction:
        // Navigate to transaction details or transactions view
        // Example: goTo(context: context, view: TransactionsView());
        break;
      case NotificationType.security:
        // Navigate to security settings
        // Example: goTo(context: context, view: AccountSettingsView());
        break;
    }
  }

  void _onActionButtonTap(NotificationItem notification) {
    // Handle action button specific actions
    switch (notification.type) {
      case NotificationType.promotion:
        // Direct to upgrade flow
        break;
      case NotificationType.system:
        if (notification.title.contains('Reminder')) {
          // Direct to add transaction
        } else if (notification.title.contains('Reminder')) {
          // Direct to add transaction
        } else if (notification.title.contains('New Feature')) {
          // Direct to try the feature
        }
        break;
      default:
        break;
    }

    // Mark as read after action
    if (!notification.isRead) {
      _markAsRead(notification.id);
    }
  }

  void _markAsRead(String notificationId) {
    final notifications = _notificationsNotifier.value;
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final updatedNotifications = List<NotificationItem>.from(notifications);
      updatedNotifications[index] = notifications[index].copyWith(isRead: true);
      _notificationsNotifier.value = updatedNotifications;
    }
  }

  void _markAllAsRead() {
    final notifications = _notificationsNotifier.value;
    final updatedNotifications = notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();
    _notificationsNotifier.value = updatedNotifications;
  }
}
