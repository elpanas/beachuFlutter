import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

SnackBar snackBarBuilder({required String title}) {
  return SnackBar(
    content: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: Colors.orange,
    padding: EdgeInsets.symmetric(
      vertical: 3.0,
      horizontal: 10.0,
    ),
    duration: Duration(seconds: 2),
  );
}
