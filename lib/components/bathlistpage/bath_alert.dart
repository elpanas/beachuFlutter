import 'package:flutter/material.dart';

class DeleteAlert extends StatelessWidget {
  DeleteAlert({required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('WARNING'),
      content: const Text('Do you want to delete?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
