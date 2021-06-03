import 'package:beachu/constants.dart';
import 'package:beachu/functions.dart';
import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  const NameField({
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
      decoration: InputDecoration(
        labelText: 'Type name of the bath',
        labelStyle: kBathOpacTextStyle,
      ),
      validator: validatorCallback,
    );
  }
}
