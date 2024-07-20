import 'package:flutter/material.dart';

killKeyboard(BuildContext context) {
  if (FocusScope.of(context).isFirstFocus) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

Future<void> dropKeyboard(context) async {
  FocusScope.of(context).unfocus();
}

