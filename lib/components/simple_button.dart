import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    required this.title,
    required this.onPressed,
  });
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(fontSize: 23.0),
        ),
        style: kButtonStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.orange),
          foregroundColor: MaterialStateProperty.all(Colors.black87),
          fixedSize: MaterialStateProperty.all(const Size.fromWidth(300.0)),
          textStyle: MaterialStateProperty.all(
            const TextStyle(fontFamily: 'ComicNeue'),
          ),
        ),
      ),
    );
  }
}
