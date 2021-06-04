import 'package:beachu/components/simple_button.dart';
import 'package:beachu/constants.dart';
import 'package:beachu/functions.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/bath_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _mailController = TextEditingController(),
      _pswController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _mailController,
                  decoration: InputDecoration(
                    labelText: 'Type your email',
                    labelStyle: kBathOpacTextStyle,
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _pswController,
                  decoration: InputDecoration(
                    labelText: 'Type your password',
                    labelStyle: kBathOpacTextStyle,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20.0),
                SimpleButton(
                  title: 'Login',
                  onPressed: () async {
                    bool result = await signInWithEmail(
                      _mailController.text,
                      _pswController.text,
                    );
                    if (result) {
                      data.loadManagerBaths(_auth.currentUser!.uid);
                      Navigator.pushNamed(context, BathListPage.id);
                    } else
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Something was wrong')));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
