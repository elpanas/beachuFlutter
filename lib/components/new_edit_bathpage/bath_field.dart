import 'package:beachu/constants.dart';
import 'package:beachu/functions.dart';
import 'package:flutter/material.dart';

class BathField extends StatelessWidget {
  const BathField({
    required this.controller,
    required this.labelText,
    this.initialValue,
  });

  final TextEditingController controller;
  final String labelText;
  final String? initialValue;

  void checkAndSetInitialValue() {
    if (initialValue != null) controller.text = initialValue!;
  }

  @override
  Widget build(BuildContext context) {
    checkAndSetInitialValue();
    return Flexible(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: kBathOpacTextStyle,
        ),
        validator: validatorCallback,
      ),
    );
  }
}
