import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: kMessageStyle,
      ),
    );
  }
}
