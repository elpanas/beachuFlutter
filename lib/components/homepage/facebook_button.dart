import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacebookButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Icon(FontAwesomeIcons.facebook),
      style: kButtonStyle.copyWith(
        foregroundColor: MaterialStateProperty.all(Colors.blue),
      ),
    );
  }
}
