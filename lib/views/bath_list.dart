import 'package:beachu/components/action_button.dart';
import 'package:beachu/components/bathlistpage/bath_alert.dart';
import 'package:beachu/components/bathlistpage/bath_card.dart';
import 'package:beachu/components/message.dart';
import 'package:beachu/components/snackbar.dart';
import 'package:beachu/components/add_button.dart';
import 'package:beachu/constants.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/bath_page.dart';
import 'package:beachu/views/fav_list.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BathListPage extends StatelessWidget {
  static final String id = 'bath_list_screen';
  @override
  Widget build(BuildContext context) {
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'bath_list_title',
              style: kAppBarTextStyle,
            ).tr(),
            actions: [
              if (data.userId != '')
                ActionIconButton(
                  icon: Icons.admin_panel_settings,
                  onPressed: () => data.loadManagerBaths(),
                ),
              ActionIconButton(
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
            child: Container(
              width: double.infinity,
              child: (data.bathCount > 0)
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
                                  if (data.userId != '')
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return DeleteAlert(
                                          onPressed: () async {
                                            bool result =
                                                await data.deleteBath(index);
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
      },
    );
  }
}
