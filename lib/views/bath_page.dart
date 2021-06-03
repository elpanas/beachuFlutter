import 'package:beachu/components/action_button.dart';
import 'package:beachu/components/bathpage/bath_container.dart';
import 'package:beachu/components/bathpage/bath_subtitle.dart';
import 'package:beachu/components/bathpage/bath_title.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/edit_bath.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BathPage extends StatelessWidget {
  static final String id = 'bath_screen';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BathIndex;
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        Bath _bath = data.getBathItem(args.index);
        return Scaffold(
          appBar: AppBar(
            actions: [
              ActionIconButton(
                icon: Icons.favorite_outline,
                onPressed: () {},
              ),
              ActionIconButton(
                icon: Icons.edit,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    EditBath.id,
                    arguments: BathIndex(args.index),
                  );
                },
              ),
              ActionIconButton(
                icon: Icons.delete,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    EditBath.id,
                    arguments: BathIndex(args.index),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              BathTitle(title: _bath.name),
              SizedBox(height: 5.0),
              BathSubTitle(),
              Row(
                children: [
                  BathContainer(
                    title: 'DISPONIBILI',
                    icon: Icons.beach_access,
                    colour: Colors.green,
                    info: _bath.avUmbrellas,
                  ),
                  TextButton(
                    onPressed: () => _bath.openMap(args.index),
                    child: BathContainer(
                      title: 'POSIZIONE',
                      icon: Icons.location_on,
                      colour: Colors.blue,
                      info: 'Vai',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              SimpleButton(
                title: 'Chiama',
                onPressed: () => _bath.callNumber(),
              ),
            ],
          ),
        );
      },
    );
  }
}
