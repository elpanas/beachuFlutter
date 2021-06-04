import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacebookButton extends StatelessWidget {
  FacebookButton({required this.onPressed});

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Icon(FontAwesomeIcons.facebook),
      style: kButtonStyle.copyWith(
        foregroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      onPressed: () {},
    );
  }
}
