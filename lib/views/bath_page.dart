import 'package:beachu/components/action_button.dart';
import 'package:beachu/components/bathpage/bath_container.dart';
import 'package:beachu/components/bathpage/bath_subtitle.dart';
import 'package:beachu/components/bathpage/bath_title.dart';
import 'package:beachu/components/bathpage/umbrella_button.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/edit_bath.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class BathPage extends StatelessWidget {
  static final String id = 'bath_screen';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BathIndex;
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        Bath _bath = data.bath[args.index];
        return ModalProgressHUD(
          inAsyncCall: data.loading,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                if (data.userId == _bath.uid)
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
                if (data.userId == _bath.uid)
                  ActionIconButton(
                    icon: Icons.delete,
                    onPressed: () async {
                      bool result = await data.deleteBath(args.index);
                      if (result) Navigator.pop(context);
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
                    Expanded(
                      child: BathContainer(
                        title: 'AVAILABLE',
                        icon: Icons.beach_access,
                        colour: Colors.green,
                        info: data.bath[args.index].avUmbrellas.toString(),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => _bath.openMap(args.index),
                        child: BathContainer(
                          title: 'POSITION',
                          icon: Icons.location_on,
                          colour: Colors.blue,
                          info: 'Vai',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                (_auth.currentUser?.uid != _bath.uid)
                    ? SimpleButton(
                        title: 'Chiama',
                        onPressed: () => _bath.callNumber(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UmbrellasIconButton(
                            icon: Icons.remove,
                            onPressed: () async {
                              bool _result =
                                  await data.decreaseUmbrellas(args.index);
                              if (!_result)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Min reached',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    backgroundColor: Colors.orange,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                  ),
                                );
                            },
                          ),
                          SizedBox(width: 20.0),
                          UmbrellasIconButton(
                            icon: Icons.add,
                            onPressed: () async {
                              bool _result =
                                  await data.increaseUmbrellas(args.index);
                              if (!_result)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Max reached',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    backgroundColor: Colors.orange,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                  ),
                                );
                            },
                          ),
                        ],
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
