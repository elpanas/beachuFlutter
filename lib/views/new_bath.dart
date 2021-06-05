import 'package:beachu/components/new_edit_bathpage/bath_field.dart';
import 'package:beachu/components/simple_button.dart';
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
      _avUmbrellasController = TextEditingController(),
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
            title: Text('Add New Bath'),
          ),
          body: ModalProgressHUD(
            inAsyncCall: data.loading,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BathField(
                          controller: _nameController,
                          labelText: 'Type the name of the bath',
                        ),
                        Row(
                          children: [
                            BathField(
                              controller: _avUmbrellasController,
                              labelText: 'Av. Umbrellas',
                            ),
                            SizedBox(width: 20.0),
                            BathField(
                              controller: _totUmbrellasController,
                              labelText: 'Tot. Umbrellas',
                            ),
                          ],
                        ),
                        BathField(
                          controller: _phoneController,
                          labelText: 'Phone',
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            BathField(
                              controller: _cityController,
                              labelText: 'City',
                            ),
                            SizedBox(width: 20.0),
                            BathField(
                              controller: _provinceController,
                              labelText: 'Province',
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        SimpleButton(
                          title: 'Add',
                          onPressed: () async {
                            bool _validate = _formKey.currentState!.validate(),
                                _result = false;
                            if (_validate) {
                              Bath bath = await data.makeRequest(
                                _auth.currentUser!.uid,
                                _nameController.text,
                                int.parse(_avUmbrellasController.text),
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
                                SnackBar(
                                  content: Text(
                                    'Something went wrong',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  backgroundColor: Colors.orange,
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                ),
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
