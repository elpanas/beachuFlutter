import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';

class BathContainer extends StatelessWidget {
  const BathContainer({
    required this.title,
    required this.colour,
    required this.info,
    required this.icon,
  });

  final Color colour;
  final String title;
  final String info;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kBathMargin,
      padding: kBathPadding,
      decoration: kBathTitleDecoration,
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            icon,
            color: colour,
            size: 30.0,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: kBathOpacTextStyle,
          ),
          const SizedBox(height: 20),
          Text(
            info,
            style: kBathTextStyle.copyWith(fontSize: 21),
          ),
        ],
      ),
    );
  }
}
