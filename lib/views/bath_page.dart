import 'package:beachu/components/action_button.dart';
import 'package:beachu/components/bathpage/bath_container.dart';
import 'package:beachu/components/bathpage/bath_subtitle.dart';
import 'package:beachu/components/bathpage/bath_title.dart';
import 'package:beachu/components/bathpage/umbrella_button.dart';
import 'package:beachu/components/snackbar.dart';
import 'package:beachu/components/simple_button.dart';
import 'package:beachu/main.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/views/edit_bath.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: use_key_in_widget_constructors
class BathPage extends ConsumerWidget {
  static const String id = 'bath_screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as BathIndex;
    final data = ref.watch(bathProvider);
    Bath _bath = data.bath[args.index];
    return ModalProgressHUD(
      inAsyncCall: data.loading,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            (data.userId != _bath.uid)
                ? ActionIconButton(
                    key: UniqueKey(),
                    icon: (_bath.fav) ? Icons.favorite : Icons.favorite_outline,
                    onPressed: () {
                      (_bath.fav)
                          ? data.delFav(args.index)
                          : data.addFav(args.index);
                    },
                  )
                : ActionIconButton(
                    key: UniqueKey(),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              BathTitle(title: _bath.name),
              const SizedBox(height: 5.0),
              BathSubTitle(),
              Row(
                children: [
                  BathContainer(
                    title: 'bath_available'.tr(),
                    icon: Icons.beach_access,
                    colour: Colors.green,
                    info: data.bath[args.index].avUmbrellas.toString(),
                  ),
                  BathContainer(
                    onPressed: () => data.openMap(args.index),
                    title: 'bath_position'.tr(),
                    icon: Icons.location_on,
                    colour: Colors.blue,
                    info: 'bath_openmap'.tr(),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              (data.userId != _bath.uid)
                  ? SimpleButton(
                      title: 'bath_call'.tr(),
                      onPressed: () async => await data.callNumber(args.index),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UmbrellasIconButton(
                          key: UniqueKey(),
                          icon: Icons.remove,
                          onPressed: () async {
                            bool _result =
                                await data.decreaseUmbrellas(args.index);
                            if (!_result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackBarBuilder(title: 'bath_min'.tr()),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 20.0),
                        UmbrellasIconButton(
                          key: UniqueKey(),
                          icon: Icons.add,
                          onPressed: () async {
                            bool _result =
                                await data.increaseUmbrellas(args.index);
                            if (!_result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackBarBuilder(title: 'bath_max'.tr()),
                              );
                            }
                          },
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
