import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum TransactionType { expense, income }

enum TransactionCategory {
  groceries('Groceries', PhosphorIconsFill.shoppingCart, Colors.green),
  rentMortgage('Rent/Mortgage', PhosphorIconsFill.houseLine, Colors.blueGrey),
  utilities('Utilities', PhosphorIconsFill.plug, Colors.orange),
  transportation('Transportation', PhosphorIconsFill.carSimple, Colors.purple),
  diningOut('Dining Out', PhosphorIconsFill.pizza, Colors.red),
  healthFitness('Health & Fitness', PhosphorIconsFill.heartbeat, Colors.teal),
  entertainment('Entertainment & Subscriptions', PhosphorIconsFill.filmSlate,
      Colors.indigo),
  shopping('Shopping', PhosphorIconsFill.shoppingBag, Colors.pink),
  insurance('Insurance', PhosphorIconsFill.shield, Colors.blue),
  salary('Salary/Wages', PhosphorIconsFill.briefcase, Colors.deepPurple),
  generalIncome('General Income', PhosphorIconsFill.coins, Colors.greenAccent);

  const TransactionCategory(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  // You can add a helper function here to filter categories based on the transaction type
  static List<TransactionCategory> getExpenseCategories() {
    return [
      groceries,
      rentMortgage,
      utilities,
      transportation,
      diningOut,
      healthFitness,
      entertainment,
      shopping,
      insurance,
    ];
  }

  static List<TransactionCategory> getIncomeCategories() {
    return [
      salary,
      generalIncome,
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
}

List<Transaction> transactions = [
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.groceries,
    transactionDescription: 'Bought groceries',
    transactionAmount: 85.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.salary,
    transactionDescription: 'Monthly salary',
    transactionAmount: 1900.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.rentMortgage,
    transactionDescription: 'Paid rent',
    transactionAmount: 600.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.utilities,
    transactionDescription: 'Electricity bill',
    transactionAmount: 120.50,
    transactionDate: DateTime.now().subtract(const Duration(days: 8)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.diningOut,
    transactionDescription: 'Dinner with friends',
    transactionAmount: 75.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.generalIncome,
    transactionDescription: 'Freelance project',
    transactionAmount: 450.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 12)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.healthFitness,
    transactionDescription: 'Gym membership',
    transactionAmount: 60.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 15)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.transportation,
    transactionDescription: 'Taxi fare',
    transactionAmount: 20.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 18)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.shopping,
    transactionDescription: 'Bought clothes',
    transactionAmount: 150.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 20)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.generalIncome,
    transactionDescription: 'Bonus payment',
    transactionAmount: 250.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 22)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.groceries,
    transactionDescription: 'Grocery shopping',
    transactionAmount: 75.25,
    transactionDate: DateTime.now().subtract(const Duration(days: 25)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.entertainment,
    transactionDescription: 'Netflix subscription',
    transactionAmount: 15.99,
    transactionDate: DateTime.now().subtract(const Duration(days: 27)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.insurance,
    transactionDescription: 'Car insurance',
    transactionAmount: 100.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 30)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.healthFitness,
    transactionDescription: 'Doctor visit',
    transactionAmount: 50.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 32)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.salary,
    transactionDescription: 'Part-time job',
    transactionAmount: 600.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 35)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.groceries,
    transactionDescription: 'Weekly groceries',
    transactionAmount: 85.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 37)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.diningOut,
    transactionDescription: 'Lunch with colleagues',
    transactionAmount: 40.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 40)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.rentMortgage,
    transactionDescription: 'Monthly rent',
    transactionAmount: 900.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 43)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.generalIncome,
    transactionDescription: 'Gift received',
    transactionAmount: 100.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 45)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.utilities,
    transactionDescription: 'Water bill',
    transactionAmount: 45.50,
    transactionDate: DateTime.now().subtract(const Duration(days: 47)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.transportation,
    transactionDescription: 'Gas refill',
    transactionAmount: 65.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 50)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.salary,
    transactionDescription: 'Monthly salary',
    transactionAmount: 2000.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 53)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.shopping,
    transactionDescription: 'Bought new shoes',
    transactionAmount: 120.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 55)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.entertainment,
    transactionDescription: 'Spotify subscription',
    transactionAmount: 9.99,
    transactionDate: DateTime.now().subtract(const Duration(days: 57)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.groceries,
    transactionDescription: 'Supermarket shopping',
    transactionAmount: 80.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 59)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.generalIncome,
    transactionDescription: 'Bonus for project',
    transactionAmount: 500.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 60)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.utilities,
    transactionDescription: 'Gas bill',
    transactionAmount: 55.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 62)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.transportation,
    transactionDescription: 'Uber rides',
    transactionAmount: 30.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 63)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.diningOut,
    transactionDescription: 'Dinner with family',
    transactionAmount: 85.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 65)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.salary,
    transactionDescription: 'Freelance work payment',
    transactionAmount: 700.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 68)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.healthFitness,
    transactionDescription: 'Yoga class',
    transactionAmount: 30.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 70)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.rentMortgage,
    transactionDescription: 'Apartment rent',
    transactionAmount: 850.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 72)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.utilities,
    transactionDescription: 'Internet bill',
    transactionAmount: 70.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 75)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.entertainment,
    transactionDescription: 'Hulu subscription',
    transactionAmount: 12.99,
    transactionDate: DateTime.now().subtract(const Duration(days: 78)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.groceries,
    transactionDescription: 'Grocery haul',
    transactionAmount: 90.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 80)),
  ),
  Transaction(
    transactionType: TransactionType.income,
    transactionCategory: TransactionCategory.generalIncome,
    transactionDescription: 'Gift from friend',
    transactionAmount: 200.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 82)),
  ),
  Transaction(
    transactionType: TransactionType.expense,
    transactionCategory: TransactionCategory.healthFitness,
    transactionDescription: 'New gym gear',
    transactionAmount: 75.00,
    transactionDate: DateTime.now().subtract(const Duration(days: 85)),
  ),
];
