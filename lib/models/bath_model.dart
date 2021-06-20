import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bath_model.g.dart';

class Bath extends ChangeNotifier {
  String? bid;
  String uid;
  String name, phone, city, province;
  int avUmbrellas, totUmbrellas;
  double latitude, longitude;
  bool fav;

  @JsonSerializable()
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
    required this.fav,
  });

  factory Bath.fromJson(Map<String, dynamic> json) => _$BathFromJson(json);
  Map<String, dynamic> toJson() => _$BathToJson(this);
}
