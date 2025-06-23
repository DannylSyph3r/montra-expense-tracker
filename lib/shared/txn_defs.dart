import 'package:phosphor_flutter/phosphor_flutter.dart';

// Only keep budgetTypes since it's used in budget functionality
final List<Map<String, dynamic>> budgetTypes = [
  {
    'icon': PhosphorIconsFill.calendarX,
    'label': 'Weekly',
    'type': 'weekly',
    'getDuration': (DateTime startDate) {
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
      final currentQuarter = (startDate.month - 1) ~/ 3;
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
      final endDate = DateTime(startDate.year, 12, 31);
      return {
        'startDate': startDate,
        'endDate': endDate,
        'description': '${endDate.difference(startDate).inDays + 1} days',
      };
    },
  },
];