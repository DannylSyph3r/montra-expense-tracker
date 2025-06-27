import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum TransactionType { expense, income }

enum TransactionCategory {
  // EXPENSE CATEGORIES
  generalExpense('Cash Outflow', PhosphorIconsFill.signOut, Colors.redAccent),
  groceries('Groceries', PhosphorIconsFill.shoppingCart, Colors.lightGreen),
  rentMortgage('Rent/Mortgage', PhosphorIconsFill.houseLine, Colors.brown),
  utilities('Utilities', PhosphorIconsFill.plug, Colors.amber),
  transportation('Transportation', PhosphorIconsFill.carSimple, Colors.cyan),
  diningOut('Dining Out', PhosphorIconsFill.pizza, Colors.deepOrange),
  healthFitness('Health & Fitness', PhosphorIconsFill.heartbeat, Colors.lightBlue),
  entertainment('Entertainment & Subscriptions', PhosphorIconsFill.filmSlate, Colors.purpleAccent),
  shopping('Shopping', PhosphorIconsFill.shoppingBag, Colors.pinkAccent),
  insurance('Insurance', PhosphorIconsFill.shield, Colors.lightBlueAccent),
  
  // NEW EXPENSE CATEGORIES
  educationLearning('Education & Learning', PhosphorIconsFill.graduationCap, Colors.blue),
  travelVacation('Travel & Vacation', PhosphorIconsFill.airplane, Colors.teal),
  personalCare('Personal Care', PhosphorIconsFill.scissors, Colors.pink),
  savingsInvestments('Savings & Investments', PhosphorIconsFill.piggyBank, Colors.green),
  taxes('Taxes', PhosphorIconsFill.receipt, Colors.grey),
  giftsDonations('Gifts & Donations', PhosphorIconsFill.heart, Colors.red),
  professionalWorkExpenses('Professional/Work Expenses', PhosphorIconsFill.suitcase, Colors.indigo),

  // INCOME CATEGORIES
  salary('Salary/Wages', PhosphorIconsFill.briefcase, Colors.deepPurpleAccent),
  generalIncome('Cash Inflow', PhosphorIconsFill.coins, Colors.green),
  
  // NEW INCOME CATEGORIES
  dividendsInterest('Dividends & Interest', PhosphorIconsFill.percent, Colors.teal),
  capitalGains('Capital Gains', PhosphorIconsFill.trendUp, Colors.deepPurple),
  investmentReturns('Investment Returns', PhosphorIconsFill.chartLineUp, Colors.indigoAccent),
  rentalIncome('Rental Income', PhosphorIconsFill.buildings, Colors.blueGrey),
  freelanceConsulting('Freelance/Consulting', PhosphorIconsFill.laptop, Colors.purple),
  businessRevenue('Business Revenue', PhosphorIconsFill.storefront, Colors.orange),
  commission('Commission', PhosphorIconsFill.handshake, Colors.lime),
  bonuses('Bonuses', PhosphorIconsFill.gift, Colors.pinkAccent);

  const TransactionCategory(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  // Helper function to filter categories based on the transaction type
  static List<TransactionCategory> getExpenseCategories() {
    return [
      generalExpense,
      groceries,
      rentMortgage,
      utilities,
      transportation,
      diningOut,
      healthFitness,
      entertainment,
      shopping,
      insurance,
      educationLearning,
      travelVacation,
      personalCare,
      savingsInvestments,
      taxes,
      giftsDonations,
      professionalWorkExpenses,
    ];
  }

  static List<TransactionCategory> getIncomeCategories() {
    return [
      salary,
      generalIncome,
      dividendsInterest,
      capitalGains,
      investmentReturns,
      rentalIncome,
      freelanceConsulting,
      businessRevenue,
      commission,
      bonuses,
    ];
  }
}

class Transaction {
  final TransactionType transactionType;
  final TransactionCategory transactionCategory;
  final String transactionDescription;
  final double transactionAmount;
  final DateTime transactionDate;

  Transaction({
    required this.transactionType,
    required this.transactionCategory,
    required this.transactionDescription,
    required this.transactionAmount,
    required this.transactionDate,
  });

