import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BathSubTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: kBathMargin,
      child: Text(
        'bath_subtitle',
        style: kBathTextStyle.copyWith(fontSize: 20),
      ).tr(),
    );
  }
}
