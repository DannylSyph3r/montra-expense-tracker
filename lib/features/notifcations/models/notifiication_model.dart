import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum NotificationType {
  transaction,
  budget,
  security,
  system,
  promotion,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? actionData;
  final IconData icon;
  final Color color;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionData,
    required this.icon,
    required this.color,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      type: type,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      actionData: actionData,
      icon: icon,
      color: color,
    );
  }
}

// Sample notifications data
class NotificationData {
  static List<NotificationItem> getSampleNotifications() {
    return [
      // Premium Upgrade Notifications
      NotificationItem(
        id: '1',
        title: 'Premium Upgrade',
        message: 'Unlock unlimited categories, advanced analytics, and export features. Upgrade to Premium for just N2,500/month!',
        type: NotificationType.promotion,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        icon: PhosphorIconsBold.crown,
        color: Colors.amber,
      ),
      
      // Budget Exceeded Notifications
      NotificationItem(
        id: '2',
        title: 'Budget Exceeded',
        message: 'Your Entertainment budget for this month has been exceeded by N8,500. Consider adjusting your spending.',
        type: NotificationType.budget,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        icon: PhosphorIconsBold.warning,
        color: Colors.red,
      ),
      
      // Reminder to Log Transactions
      NotificationItem(
        id: '3',
        title: 'Reminder: Log Transactions',
        message: 'You haven\'t logged any transactions today. Don\'t forget to track your expenses to stay on budget!',
        type: NotificationType.system,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        icon: PhosphorIconsBold.plusCircle,
        color: const Color(0xFF7F3DFF), // Palette.montraPurple
      ),
      
      // Budget Goal Achieved
      NotificationItem(
        id: '4',
        title: 'Budget Goal Achieved',
        message: 'Congratulations! You\'ve successfully stayed within your Groceries budget this month. Keep up the great work!',
        type: NotificationType.budget,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        icon: PhosphorIconsBold.trophy,
        color: Colors.green,
      ),
      
      // New Feature Available
      NotificationItem(
        id: '5',
        title: 'New Feature Available',
        message: 'Try our new Receipt Scanner! Take photos of receipts and we\'ll automatically extract transaction details.',
        type: NotificationType.system,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        icon: PhosphorIconsBold.sparkle,
        color: const Color(0xFF7F3DFF),
      ),
      
      // Budget Exceeded (Different category)
      NotificationItem(
        id: '6',
        title: 'Budget Exceeded',
        message: 'Your Transportation budget is 90% spent with 10 days remaining this month. Consider using alternative transport.',
        type: NotificationType.budget,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        icon: PhosphorIconsBold.warningCircle,
        color: Colors.orange,
      ),
      
      // Premium Upgrade (Different message)
      NotificationItem(
        id: '7',
        title: 'Premium Upgrade',
        message: 'Get detailed spending insights and custom reports. Upgrade to Premium and take control of your finances!',
        type: NotificationType.promotion,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        icon: PhosphorIconsBold.chartLineUp,
        color: Colors.amber,
      ),
      
      // Reminder to Log Transactions (Different message)
      NotificationItem(
        id: '8',
        title: 'Reminder: Log Transactions',
        message: 'It\'s been 2 days since your last transaction entry. Keep your budget tracking accurate by logging recent expenses.',
        type: NotificationType.system,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
        icon: PhosphorIconsBold.clockCounterClockwise,
        color: const Color(0xFF7F3DFF),
      ),
      
      // New Feature Available (Different feature)
      NotificationItem(
        id: '9',
        title: 'New Feature Available',
        message: 'Introducing Smart Budget Recommendations! Get personalized suggestions based on your spending patterns.',
        type: NotificationType.system,
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        isRead: true,
        icon: PhosphorIconsBold.brain,
        color: const Color(0xFF7F3DFF),
      ),
      
      // Budget Goal Achieved (Different category)
      NotificationItem(
        id: '10',
        title: 'Budget Goal Achieved',
        message: 'Amazing! You\'ve saved N15,000 from your Dining Out budget this month. Consider investing these savings.',
        type: NotificationType.budget,
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        isRead: true,
        icon: PhosphorIconsBold.piggyBank,
        color: Colors.green,
      ),
      
      // Reminder to Log Transactions (Weekly reminder)
      NotificationItem(
        id: '11',
        title: 'Weekly Reminder: Log Transactions',
        message: 'This week you\'ve only logged 3 transactions. Remember to track all your expenses for better budget management.',
        type: NotificationType.system,
        timestamp: DateTime.now().subtract(const Duration(days: 6)),
        isRead: true,
        icon: PhosphorIconsBold.listBullets,
        color: const Color(0xFF7F3DFF),
      ),
      
      // Premium Upgrade (Trial ending)
      NotificationItem(
        id: '12',
        title: 'Premium Trial Ending',
        message: 'Your Premium trial ends in 3 days. Continue enjoying unlimited features by subscribing now!',
        type: NotificationType.promotion,
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        isRead: true,
        icon: PhosphorIconsBold.clockCountdown,
        color: Colors.amber,
      ),
    ];
  }
}