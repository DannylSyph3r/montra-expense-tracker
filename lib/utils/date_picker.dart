import 'package:expense_tracker_app/theme/palette.dart';
import 'package:flutter/material.dart';

Future<void> pickDateRange(BuildContext context) async {
  final newDateRange = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2023),
    lastDate: DateTime(2024),
    helpText: 'Select Range',
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(primary: Palette.montraPurple),
        ),
        child: child!,
      );
    },
  );
  if (newDateRange != null) {}
}
