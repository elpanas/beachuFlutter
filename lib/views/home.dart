import 'package:beachu/components/snackbar.dart';
import 'package:beachu/components/homepage/google_button.dart';
import 'package:beachu/components/homepage/login_button.dart';
import 'package:beachu/components/logout_button.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/functions.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/bath_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/logo.png', height: 200.0),
                  const SizedBox(height: 50.0),
                  SimpleButton(
                      title: 'search_button'.tr(),
                      onPressed: () async {
                        data.loadBaths();
                        Navigator.pushNamed(context, BathListPage.id);
                      }),
                  const SizedBox(height: 10.0),
                  (data.userId == '')
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LoginButton(),
                            const SizedBox(width: 5.0),
                            GoogleButton(
                              onPressed: () async {
                                String userId = await signInWithGoogle();
                                if (userId != '') {
                                  data.userId = userId;
                                  data.loadManagerBaths();
                                  Navigator.pushNamed(context, BathListPage.id);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBarBuilder(title: 'snack_msg'.tr()),
                                  );
                                }
                              },
                            ),
                          ],
                        )
                      : LogoutButton(
                          onPressed: () async {
                            await _auth.signOut();
                            data.userId = '';
                          },
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