  // Convert to Map for storage/serialization
  Map<String, dynamic> toMap() {
    return {
      'transactionType': transactionType.toString(),
      'transactionCategory': transactionCategory.toString(),
      'transactionDescription': transactionDescription,
      'transactionAmount': transactionAmount,
      'transactionDate': transactionDate.toIso8601String(),
    };
  }

  // Create from Map for retrieval/deserialization
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionType: TransactionType.values.firstWhere(
        (type) => type.toString() == map['transactionType'],
      ),
      transactionCategory: TransactionCategory.values.firstWhere(
        (category) => category.toString() == map['transactionCategory'],
      ),
      transactionDescription: map['transactionDescription'],
      transactionAmount: map['transactionAmount']?.toDouble() ?? 0.0,
      transactionDate: DateTime.parse(map['transactionDate']),
    );
  }

  // Create a copy with updated values
  Transaction copyWith({
    TransactionType? transactionType,
    TransactionCategory? transactionCategory,
    String? transactionDescription,
    double? transactionAmount,
    DateTime? transactionDate,
  }) {
    return Transaction(
      transactionType: transactionType ?? this.transactionType,
      transactionCategory: transactionCategory ?? this.transactionCategory,
      transactionDescription: transactionDescription ?? this.transactionDescription,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      transactionDate: transactionDate ?? this.transactionDate,
    );
  }

  @override
  String toString() {
    return 'Transaction(type: $transactionType, category: $transactionCategory, description: $transactionDescription, amount: $transactionAmount, date: $transactionDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction &&
        other.transactionType == transactionType &&
        other.transactionCategory == transactionCategory &&
        other.transactionDescription == transactionDescription &&
        other.transactionAmount == transactionAmount &&
        other.transactionDate == transactionDate;
  }

  @override
  int get hashCode {
    return transactionType.hashCode ^
        transactionCategory.hashCode ^
        transactionDescription.hashCode ^
        transactionAmount.hashCode ^
        transactionDate.hashCode;
  }
}

class TransactionManager {
  List<Transaction> _transactions = [];

  // Getter for transactions (immutable copy)
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  // Constructor
  TransactionManager({List<Transaction>? initialTransactions}) {
    _transactions = initialTransactions ?? [];
  }

