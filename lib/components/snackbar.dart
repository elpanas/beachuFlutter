import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';

SnackBar snackBarBuilder({required String title}) {
  return SnackBar(
    content: Text(
      title,
      style: kSnackBarTextStyle,
    ),
    backgroundColor: Colors.orange,
    padding: kSnackbarPadding,
    duration: const Duration(seconds: 2),
  );
}
