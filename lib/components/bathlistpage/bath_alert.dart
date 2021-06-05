import 'package:flutter/material.dart';

class DeleteAlert extends StatelessWidget {
  DeleteAlert({required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('WARNING'),
      content: Text('Do you want to delete?'),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('OK'),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
