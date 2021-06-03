import 'package:beachu/components/simple_button.dart';
import 'package:beachu/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _mailController = TextEditingController();
  TextEditingController _pswController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
                try {
                  UserCredential userCredential =
                      await _auth.signInWithEmailAndPassword(
                          email: _mailController.text,
                          password: _pswController.text);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
