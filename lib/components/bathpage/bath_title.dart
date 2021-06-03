import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';

class BathTitle extends StatelessWidget {
  const BathTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kBathMargin,
      padding: kBathTitlePadding,
      decoration: kBathTitleDecoration,
      alignment: Alignment.center,
      child: Text(
        title,
        style: kBathTextStyle.copyWith(fontSize: 30),
      ),
    );
  }
}
