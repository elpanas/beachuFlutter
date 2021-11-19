import 'package:beachu/views/new_bath.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class FloatingAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      backgroundColor: Colors.orange,
      onPressed: () => Navigator.pushNamed(context, NewBath.id),
    );
  }
}
