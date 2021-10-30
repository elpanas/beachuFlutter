import 'package:beachu/constants.dart';
import 'package:beachu/views/registration.dart';
import 'package:flutter/material.dart';

class RegistrationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => Navigator.pushNamed(context, RegistrationPage.id),
        child: const Icon(Icons.how_to_reg_outlined),
        style: kLogInOutButtonStyle,
      ),
    );
  }
}
