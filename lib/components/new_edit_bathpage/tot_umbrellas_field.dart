import 'package:beachu/constants.dart';
import 'package:beachu/functions.dart';
import 'package:flutter/material.dart';

class TotalUmbrellasField extends StatelessWidget {
  const TotalUmbrellasField({
    required this.controller,
    this.initialValue,
  });

  final TextEditingController controller;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Total umbrellas',
          labelStyle: kBathOpacTextStyle,
        ),
        validator: validatorCallback,
      ),
    );
  }
}
