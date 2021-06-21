import 'package:beachu/components/action_button.dart';
import 'package:beachu/components/bathpage/bath_container.dart';
import 'package:beachu/components/bathpage/bath_subtitle.dart';
import 'package:beachu/components/bathpage/bath_title.dart';
import 'package:beachu/components/bathpage/umbrella_button.dart';
import 'package:beachu/components/snackbar.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/edit_bath.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BathPage extends StatelessWidget {
  static final String id = 'bath_screen';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BathIndex;
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        Bath _bath = data.bath[args.index];
        return ModalProgressHUD(
          inAsyncCall: data.loading,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                (data.userId != _bath.uid)
                    ? ActionIconButton(
                        icon: (_bath.fav)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        onPressed: () {
                          (_bath.fav)
                              ? data.delFav(args.index)
                              : data.addFav(args.index);
                        },
                      )
                    : ActionIconButton(
                        icon: Icons.edit,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            EditBath.id,
                            arguments: BathIndex(index: args.index),
                          );
                        },
                      ),
              ],
            ),
            body: Column(
              children: [
                BathTitle(title: _bath.name),
                const SizedBox(height: 5.0),
                BathSubTitle(),
                Row(
                  children: [
                    Expanded(
                      child: BathContainer(
                        title: 'bath_available'.tr(),
                        icon: Icons.beach_access,
                        colour: Colors.green,
                        info: data.bath[args.index].avUmbrellas.toString(),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => data.openMap(args.index),
                        child: BathContainer(
                          title: 'bath_position'.tr(),
                          icon: Icons.location_on,
                          colour: Colors.blue,
                          info: 'bath_openmap'.tr(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                (_auth.currentUser?.uid != _bath.uid)
                    ? SimpleButton(
                        title: 'bath_call'.tr(),
                        onPressed: () => data.callNumber(args.index),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UmbrellasIconButton(
                            icon: Icons.remove,
                            onPressed: () async {
                              bool _result =
                                  await data.decreaseUmbrellas(args.index);
                              if (!_result)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  snackBarBuilder(title: 'bath_min'.tr()),
                                );
                            },
                          ),
                          const SizedBox(width: 20.0),
                          UmbrellasIconButton(
                            icon: Icons.add,
                            onPressed: () async {
                              bool _result =
                                  await data.increaseUmbrellas(args.index);
                              if (!_result)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  snackBarBuilder(title: 'bath_max'.tr()),
                                );
                            },
                          ),
                        ],
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
