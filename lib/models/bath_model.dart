import 'package:flutter/cupertino.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:maps_launcher/maps_launcher.dart';

class Bath extends ChangeNotifier {
  final String? bid;
  final String uid;
  String name, phone, city, province;
  int avUmbrellas, totUmbrellas;
  double latitude, longitude;

  Bath({
    this.bid,
    required this.uid,
    required this.name,
    required this.avUmbrellas,
    required this.totUmbrellas,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.province,
  });

  factory Bath.fromJson(Map<String, dynamic> json) {
    return Bath(
      bid: json['_id'],
      uid: json['uid'],
      name: json['name'],
      avUmbrellas: json['av_umbrellas'],
      totUmbrellas: json['tot_umbrellas'],
      phone: json['phone'],
      latitude: json['location']['coordinates'][0],
      longitude: json['location']['coordinates'][1],
      city: json['city'],
      province: json['province'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'av_umbrellas': avUmbrellas,
        'tot_umbrellas': totUmbrellas,
        'phone': phone,
        'location': {
          'type': "Point",
          'coordinates': [longitude, latitude]
        },
        'city': city,
        'province': province
      };

  void callNumber() async {
    await FlutterPhoneDirectCaller.callNumber(phone);
  }

  void openMap(index) {
    MapsLauncher.launchCoordinates(
      latitude,
      longitude,
      name,
    );
  }
}
