import 'package:flutter/material.dart';

class RowRailer extends StatelessWidget {
  const RowRailer(
      {super.key,
      this.leading,
      this.middle,
      this.trailing,
      required this.rowPadding});

  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final EdgeInsetsGeometry rowPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: rowPadding,
      child: Row(
        children: [
          Expanded(
            child: Align(
                alignment: Alignment.centerLeft,
                heightFactor: 1,
                child: leading),
          ),
          if (middle != null) middle!,
          Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                heightFactor: 1,
                child: trailing),
          ),
        ],
      ),
    );
  }
}