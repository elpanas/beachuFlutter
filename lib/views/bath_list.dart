import 'package:beachu/components/action_button.dart';
import 'package:beachu/components/bathlistpage/bath_alert.dart';
import 'package:beachu/components/bathlistpage/bath_card.dart';
import 'package:beachu/constants.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/bath_page.dart';
import 'package:beachu/views/new_bath.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class BathListPage extends StatefulWidget {
  static final String id = 'bath_list_screen';
  @override
  _BathListPageState createState() => _BathListPageState();
}

class _BathListPageState extends State<BathListPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Available Baths'),
            actions: [
              if (data.userId != '')
                ActionIconButton(
                  icon: Icons.admin_panel_settings,
                  onPressed: () => data.loadManagerBaths(),
                ),
            ],
          ),
          floatingActionButton: (data.userId != '')
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Colors.orange,
                  onPressed: () => Navigator.pushNamed(context, NewBath.id),
                )
              : null,
          body: ModalProgressHUD(
            inAsyncCall: data.loading,
            child: Container(
                width: double.infinity,
                child: (data.bathCount > 0)
                    ? Column(
                        children: [
                          SizedBox(height: 15),
                          Text(
                            data.bath[0].city,
                            style: kTitleListStyle,
                          ),
                          SizedBox(height: 15),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.bathCount,
                              itemBuilder: (context, index) {
                                return BathCard(
                                  title: data.bath[index].name,
                                  availableUmbrella:
                                      data.bath[index].avUmbrellas,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    BathPage.id,
                                    arguments: BathIndex(index),
                                  ),
                                  onLongPress: () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return DeleteAlert(
                                          onPressed: () async {
                                            bool result =
                                                await data.deleteBath(index);
                                            if (result) Navigator.pop(context);
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
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            data.message,
                            style: kMessageStyle,
                          )
                        ],
                      )),
          ),
        );
      },
    );
  }
}
