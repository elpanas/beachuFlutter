import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';

class BathSubTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: kBathMargin,
      child: Text(
        'Dati Stabilimento',
        style: kBathTextStyle.copyWith(fontSize: 20),
      ),
    );
  }
}
