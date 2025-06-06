import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';

enum BudgetPeriod { weekly, monthly, quarterly, yearly, custom }

enum BudgetStatus { active, expired, upcoming }

class Budget {
  final String id;
  final TransactionCategory category;
  final double amount;
  final String description;
  final BudgetPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final bool isRecurring;
  final BudgetStatus status;
  final double spentAmount;
  final DateTime createdAt;

  Budget({
    required this.id,
    required this.category,
    required this.amount,
    required this.description,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.isRecurring,
    required this.status,
    this.spentAmount = 0.0,
    required this.createdAt,
  });

  // Calculate remaining amount
  double get remainingAmount => amount - spentAmount;

  // Calculate progress percentage
  double get progressPercentage {
    if (amount == 0) return 0.0;
    return (spentAmount / amount).clamp(0.0, 1.0);
  }

  // Check if budget is exceeded
  bool get isExceeded => spentAmount > amount;

  // Get days remaining in budget period
  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays + 1;
  }

  // Calculate budget period duration
  Duration get periodDuration => endDate.difference(startDate);

  // Get budget period label
  String get periodLabel {
    switch (period) {
      case BudgetPeriod.weekly:
        return 'Weekly';
      case BudgetPeriod.monthly:
        return 'Monthly';
      case BudgetPeriod.quarterly:
        return 'Quarterly';
      case BudgetPeriod.yearly:
        return 'Yearly';
      case BudgetPeriod.custom:
        return '${periodDuration.inDays} days';
    }
  }

  // Create a copy with updated values
  Budget copyWith({
    String? id,
    TransactionCategory? category,
    double? amount,
    String? description,
    BudgetPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    bool? isRecurring,
    BudgetStatus? status,
    double? spentAmount,
    DateTime? createdAt,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isRecurring: isRecurring ?? this.isRecurring,
      status: status ?? this.status,
      spentAmount: spentAmount ?? this.spentAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'amount': amount,
      'description': description,
      'period': period.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isRecurring': isRecurring,
      'status': status.name,
      'spentAmount': spentAmount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  static Budget fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: TransactionCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      amount: json['amount'].toDouble(),
      description: json['description'],
      period: BudgetPeriod.values.firstWhere(
        (e) => e.name == json['period'],
      ),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isRecurring: json['isRecurring'],
      status: BudgetStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      spentAmount: json['spentAmount']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// Sample budgets for testing
List<Budget> sampleBudgets = [
  Budget(
    id: '1',
    category: TransactionCategory.groceries,
    amount: 50000.0,
    description: 'Monthly grocery budget',
    period: BudgetPeriod.monthly,
    startDate: DateTime(2025, 5, 1),
    endDate: DateTime(2025, 5, 31),
    isRecurring: true,
    status: BudgetStatus.active,
    spentAmount: 32000.0,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
  ),
  Budget(
    id: '2',
    category: TransactionCategory.transportation,
    amount: 25000.0,
    description: 'Transport budget',
    period: BudgetPeriod.weekly,
    startDate: DateTime(2025, 5, 26),
    endDate: DateTime(2025, 6, 1),
    isRecurring: true,
    status: BudgetStatus.active,
    spentAmount: 28000.0, // Exceeded
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Budget(
    id: '3',
    category: TransactionCategory.entertainment,
    amount: 15000.0,
    description: 'Weekend entertainment fund',
    period: BudgetPeriod.monthly,
    startDate: DateTime(2025, 5, 1),
    endDate: DateTime(2025, 5, 31),
    isRecurring: false,
    status: BudgetStatus.active,
    spentAmount: 8500.0,
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
  ),
  Budget(
    id: '4',
    category: TransactionCategory.shopping,
    amount: 30000.0,
    description: 'Clothing and accessories',
    period: BudgetPeriod.quarterly,
    startDate: DateTime(2025, 4, 1),
    endDate: DateTime(2025, 6, 30),
    isRecurring: true,
    status: BudgetStatus.active,
    spentAmount: 12000.0,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
  ),
];