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
                Image.asset('assets/images/logo.png', height: 200.0),
                Container(
                  child: Column(
                    children: [
                      SimpleButton(
                          title: 'Search...',
                          onPressed: () async {
                            data.loadBaths();
                            Navigator.pushNamed(context, BathListPage.id);
                          }),
                      SizedBox(height: 10.0),
                      (data.userId == '')
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
                                        String userId =
                                            await signInWithGoogle();
                                        if (userId != '') {
                                          data.userId = userId;
                                          data.loadManagerBaths();
                                          Navigator.pushNamed(
                                              context, BathListPage.id);
                                        } else {
                                          SnackBar(
                                            content: Text(
                                              'Something went wrong',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            backgroundColor: Colors.orange,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  /*SizedBox(width: 5.0),
                                  Expanded(
                                    child: FacebookButton(
                                      onPressed: () async {
                                        String userId =
                                            await signInWithFacebook();
                                        if (userId != '') {
                                          data.loadManagerBaths();
                                          Navigator.pushNamed(
                                              context, BathListPage.id);
                                        }
                                      },
                                    ),
                                  ),*/
                                ],
                              ),
                            )
                          : SimpleButton(
                              title: 'Logout',
                              onPressed: () async {
                                await _auth.signOut();
                                data.userId = '';
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
