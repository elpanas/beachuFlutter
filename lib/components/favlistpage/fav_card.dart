import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';

class FavCard extends StatelessWidget {
  const FavCard({
    required this.title,
    required this.city,
    required this.onTap,
    required this.onLongPress,
  });
  final String title;

  final String city;
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
            const Icon(Icons.location_city),
            const SizedBox(width: 3),
            Text(city),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}