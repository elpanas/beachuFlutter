import 'package:beachu/components/action_button.dart';
import 'package:beachu/components/bathlistpage/bath_alert.dart';
import 'package:beachu/components/bathlistpage/bath_card.dart';
import 'package:beachu/components/message.dart';
import 'package:beachu/components/snackbar.dart';
import 'package:beachu/components/add_button.dart';
import 'package:beachu/constants.dart';
import 'package:beachu/main.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/views/bath_page.dart';
import 'package:beachu/views/fav_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

// ignore: use_key_in_widget_constructors
class BathListPage extends ConsumerWidget {
  static const String id = 'bath_list_screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(bathProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'bath_list_title',
          style: kAppBarTextStyle,
        ).tr(),
        actions: [
          if (data.userId != '')
            ActionIconButton(
              key: UniqueKey(),
              icon: Icons.admin_panel_settings,
              onPressed: () => data.loadManagerBaths(),
            ),
          ActionIconButton(
            key: UniqueKey(),
            icon: Icons.list,
            onPressed: () {
              data.loadFavList();
              Navigator.pushNamed(context, FavListPage.id);
            },
          ),
        ],
      ),
      floatingActionButton: (data.userId != '') ? FloatingAdd() : null,
      body: ModalProgressHUD(
        inAsyncCall: data.loading,
        child: SizedBox(
          width: double.infinity,
          child: (!data.bath.isEmpty)
              ? Column(
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      data.bath[0].city,
                      style: kTitleListStyle,
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.bathCount,
                        itemBuilder: (context, index) {
                          return BathCard(
                            key: UniqueKey(),
                            title: data.bath[index].name,
                            availableUmbrella: data.bath[index].avUmbrellas,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                BathPage.id,
                                arguments: BathIndex(index: index),
                              );
                            },
                            onLongPress: () {
                              if (data.userId != '') {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return DeleteAlert(
                                      onPressed: () async {
                                        bool result = await data.deleteBath(
                                            http.Client(), index);
                                        if (result) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            snackBarBuilder(
                                              title: 'bath_deleted'.tr(),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Message(message: data.message),
        ),
      ),
    );
  }
}
