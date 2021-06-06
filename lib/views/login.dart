import 'package:beachu/components/snackbar.dart';
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
                  decoration: kDecorationMail,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _pswController,
                  decoration: kDecorationPassword,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 20.0),
                SimpleButton(
                  title: 'Entra',
                  onPressed: () async {
                    bool result = await signInWithEmail(
                      _mailController.text,
                      _pswController.text,
                    );
                    if (result) {
                      data.userId = _auth.currentUser!.uid;
                      data.loadManagerBaths();
                      Navigator.pushReplacementNamed(context, BathListPage.id);
                    } else
                      ScaffoldMessenger.of(context).showSnackBar(
                          snackBarBuilder(title: 'Qualcosa è andato storto'));
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
