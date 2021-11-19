import 'package:beachu/components/snackbar.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/constants.dart';
import 'package:beachu/functions.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/bath_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mailController = TextEditingController(),
      _pswController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _mailController.dispose();
    _pswController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _mailController,
                      decoration: InputDecoration(
                        labelText: 'decoration_mail'.tr(),
                        labelStyle: kBathOpacTextStyle,
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _pswController,
                      decoration: InputDecoration(
                        labelText: 'decoration_psw'.tr(),
                        labelStyle: kBathOpacTextStyle,
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 20.0),
                    SimpleButton(
                      title: 'login_button'.tr(),
                      onPressed: () async {
                        bool result = await signInWithEmail(
                          _mailController.text,
                          _pswController.text,
                        );
                        if (result) {
                          data.userId = _auth.currentUser!.uid;
                          data.loadManagerBaths();
                          Navigator.pushReplacementNamed(
                              context, BathListPage.id);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              snackBarBuilder(title: 'snack_msg'.tr()));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
