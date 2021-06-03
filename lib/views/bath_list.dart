import 'package:beachu/components/bathlistpage/bath_card.dart';
import 'package:beachu/constants.dart';
import 'package:beachu/models/bath_index.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/bath_page.dart';
import 'package:beachu/views/new_bath.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class BathListPage extends StatefulWidget {
  static final String id = 'bath_list_screen';
  @override
  _BathListPageState createState() => _BathListPageState();
}

class _BathListPageState extends State<BathListPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<BathProvider>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Stabilimenti disponibili'),
          ),
          floatingActionButton: (_auth.currentUser == null)
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () => Navigator.pushNamed(context, NewBath.id),
                )
              : null,
          body: ModalProgressHUD(
            inAsyncCall: data.isLoading(),
            child: Container(
                width: double.infinity,
                child: (data.getBathItemCount() > 0)
                    ? Column(
                        children: [
                          SizedBox(height: 15),
                          Text(
                            data.getBathItem(0).city,
                            style: kTitleListStyle,
                          ),
                          SizedBox(height: 15),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.getBathItemCount(),
                              itemBuilder: (context, index) {
                                Bath _bath = data.getBathItem(index);
                                return BathCard(
                                  title: _bath.name,
                                  availableUmbrella: _bath.avUmbrellas,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    BathPage.id,
                                    arguments: BathIndex(index),
                                  ),
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
                            data.getMessage(),
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
