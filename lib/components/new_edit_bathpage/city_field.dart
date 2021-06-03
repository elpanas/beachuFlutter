import 'package:beachu/constants.dart';
import 'package:beachu/functions.dart';
import 'package:flutter/material.dart';

class CityField extends StatelessWidget {
  const CityField({
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
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.location_city),
          labelText: 'City/Town',
          labelStyle: kBathOpacTextStyle,
        ),
        validator: validatorCallback,
      ),
    );
  }
}