  // Add a single transaction
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
  }

  // Add multiple transactions
  void addTransactions(List<Transaction> transactions) {
    _transactions.addAll(transactions);
  }

  // Remove a transaction
  bool removeTransaction(Transaction transaction) {
    return _transactions.remove(transaction);
  }

  // Remove transaction by index
  void removeTransactionAt(int index) {
    if (index >= 0 && index < _transactions.length) {
      _transactions.removeAt(index);
    }
  }

  // Update a transaction
  void updateTransaction(int index, Transaction newTransaction) {
    if (index >= 0 && index < _transactions.length) {
      _transactions[index] = newTransaction;
    }
  }

  // Clear all transactions
  void clearTransactions() {
    _transactions.clear();
  }

  // Get transactions by type
  List<Transaction> getTransactionsByType(TransactionType type) {
    return _transactions.where((transaction) => transaction.transactionType == type).toList();
  }

  // Get transactions by category
  List<Transaction> getTransactionsByCategory(TransactionCategory category) {
    return _transactions.where((transaction) => transaction.transactionCategory == category).toList();
  }

  // Get transactions by date range
  List<Transaction> getTransactionsByDateRange(DateTime startDate, DateTime endDate) {
    return _transactions.where((transaction) {
      return transaction.transactionDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
             transaction.transactionDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Get transactions for current month
  List<Transaction> getCurrentMonthTransactions() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    return getTransactionsByDateRange(startOfMonth, endOfMonth);
  }

  // Get transactions for current week
  List<Transaction> getCurrentWeekTransactions() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return getTransactionsByDateRange(startOfWeek, endOfWeek);
  }

  // Calculate total income
  double getTotalIncome() {
    return _transactions
        .where((transaction) => transaction.transactionType == TransactionType.income)
        .fold(0.0, (sum, transaction) => sum + transaction.transactionAmount);
  }

  // Calculate total expenses
  double getTotalExpenses() {
    return _transactions
        .where((transaction) => transaction.transactionType == TransactionType.expense)
        .fold(0.0, (sum, transaction) => sum + transaction.transactionAmount);
  }

  // Calculate net amount (income - expenses)
  double getNetAmount() {
    return getTotalIncome() - getTotalExpenses();
  }

  // Get income by category
  Map<TransactionCategory, double> getIncomeByCategory() {
    Map<TransactionCategory, double> incomeByCategory = {};
    
    for (var transaction in _transactions) {
      if (transaction.transactionType == TransactionType.income) {
        incomeByCategory[transaction.transactionCategory] = 
            (incomeByCategory[transaction.transactionCategory] ?? 0.0) + transaction.transactionAmount;
      }
    }
    
    return incomeByCategory;
  }

  // Get expenses by category
  Map<TransactionCategory, double> getExpensesByCategory() {
    Map<TransactionCategory, double> expensesByCategory = {};
    
    for (var transaction in _transactions) {
      if (transaction.transactionType == TransactionType.expense) {
        expensesByCategory[transaction.transactionCategory] = 
            (expensesByCategory[transaction.transactionCategory] ?? 0.0) + transaction.transactionAmount;
      }
    }
    
    return expensesByCategory;
  }

  // Get transactions sorted by date (newest first)
  List<Transaction> getTransactionsSortedByDate({bool ascending = false}) {
    List<Transaction> sortedTransactions = List.from(_transactions);
    sortedTransactions.sort((a, b) {
      return ascending 
          ? a.transactionDate.compareTo(b.transactionDate)
          : b.transactionDate.compareTo(a.transactionDate);
    });
    return sortedTransactions;
  }

  // Get transactions sorted by amount
  List<Transaction> getTransactionsSortedByAmount({bool ascending = false}) {
    List<Transaction> sortedTransactions = List.from(_transactions);
    sortedTransactions.sort((a, b) {
      return ascending 
          ? a.transactionAmount.compareTo(b.transactionAmount)
          : b.transactionAmount.compareTo(a.transactionAmount);
    });
    return sortedTransactions;
  }

  // Search transactions by description
  List<Transaction> searchTransactions(String query) {
    return _transactions
        .where((transaction) => 
            transaction.transactionDescription.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get transaction count
  int getTransactionCount() {
    return _transactions.length;
  }

  // Get income transaction count
  int getIncomeTransactionCount() {
    return _transactions
        .where((transaction) => transaction.transactionType == TransactionType.income)
        .length;
  }

  // Get expense transaction count
  int getExpenseTransactionCount() {
    return _transactions
        .where((transaction) => transaction.transactionType == TransactionType.expense)
        .length;
  }

  // Get average transaction amount
  double getAverageTransactionAmount() {
    if (_transactions.isEmpty) return 0.0;
    return _transactions
        .map((transaction) => transaction.transactionAmount)
        .reduce((a, b) => a + b) / _transactions.length;
  }

  // Get largest transaction
  Transaction? getLargestTransaction() {
    if (_transactions.isEmpty) return null;
    return _transactions.reduce((a, b) => 
        a.transactionAmount > b.transactionAmount ? a : b);
  }

  // Get smallest transaction
  Transaction? getSmallestTransaction() {
    if (_transactions.isEmpty) return null;
    return _transactions.reduce((a, b) => 
        a.transactionAmount < b.transactionAmount ? a : b);
  }

  // Convert to Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'transactions': _transactions.map((transaction) => transaction.toMap()).toList(),
    };
  }

  // Create from Map for deserialization
  factory TransactionManager.fromMap(Map<String, dynamic> map) {
    List<Transaction> transactions = [];
    if (map['transactions'] != null) {
      transactions = List<Transaction>.from(
        map['transactions'].map((transactionMap) => Transaction.fromMap(transactionMap))
      );
    }
    return TransactionManager(initialTransactions: transactions);
  }

  @override
  String toString() {
    return 'TransactionManager(transactions: ${_transactions.length}, '
           'totalIncome: ${getTotalIncome()}, '
           'totalExpenses: ${getTotalExpenses()}, '
           'netAmount: ${getNetAmount()})';
  }
}

