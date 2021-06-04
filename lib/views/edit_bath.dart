import 'package:beachu/components/new_edit_bathpage/available_umbrella_field.dart';
import 'package:beachu/components/new_edit_bathpage/city_field.dart';
import 'package:beachu/components/new_edit_bathpage/name_field.dart';
import 'package:beachu/components/new_edit_bathpage/phone_field.dart';
import 'package:beachu/components/new_edit_bathpage/province_field.dart';
import 'package:beachu/components/new_edit_bathpage/tot_umbrellas_field.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class EditBath extends StatefulWidget {
  static final String id = 'edit_bath_screen';
  @override
  _EditBathState createState() => _EditBathState();
}

class _EditBathState extends State<EditBath> {
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
    final args = ModalRoute.of(context)!.settings.arguments as BathIndex;
    return Consumer<BathProvider>(builder: (context, data, child) {
      Bath _bath = data.getBathItem(args.index);
      return Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: data.isLoading(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  NameField(
                    controller: _nameController,
                    initialValue: _bath.name,
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: Row(
                      children: [
                        AvailUmbrellasField(
                          controller: _avUmbrellasController,
                          initialValue: _bath.avUmbrellas.toString(),
                        ),
                        SizedBox(width: 20.0),
                        TotalUmbrellasField(
                          controller: _totUmbrellasController,
                          initialValue: _bath.totUmbrellas.toString(),
                        ),
                      ],
                    ),
                  ),
                  PhoneNumberField(
                    controller: _phoneController,
                    initialValue: _bath.phone,
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: Row(
                      children: [
                        CityField(
                          controller: _cityController,
                          initialValue: _bath.city,
                        ),
                        SizedBox(width: 20.0),
                        ProvinceField(
                          controller: _provinceController,
                          initialValue: _bath.province,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  SimpleButton(
                    title: 'Inserisci',
                    onPressed: () async {
                      bool _validate = _formKey.currentState!.validate(),
                          _result = false;
                      if (_formKey.currentState!.validate()) {
                        Bath bath = await data.makeRequest(
                            _auth.currentUser!.uid,
                            _nameController.text,
                            int.parse(_avUmbrellasController.text),
                            int.parse(_totUmbrellasController.text),
                            _phoneController.text,
                            _cityController.text,
                            _provinceController.text);
                        _result = await data.putBath(bath, args.index);
                        if (_result) Navigator.pop(context);
                      }

                      if (!_validate || !_result)
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Something went wrong')));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
