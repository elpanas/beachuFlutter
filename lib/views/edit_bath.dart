import 'package:beachu/components/snackbar.dart';
import 'package:beachu/components/new_edit_bathpage/bath_field.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/constants.dart';
import 'package:beachu/main.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

// ignore: use_key_in_widget_constructors
class EditBath extends ConsumerStatefulWidget {
  static const String id = 'edit_bath_screen';
  @override
  _EditBathState createState() => _EditBathState();
}

class _EditBathState extends ConsumerState<EditBath> {
  final _nameController = TextEditingController(),
      _avUmbrellasController = TextEditingController(),
      _totUmbrellasController = TextEditingController(),
      _phoneController = TextEditingController(),
      _cityController = TextEditingController(),
      _provinceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(bathProvider);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _totUmbrellasController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BathIndex;
    final data = ref.watch(bathProvider);
    Bath _bath = data.bath[args.index];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _bath.name,
          style: kAppBarTextStyle,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: data.loading,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: kH20Padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20.0),
                    BathField(
                      controller: _nameController,
                      initialValue: _bath.name,
                      labelText: 'bath_name'.tr(),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        BathField(
                          controller: _avUmbrellasController,
                          inputType: TextInputType.number,
                          initialValue: _bath.avUmbrellas.toString(),
                          labelText: 'bath_av_input'.tr(),
                        ),
                        const SizedBox(width: 20.0),
                        BathField(
                          controller: _totUmbrellasController,
                          inputType: TextInputType.number,
                          initialValue: _bath.totUmbrellas.toString(),
                          labelText: 'bath_tot'.tr(),
                        ),
                      ],
                    ),
                    BathField(
                      controller: _phoneController,
                      inputType: TextInputType.phone,
                      initialValue: _bath.phone,
                      labelText: 'bath_phone'.tr(),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        BathField(
                          controller: _cityController,
                          initialValue: _bath.city,
                          labelText: 'bath_city'.tr(),
                        ),
                        const SizedBox(width: 20.0),
                        BathField(
                          controller: _provinceController,
                          initialValue: _bath.province,
                          labelText: 'bath_province'.tr(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    SimpleButton(
                      title: 'edit_button'.tr(),
                      onPressed: () async {
                        bool _validate = _formKey.currentState!.validate(),
                            _result = false;
                        if (_formKey.currentState!.validate()) {
                          Bath bath = await data.makeRequest(
                            _nameController.text,
                            int.parse(_avUmbrellasController.text),
                            int.parse(_totUmbrellasController.text),
                            _phoneController.text,
                            _cityController.text,
                            _provinceController.text,
                          );
                          _result = await data.putBath(
                              http.Client(), bath, args.index);
                          if (_result) Navigator.pop(context);
                        }

                        if (!_validate || !_result) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBarBuilder(title: 'snack_msg'.tr()),
                          );
                        }
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
  }
}
