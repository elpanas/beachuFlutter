import 'package:beachu/components/snackbar.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/constants.dart';
import 'package:beachu/main.dart';
import 'package:beachu/views/bath_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: use_key_in_widget_constructors
class RegistrationPage extends ConsumerStatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final _mailController = TextEditingController(),
      _pswController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(bathProvider);
    ref.read(fireProvider);
  }

  @override
  void dispose() {
    _mailController.dispose();
    _pswController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(bathProvider);
    final fire = ref.watch(fireProvider);
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
                  title: 'register_button'.tr(),
                  onPressed: () async {
                    bool result = await fire.registerWithEmail(
                      _mailController.text,
                      _pswController.text,
                    );
                    if (result) {
                      data.userId = fire.userId;
                      data.loadManagerBaths();
                      Navigator.pushReplacementNamed(context, BathListPage.id);
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
  }
}
