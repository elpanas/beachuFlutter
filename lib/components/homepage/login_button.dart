import 'package:beachu/constants.dart';
import 'package:beachu/views/login.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => Navigator.pushNamed(context, LoginPage.id),
        child: Icon(Icons.login_outlined),
        style: kButtonStyle.copyWith(
          foregroundColor: MaterialStateProperty.all(Colors.white60),
        ),
      ),
    );
  }
}
