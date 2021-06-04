import 'package:flutter/material.dart';

class BathCard extends StatelessWidget {
  const BathCard({
    required this.title,
    required this.availableUmbrella,
    required this.onTap,
  });
  final String title;
  final int availableUmbrella;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 4.0,
      ),
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.beach_access,
              color: Colors.green,
            ),
            SizedBox(width: 3),
            Text(availableUmbrella.toString()),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
