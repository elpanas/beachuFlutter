import 'package:beachu/components/bathlistpage/bath_alert.dart';
import 'package:beachu/components/favlistpage/fav_card.dart';
import 'package:beachu/components/message.dart';
import 'package:beachu/components/snackbar.dart';
import 'package:beachu/constants.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/providers/fav_provider.dart';
import 'package:beachu/views/bath_page.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: use_key_in_widget_constructors
class FavListPage extends StatelessWidget {
  static const String id = 'fav_list_screen';
  @override
  Widget build(BuildContext context) {
    return Consumer2<BathProvider, FavProvider>(
      builder: (context, data, favP, child) {
        var favBaths = favP.favList;
        return WillPopScope(
          onWillPop: () async {
            if (data.bathCount == 1) {
              data.loadBaths();
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
                title: Text(
              'fav_list_title',
              style: kAppBarTextStyle,
            ).tr()),
            body: ModalProgressHUD(
              inAsyncCall: data.loading,
              child: SizedBox(
                width: double.infinity,
                child: (!favP.favList.isEmpty)
                    ? Column(
                        children: [
                          const SizedBox(height: 15),
                          Expanded(
                            child: ListView.builder(
                              itemCount: favBaths.length,
                              itemBuilder: (context, index) {
                                return FavCard(
                                  key: UniqueKey(),
                                  title: favBaths[index].name,
                                  city: favBaths[index].city,
                                  onTap: () {
                                    data.loadBath(favBaths[index].bid);
                                    Navigator.pushNamed(
                                      context,
                                      BathPage.id,
                                      arguments: BathIndex(
                                        index: 0,
                                        favIndex: index,
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return DeleteAlert(
                                          onPressed: () {
                                            favP.delFav(index);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              snackBarBuilder(
                                                  title: 'bath_deleted'.tr()),
                                            );
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
          ),
        );
      },
    );
  }
}
