import 'package:beachu/components/snackbar.dart';
import 'package:beachu/components/new_edit_bathpage/bath_field.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/providers/bath_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BathIndex;
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        Bath _bath = data.bath[args.index];
        return Scaffold(
          appBar: AppBar(
            title: const Text('Modifica Stabilimento'),
          ),
          body: ModalProgressHUD(
            inAsyncCall: data.loading,
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20.0),
                        BathField(
                          controller: _nameController,
                          initialValue: _bath.name,
                          labelText: 'Nome',
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            BathField(
                              controller: _avUmbrellasController,
                              inputType: TextInputType.number,
                              initialValue: _bath.avUmbrellas.toString(),
                              labelText: 'Disponibili',
                            ),
                            const SizedBox(width: 20.0),
                            BathField(
                              controller: _totUmbrellasController,
                              inputType: TextInputType.number,
                              initialValue: _bath.totUmbrellas.toString(),
                              labelText: 'Totali',
                            ),
                          ],
                        ),
                        BathField(
                          controller: _phoneController,
                          inputType: TextInputType.phone,
                          initialValue: _bath.phone,
                          labelText: 'Telefono',
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            BathField(
                              controller: _cityController,
                              initialValue: _bath.city,
                              labelText: 'City',
                            ),
                            const SizedBox(width: 20.0),
                            BathField(
                              controller: _provinceController,
                              initialValue: _bath.province,
                              labelText: 'Province',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        SimpleButton(
                          title: 'Update',
                          onPressed: () async {
                            bool _validate = _formKey.currentState!.validate(),
                                _result = false;
                            if (_formKey.currentState!.validate()) {
                              Bath bath = await data.makeRequest(
                                  data.userId,
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
