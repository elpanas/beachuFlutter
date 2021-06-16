import 'package:beachu/components/snackbar.dart';
import 'package:beachu/components/new_edit_bathpage/bath_field.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/constants.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class NewBath extends StatefulWidget {
  static final String id = 'new_bath_screen';

  @override
  _NewBathState createState() => _NewBathState();
}

class _NewBathState extends State<NewBath> {
  TextEditingController _nameController = TextEditingController(),
      _totUmbrellasController = TextEditingController(),
      _phoneController = TextEditingController(),
      _cityController = TextEditingController(),
      _provinceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Nuovo Stabilimento'),
          ),
          body: ModalProgressHUD(
            inAsyncCall: data.loading,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: kNewBathPadding,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BathField(
                          controller: _nameController,
                          labelText: 'Nome',
                        ),
                        const SizedBox(width: 10.0),
                        BathField(
                          controller: _totUmbrellasController,
                          labelText: 'Tot. Ombrelloni',
                          inputType: TextInputType.number,
                        ),
                        BathField(
                          controller: _phoneController,
                          labelText: 'Telefono',
                          inputType: TextInputType.phone,
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            BathField(
                              controller: _cityController,
                              labelText: 'Località',
                            ),
                            const SizedBox(width: 20.0),
                            BathField(
                              controller: _provinceController,
                              labelText: 'Provincia',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        SimpleButton(
                          title: 'Aggiungi',
                          onPressed: () async {
                            bool _validate = _formKey.currentState!.validate(),
                                _result = false;
                            if (_validate) {
                              Bath bath = await data.makeRequest(
                                _auth.currentUser!.uid,
                                _nameController.text,
                                int.parse(_totUmbrellasController.text),
                                int.parse(_totUmbrellasController.text),
                                _phoneController.text,
                                _cityController.text,
                                _provinceController.text,
                              );
                              _result = await data.postBath(bath);
                              if (_result) Navigator.pop(context);
                            }

                            if (!_validate || !_result)
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackBarBuilder(
                                    title: 'Qualcosa è andato storto'),
                              );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
