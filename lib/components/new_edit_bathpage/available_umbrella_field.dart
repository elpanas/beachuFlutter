import 'package:beachu/constants.dart';
import 'package:beachu/functions.dart';
import 'package:flutter/material.dart';

class AvailUmbrellasField extends StatelessWidget {
  const AvailUmbrellasField({
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
          icon: Icon(
            Icons.beach_access,
            color: Colors.green.shade400,
          ),
          labelText: 'Available umbrellas',
          labelStyle: kBathOpacTextStyle,
        ),
        validator: validatorCallback,
      ),
    );
  }
}