// Sample transaction data with both old and new categories
List<Transaction> transactions = [
  // INCOME TRANSACTIONS - Using new categories
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.salary,
    transactionDescription: 'Monthly salary',
    transactionAmount: 3500.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.dividendsInterest,
    transactionDescription: 'Stock dividends from Apple but im actually a tweaker tis is a test',
    transactionAmount: 120.50,
    transactionDate: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.freelanceConsulting,
    transactionDescription: 'Web development project',
    transactionAmount: 850.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.rentalIncome,
    transactionDescription: 'Apartment rental payment',
    transactionAmount: 1200.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.capitalGains,
    transactionDescription: 'Sold Tesla stock',
    transactionAmount: 450.75,
    transactionDate: DateTime.now().subtract(const Duration(days: 7)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.bonuses,
    transactionDescription: 'Performance bonus Q4',
    transactionAmount: 2000.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.businessRevenue,
    transactionDescription: 'Online store sales',
    transactionAmount: 680.25,
    transactionDate: DateTime.now().subtract(const Duration(days: 12)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.commission,
    transactionDescription: 'Real estate commission',
    transactionAmount: 1500.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 15)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.investmentReturns,
    transactionDescription: 'Mutual fund returns',
    transactionAmount: 320.80,
    transactionDate: DateTime.now().subtract(const Duration(days: 18)),
  ),

  // EXPENSE TRANSACTIONS - Existing categories
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.generalExpense,
    transactionDescription: 'Cash Transfer to Olawale',
    transactionAmount: 200.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.groceries,
    transactionDescription: 'Weekly grocery shopping',
    transactionAmount: 125.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.rentMortgage,
    transactionDescription: 'Monthly rent payment',
    transactionAmount: 1200.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.utilities,
    transactionDescription: 'Electricity bill',
    transactionAmount: 85.50,
    transactionDate: DateTime.now().subtract(const Duration(days: 4)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.transportation,
    transactionDescription: 'Gas refill',
    transactionAmount: 45.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.diningOut,
    transactionDescription: 'Dinner with friends',
    transactionAmount: 75.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 6)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.healthFitness,
    transactionDescription: 'Gym membership',
    transactionAmount: 60.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 7)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.entertainment,
    transactionDescription: 'Netflix subscription',
    transactionAmount: 15.99,
    transactionDate: DateTime.now().subtract(const Duration(days: 8)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.shopping,
    transactionDescription: 'New clothes',
    transactionAmount: 180.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 9)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.insurance,
    transactionDescription: 'Car insurance premium',
    transactionAmount: 120.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 10)),
  ),

  // NEW EXPENSE CATEGORIES - Sample transactions
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.educationLearning,
    transactionDescription: 'Online course subscription',
    transactionAmount: 49.99,
    transactionDate: DateTime.now().subtract(const Duration(days: 11)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.travelVacation,
    transactionDescription: 'Flight tickets to Lagos',
    transactionAmount: 350.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 12)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.personalCare,
    transactionDescription: 'Haircut and styling',
    transactionAmount: 25.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 13)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.savingsInvestments,
    transactionDescription: 'Transfer to savings account',
    transactionAmount: 500.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 14)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.taxes,
    transactionDescription: 'Income tax payment',
    transactionAmount: 800.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 15)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.giftsDonations,
    transactionDescription: 'Birthday gift for sister',
    transactionAmount: 75.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 16)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.professionalWorkExpenses,
    transactionDescription: 'Business conference ticket',
    transactionAmount: 150.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 17)),
  ),

  // Additional sample transactions for variety
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.groceries,
    transactionDescription: 'Supermarket shopping',
    transactionAmount: 95.50,
    transactionDate: DateTime.now().subtract(const Duration(days: 20)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.generalIncome,
    transactionDescription: 'Gift from parents',
    transactionAmount: 300.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 21)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.travelVacation,
    transactionDescription: 'Hotel booking',
    transactionAmount: 180.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 22)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.educationLearning,
    transactionDescription: 'Programming books',
    transactionAmount: 65.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 23)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.freelanceConsulting,
    transactionDescription: 'Mobile app design',
    transactionAmount: 750.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 25)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.personalCare,
    transactionDescription: 'Spa treatment',
    transactionAmount: 120.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 26)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.professionalWorkExpenses,
    transactionDescription: 'Office supplies',
    transactionAmount: 45.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 28)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.dividendsInterest,
    transactionDescription: 'Bank interest payment',
    transactionAmount: 25.75,
    transactionDate: DateTime.now().subtract(const Duration(days: 30)),
  ),
];

// Global transaction manager instance
final TransactionManager transactionManager = TransactionManager(initialTransactions: transactions);