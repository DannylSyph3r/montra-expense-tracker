import 'package:expense_tracker_app/features/transactions/models/transactions_model.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

  final List<Map<String, dynamic>> transactionType = [
    {
      'icon': PhosphorIconsFill.coins,
      'label': 'Income',
      'type': TransactionType.income
    },
    {
      'icon': PhosphorIconsFill.signOut,
      'label': 'Expense',
      'type': TransactionType.expense
    },
  ];

final List<Map<String, dynamic>> transactionCategories = [
    {
      'name': 'Cash Outflow',
      'icon': PhosphorIconsFill.signOut,
      'color': Colors.redAccent,
    },
    {
      'name': 'Groceries',
      'icon': PhosphorIconsFill.shoppingCart,
      'color': Colors.lightGreen,
    },
    {
      'name': 'Rent/Mortgage',
      'icon': PhosphorIconsFill.houseLine,
      'color': Colors.brown,
    },
    {
      'name': 'Utilities',
      'icon': PhosphorIconsFill.plug,
      'color': Colors.amber,
    },
    {
      'name': 'Transportation',
      'icon': PhosphorIconsFill.carSimple,
      'color': Colors.cyan,
    },
    {
      'name': 'Dining Out',
      'icon': PhosphorIconsFill.pizza,
      'color': Colors.deepOrange,
    },
    {
      'name': 'Health & Fitness',
      'icon': PhosphorIconsFill.heartbeat,
      'color': Colors.lightBlue,
    },
    {
      'name': 'Entertainment & Subscriptions',
      'icon': PhosphorIconsFill.filmSlate,
      'color': Colors.purpleAccent,
    },
    {
      'name': 'Shopping',
      'icon': PhosphorIconsFill.shoppingBag,
      'color': Colors.pinkAccent,
    },
    {
      'name': 'Insurance',
      'icon': PhosphorIconsFill.shield,
      'color': Colors.lightBlueAccent,
    },
    {
      'name': 'Salary/Wages',
      'icon': PhosphorIconsFill.briefcase,
      'color': Colors.deepPurpleAccent,
    },
    {
      'name': 'Cash Inflow',
      'icon': PhosphorIconsFill.coins,
      'color': Colors.green,
    },
  ];

    final List<Map<String, dynamic>> budgetTypes = [
  {
    'icon': PhosphorIconsFill.calendarX,
    'label': 'Weekly',
    'type': 'weekly',
    'getDuration': (DateTime startDate) {
      // Calculate the end date (startDate + 6 days, to make it 7 days total)
      final endDate = startDate.add(const Duration(days: 6));
      return {
        'startDate': startDate,
        'endDate': endDate,
        'description': '7 days',
      };
    },
  },
  {
    'icon': PhosphorIconsFill.calendarBlank,
    'label': 'Monthly',
    'type': 'monthly',
    'getDuration': (DateTime startDate) {
      // Calculate the end date (last day of the current month)
      final endDate = DateTime(startDate.year, startDate.month + 1, 0);
      return {
        'startDate': startDate,
        'endDate': endDate,
        'description': '${endDate.difference(startDate).inDays + 1} days',
      };
    },
  },
  {
    'icon': PhosphorIconsFill.calendarPlus,
    'label': 'Quarterly',
    'type': 'quarterly',
    'getDuration': (DateTime startDate) {
      // Calculate which quarter we're in (0-3)
      final currentQuarter = (startDate.month - 1) ~/ 3;
      // Calculate the end date (last day of current quarter)
      final endDate = DateTime(startDate.year, (currentQuarter + 1) * 3 + 1, 0);
      return {
        'startDate': startDate,
        'endDate': endDate,
        'description': '${endDate.difference(startDate).inDays + 1} days',
      };
    },
  },
  {
    'icon': PhosphorIconsFill.clockClockwise,
    'label': 'Custom',
    'type': 'custom',
    'getDuration': (DateTime startDate, {int? customDays}) {
      // Default to 30 days if not specified
      final days = customDays ?? 30;
      final endDate = startDate.add(Duration(days: days - 1));
      return {
        'startDate': startDate,
        'endDate': endDate,
        'description': '$days days',
      };
    },
  },
  {
    'icon': PhosphorIconsFill.calendarCheck,
    'label': 'Yearly',
    'type': 'yearly',
    'getDuration': (DateTime startDate) {
      // Calculate the end date (December 31st of the current year)
      final endDate = DateTime(startDate.year, 12, 31);
      return {
        'startDate': startDate,
        'endDate': endDate,
        'description': '${endDate.difference(startDate).inDays + 1} days',
      };
    },
  },
  ];