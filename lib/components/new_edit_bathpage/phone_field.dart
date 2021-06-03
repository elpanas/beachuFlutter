import 'package:beachu/constants.dart';
import 'package:beachu/functions.dart';
import 'package:flutter/material.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    required this.controller,
    this.initialValue,
  });

  final TextEditingController controller;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        icon: Icon(Icons.phone),
        labelText: 'Phone Number',
        labelStyle: kBathOpacTextStyle,
      ),
      validator: validatorCallback,
    );
  }
}
