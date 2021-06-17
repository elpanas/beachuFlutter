import 'package:beachu/components/bathlistpage/bath_alert.dart';
import 'package:beachu/components/bathlistpage/bath_card.dart';
import 'package:beachu/components/snackbar.dart';
import 'package:beachu/constants.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/models/hive_model.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/bath_page.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class FavListPage extends StatefulWidget {
  static final String id = 'fav_list_screen';
  @override
  _FavListPageState createState() => _FavListPageState();
}

class _FavListPageState extends State<FavListPage> {
  List<dynamic> favBaths = [];
  @override
  Widget build(BuildContext context) {
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        favBaths = data.loadFavList;
        return Scaffold(
          appBar: AppBar(title: const Text('fav_list_title').tr()),
          body: ModalProgressHUD(
            inAsyncCall: data.loading,
            child: Container(
              width: double.infinity,
              child: (data.bathCount > 0)
                  ? Column(
                      children: [
                        const SizedBox(height: 15),
                        Expanded(
                          child: ListView.builder(
                            itemCount: favBaths.length,
                            itemBuilder: (context, index) {
                              return BathCard(
                                title: favBaths[index].name,
                                city: favBaths[index].city,
                                onTap: () {
                                  bool result =
                                      data.loadBath(favBaths[index].bid);
                                  (result)
                                      ? Navigator.pushNamed(
                                          context,
                                          BathPage.id,
                                          arguments: BathIndex(
                                            index: 0,
                                            favIndex: index,
                                          ),
                                        )
                                      : ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          snackBarBuilder(
                                            title: 'snack_msg'.tr(),
                                          ),
                                        );
                                },
                                onLongPress: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return DeleteAlert(
                                        onPressed: () {
                                          data.delFav(index);
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
                  : Center(
                      child: Text(
                        data.message,
                        style: kMessageStyle,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
