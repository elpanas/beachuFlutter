import 'package:beachu/views/new_bath.dart';
import 'package:flutter/material.dart';

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
