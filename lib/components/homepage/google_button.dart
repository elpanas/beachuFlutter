import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({required this.onPressed});

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        child: const Icon(FontAwesomeIcons.google),
        style: kGoogleButtonStyle,
        onPressed: onPressed,
      ),
    );
  }
}
