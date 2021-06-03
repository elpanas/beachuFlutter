import 'package:beachu/components/new_edit_bathpage/available_umbrella_field.dart';
import 'package:beachu/components/new_edit_bathpage/city_field.dart';
import 'package:beachu/components/new_edit_bathpage/name_field.dart';
import 'package:beachu/components/new_edit_bathpage/phone_field.dart';
import 'package:beachu/components/new_edit_bathpage/province_field.dart';
import 'package:beachu/components/new_edit_bathpage/tot_umbrellas_field.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/functions.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class NewBath extends StatefulWidget {
  static final String id = 'new_bath_screen';

  @override
  _NewBathState createState() => _NewBathState();
}

class _NewBathState extends State<NewBath> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _avUmbrellasController = TextEditingController();
  TextEditingController _totUmbrellasController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _provinceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        return Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: data.isLoading(),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NameField(controller: _nameController),
                    Row(
                      children: [
                        AvailUmbrellasField(controller: _avUmbrellasController),
                        SizedBox(width: 20.0),
                        TotalUmbrellasField(
                            controller: _totUmbrellasController),
                      ],
                    ),
                    PhoneNumberField(controller: _phoneController),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        CityField(controller: _cityController),
                        SizedBox(width: 20.0),
                        ProvinceField(controller: _provinceController),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    SimpleButton(
                      title: 'Inserisci',
                      onPressed: () async {
                        bool _error = false;
                        if (_formKey.currentState!.validate() &&
                            _auth.currentUser != null) {
                          Position position = await getPosition();
                          Bath bath = Bath(
                            uid: _auth.currentUser!.uid,
                            name: _nameController.text,
                            avUmbrellas: _avUmbrellasController.text,
                            totUmbrellas: _totUmbrellasController.text,
                            phone: _phoneController.text,
                            latitude: position.latitude,
                            longitude: position.longitude,
                            city: _cityController.text,
                            province: _provinceController.text,
                          );
                          bool result = await data.postBath(bath);
                          if (result)
                            Navigator.pop(context);
                          else
                            _error = true;
                        } else
                          _error = true;

                        if (_error)
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
      },
    );
  }
}
