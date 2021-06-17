import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';

class BathCard extends StatelessWidget {
  const BathCard({
    required this.title,
    this.availableUmbrella,
    this.city,
    required this.onTap,
    required this.onLongPress,
  });
  final String title;
  final int? availableUmbrella;
  final String? city;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: kBathCardMargin,
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18.0),
        ),
        subtitle: Row(
          children: [
            kBathCardLeadingIcon,
            const SizedBox(width: 3),
            Text(availableUmbrella.toString()),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
