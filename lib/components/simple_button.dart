import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    required this.title,
    required this.onPressed,
  });
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
        style: kSimpleButtonStyle,
      ),
    );
  }
}
