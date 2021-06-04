import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleButton extends StatelessWidget {
  GoogleButton({required this.onPressed});

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Icon(FontAwesomeIcons.google),
      style: kButtonStyle.copyWith(
        foregroundColor: MaterialStateProperty.all(Colors.red),
      ),
      onPressed: onPressed,
    );
  }
}
