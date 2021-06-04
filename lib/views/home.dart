import 'package:beachu/components/homepage/facebook_button.dart';
import 'package:beachu/components/homepage/google_button.dart';
import 'package:beachu/components/homepage/login_button.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/functions.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/bath_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String id = 'home_screen';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 200.0,
                ),
                Container(
                  child: Column(
                    children: [
                      SimpleButton(
                          title: 'Cerca',
                          onPressed: () async {
                            data.loadBaths();
                            Navigator.pushNamed(context, BathListPage.id);
                          }),
                      SizedBox(height: 10.0),
                      (_auth.currentUser != null)
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: LoginButton()),
                                  SizedBox(width: 5.0),
                                  Expanded(
                                    child: GoogleButton(
                                      onPressed: () async {
                                        bool result = await signInWithGoogle();
                                        if (result) {
                                          data.loadManagerBaths(
                                              _auth.currentUser!.uid);
                                          Navigator.pushNamed(
                                              context, BathListPage.id);
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 5.0),
                                  Expanded(
                                    child: FacebookButton(
                                      onPressed: () async {
                                        bool result =
                                            await signInWithFacebook();
                                        if (result) {
                                          data.loadManagerBaths(
                                              _auth.currentUser!.uid);
                                          Navigator.pushNamed(
                                              context, BathListPage.id);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SimpleButton(
                              title: 'LogOut',
                              onPressed: () async {
                                _auth.signOut();
                                setState(() {});
                              }),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
